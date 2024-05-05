document.addEventListener('DOMContentLoaded', function() {
    fetch('/status')
        .then(response => response.json())
        .then(serviceIds => {
            serviceIds.forEach(serviceId => {
                fetchServiceStatus(serviceId);
            });
        })
        .catch(error => console.error('Error fetching service IDs:', error));
});

function fetchServiceStatus(serviceId) {
    fetch(`/status/${serviceId}`)
        .then(response => response.json())
        .then(data => {
            updateTable(serviceId, data);
        })
        .catch(error => console.error(`Error fetching status for service ${serviceId}:`, error));
}

function updateTable(serviceId, data) {
    const tableBody = document.getElementById('statusTable').getElementsByTagName('tbody')[0];
    const row = tableBody.insertRow();
    const serviceIdCell = row.insertCell(0);
    const serviceNameCell = row.insertCell(1);
    const statusCell = row.insertCell(2);

    serviceIdCell.textContent = serviceId;
    serviceNameCell.textContent = data.service_name; // Adjust based on actual response structure
    statusCell.textContent = data.status; // Adjust based on actual response structure
}
