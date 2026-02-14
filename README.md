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

```mermaid
graph LR
    User[User]
    
    subgraph EC2["EC2 t3.medium"]
        NE[Node Exporter<br/>:9100]
        P[Prometheus<br/>:9090]
        AM[Alertmanager<br/>:9093]
        G[Grafana<br/>:3000]
    end
    
    S[Slack]
    E[Email]
    
    User --> G
    User --> P
    P <--> NE
    G <--> P
    P --> AM
    AM --> S
    AM --> E
    
    classDef tool fill:#bbdefb,stroke:#1976d2,stroke-width:2px
    classDef alert fill:#ffccbc,stroke:#d84315,stroke-width:2px
    classDef viz fill:#fff59d,stroke:#f57c00,stroke-width:2px
    classDef notify fill:#c8e6c9,stroke:#388e3c,stroke-width:2px
    
    class NE,P tool
    class AM alert
    class G viz
    class S,E notify
    
````

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
