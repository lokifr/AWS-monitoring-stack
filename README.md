# AWS Prometheus & Grafana Monitoring
![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=Prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/grafana-%23F46800.svg?style=for-the-badge&logo=grafana&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Alertmanager](https://img.shields.io/badge/Alertmanager-E6522C?style=for-the-badge&logo=prometheus&logoColor=white)
![Slack](https://img.shields.io/badge/Slack-4A154B?style=for-the-badge&logo=slack&logoColor=white)
![Node Exporter](https://img.shields.io/badge/Node_Exporter-E6522C?style=for-the-badge&logo=prometheus&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)

A comprehensive monitoring stack deployed on AWS using Prometheus for metrics collection, Grafana for visualization, and Alertmanager for notifications (Slack/Email).

## 🏗 Architecture
<img width="774" height="814" alt="Screenshot 2026-02-15 103908" src="https://github.com/user-attachments/assets/7517126c-f2a9-4cae-a048-546e1fbe3378" />



## 🚀 Components
*   **Prometheus (v2.45.0):** Time-series database.
*   **Grafana:** Metrics visualization platform.
*   **Alertmanager:** Handles alert deduplication, grouping, and routing.
*   **Node Exporter:** Exposes hardware and OS metrics.



## 📊 Access Dashboards

| Service | URL | Default Creds |
| :--- | :--- | :--- |
| **Prometheus** | `http://<PublicIP>:9090` | N/A |
| **Grafana** | `http://<PublicIP>:3000` | `admin` / `admin` |
| **Alertmanager** | `http://<PublicIP>:9093` | N/A |

## 🚨 Alerts Configured
*   **InstanceDown:** Triggers when an instance is down for > 1 minute.
*   **HostHighCpuLoad:** Triggers when CPU usage > 80% for 2 minutes.
*   **HostHighMemoryUsage:** Triggers when Memory usage > 90% for 2 minutes.
*   **HostOutOfDiskSpace:** Triggers when Disk usage > 90% for 2 minutes.


## Documentation formatting and structure assisted by AI tools
