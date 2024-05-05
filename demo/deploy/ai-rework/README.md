# Kubernetes Deployment Enhancements Documentation

This document outlines various enhancements made to the Kubernetes deployment defined in `go-demo-deployment.yaml`. Each modification is applied through the use of the `kubectl-ai` command, detailed below in the table.

## Enhancements Table

| NAME                           | PROMPT                                              | DESCRIPTION                                                                                          | EXAMPLE                                             |
| ------------------------------ | --------------------------------------------------- | ---------------------------------------------------------------------------------------------------- | --------------------------------------------------- |
| Cost Optimization              | "Do the best you can. Cost optimize"                | Adjusts the deployment to optimize for cost, potentially integrating Horizontal Pod Autoscaling.    | [View YAML](./app.yaml)                         |
| Add Liveness Probe             | "Do the best you can. Add livenessProbe"            | Adds a liveness probe to the deployment to check the health of the application.                     | [View YAML](./app-livenessProbe.yaml)           |
| Add Readiness Probe            | "Do the best you can. Add readinessProbe"           | Adds a readiness probe to the deployment to ensure the application is ready to receive traffic.     | [View YAML](./app-readinessProbe.yaml)          |
| Add Volume Mounts              | "Do the best you can. Add volumeMounts"             | Configures persistent storage and mounts configuration files.                                        | [View YAML](./app-volumeMounts.yaml)            |
| CronJob for Coffee Price       | "Do the best you can. Add cronjob that monitors coffee price. If it rises then scale down pods" | Creates a CronJob that monitors coffee prices and scales down pods accordingly.                      | [View YAML](./app-cronjob.yaml)                 |
| Security Scan Job              | "Do the best you can. Add run job that will scan for security vulnerabilities inside pod and send alert email to owner" | Sets up a job to scan for security vulnerabilities in the pod and alerts the owner by email.        | [View YAML](./app-job.yaml)                     |
| Integrate ELK Stack            | "Do the best you can. Add elk pods to multicontainer and automate logging in Grafana" | Integrates Elasticsearch, Logstash, and Kibana into a multi-container setup with Grafana logging.   | [View YAML](./app-multicontainer.yaml)          |
| Specify Resource Limits        | "Do the best you can. Specify memory and cpu limits" | Specifies memory and CPU limits for the containers in the deployment.                                | [View YAML](./app-resources.yaml)               |
| Manage Secrets                 | "Do the best you can. Manage secrets mount and publish inside pods following best industry practices." | Manages secret mounting and environment variable publication inside pods securely.                  | [View YAML](./app-secret-env.yaml)              |
