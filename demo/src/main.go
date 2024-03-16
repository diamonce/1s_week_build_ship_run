package main

import "net/http"

func main() {
	http.ListenAndServe(":8088", http.FileServer(http.Dir("./html")))
}
