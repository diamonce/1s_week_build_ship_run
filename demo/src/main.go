package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"time"
)

type Service struct {
	ServiceId   string `json:"serviceId"`
	ServiceName string `json:"serviceName"`
	IPAddress   string `json:"ipAddress"`
	Port        int    `json:"port"`
	Protocol    string `json:"protocol"`
}

type Settings struct {
	Servers []Service `json:"servers"`
}

func checkService(service Service) ([]byte, error) {
	client := http.Client{
		Timeout: 3 * time.Second,
	}

	url := fmt.Sprintf("%s://%s:%d", service.Protocol, service.IPAddress, service.Port)
	resp, err := client.Get(url)

	status := "down \\/"
	if err == nil && resp.StatusCode == http.StatusOK {
		status = "up /\\"
		// Close connectin if there is no error
		defer resp.Body.Close()
	}

	return json.Marshal(map[string]string{
		"service_name": service.ServiceName,
		"status":       status,
	})
}

func main() {
	settings := Settings{
		Servers: []Service{
			{
				ServiceId:   "dc_depops_sp",
				ServiceName: "DevOps та Kubernetes 3.0 Status Page",
				IPAddress:   "34.116.191.131",
				Port:        80,
				Protocol:    "http",
			},
			{
				ServiceId:   "google",
				ServiceName: "Google",
				IPAddress:   "google.com",
				Port:        80,
				Protocol:    "http",
			},
			{
				ServiceId:   "olekluk",
				ServiceName: "OlekLUk",
				IPAddress:   "34.133.93.117",
				Port:        80,
				Protocol:    "http",
			},
		},
	}

	http.Handle("/", http.FileServer(http.Dir("./html")))

	http.HandleFunc("/version", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		response := map[string]string{"Version": "2.0.0"}
		jsonResponse, err := json.Marshal(response)
		if err != nil {
			http.Error(w, "Failed to marshal JSON", http.StatusInternalServerError)
			return
		}
		w.Write(jsonResponse)
	})

	http.HandleFunc("/status", func(w http.ResponseWriter, r *http.Request) {
		serviceIds := make([]string, len(settings.Servers))
		for i, service := range settings.Servers {
			serviceIds[i] = service.ServiceId
		}
		serviceIdsJson, err := json.Marshal(serviceIds)
		if err != nil {
			fmt.Println("Error marshaling service IDs to JSON:", err)
			return
		}

		w.Header().Set("Content-Type", "application/json")
		w.Write(serviceIdsJson)
	})

	for _, service := range settings.Servers {
		http.HandleFunc(fmt.Sprintf("/status/%s", service.ServiceId), func(w http.ResponseWriter, r *http.Request) {
			status, err := checkService(service)
			if err != nil {
				http.Error(w, "Error checking service status", http.StatusInternalServerError)
				return
			}
			w.Header().Set("Content-Type", "application/json")
			w.Write(status)
			// Note: This will write multiple JSON objects for each service; consider aggregating results
		})
	}

	fmt.Println("Server starting on :8088")
	if err := http.ListenAndServe(":8088", nil); err != nil {
		fmt.Printf("Error starting server: %s\n", err)
	}
}
