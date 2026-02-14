# AWS Prometheus & Grafana Monitoring

A comprehensive monitoring stack deployed on AWS using Prometheus for metrics collection, Grafana for visualization, and Alertmanager for notifications (Slack/Email).

## 🏗 Architecture

```mermaid
graph TB
    %% External Access
    User["👤 User"]
    
    %% AWS Cloud
    subgraph AWS["☁️ AWS Cloud"]
        subgraph VPC["VPC: 10.0.0.0/16"]
            subgraph Subnet["Public Subnet"]
                
                subgraph Server["EC2 Instance (t3.medium)"]
                    NodeExp["Node Exporter<br/>:9100"]
                    Prom["Prometheus<br/>:9090"]
                    AlertMgr["Alertmanager<br/>:9093"]
                    Graf["Grafana<br/>:3000"]
                end
                
            end
        end
    end
    
    %% External Services
    Slack["Slack"]
    Email["Email"]
    
    %% Data Flow
    User --> Graf
    User --> Prom
    
    Prom <-->|Scrape| NodeExp
    Graf <-->|Query| Prom
    Prom -->|Alert| AlertMgr
    
    AlertMgr --> Slack
    AlertMgr --> Email
    
    linkStyle default stroke:#7F00FF,stroke-width:2px
    %% Styling
    classDef aws fill:#FF9900,stroke:#232F3E,stroke-width:3px,color:#FFF
    classDef vpc fill:#4A90E2,stroke:#2E5C8A,stroke-width:2px,color:#FFF
    classDef subnet fill:#50C878,stroke:#2D7A4A,stroke-width:2px,color:#FFF
    classDef server fill:#E8EAF6,stroke:#5C6BC0,stroke-width:2px,color:#1A237E
    classDef monitoring fill:#E53935,stroke:#C62828,stroke-width:2px,color:#FFF
    classDef visualization fill:#F57C00,stroke:#E65100,stroke-width:2px,color:#FFF
    classDef external fill:#26A69A,stroke:#00796B,stroke-width:2px,color:#FFF
    classDef user fill:#66BB6A,stroke:#388E3C,stroke-width:2px,color:#FFF
    
    class AWS aws
    class VPC vpc
    class Subnet subnet
    class Server server
    class Prom,AlertMgr,NodeExp monitoring
    class Graf visualization
    class Slack,Email external
    class User user
    
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
