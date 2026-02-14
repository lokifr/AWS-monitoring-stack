# 📸 Project Screenshots

Documenting the AWS Monitoring Stack setup, verification, and alert testing.

## 1. AWS Infrastructure
**EC2 Dashboard:**

<img width="1919" height="967" alt="Screenshot 2026-02-14 195958" src="https://github.com/user-attachments/assets/065b4685-8d9d-4aca-8f07-00a916670cb8" />



**Security Groups:**


<img width="1919" height="863" alt="Screenshot 2026-02-14 200028" src="https://github.com/user-attachments/assets/b2cdfb5f-ade0-468b-bb0d-c54d563f5e7d" />


---

## 2. Prometheus (Data Collection)
**Target Status (Healthy):**
<img width="1918" height="887" alt="Screenshot 2026-02-14 200102" src="https://github.com/user-attachments/assets/f2f9df0e-c2ba-466b-87cd-621f74212c54" />


**Scrape Configuration:**
<img width="1910" height="838" alt="Screenshot 2026-02-14 200120" src="https://github.com/user-attachments/assets/305941d0-4410-4af8-802e-ce7c7bcd5b4d" />

**Node Exporter (Raw Metrics):**
<img width="1919" height="802" alt="Screenshot 2026-02-14 200702" src="https://github.com/user-attachments/assets/bd304dd3-4d9c-4a88-8667-7dcd60dc99b3" />


---

## 3. Grafana (Visualization)
**Data Source Connection:**
<img width="1919" height="900" alt="Screenshot 2026-02-14 200917" src="https://github.com/user-attachments/assets/2a94842b-fefc-437d-908e-d46ab043ee82" />


**Node Exporter Dashboard:**

<img width="1919" height="941" alt="Screenshot 2026-02-14 200829" src="https://github.com/user-attachments/assets/24d493bc-947a-4feb-b4c7-1766e2ee1499" />


---

## 4. Alerting Pipeline Test (The "Instance Down" Scenario)

### Step 1: Simulaton
command run: `sudo systemctl stop node_exporter`

### Step 2: Detection
**Prometheus Alerts (Firing):**


**Alertmanager Status:**
<img width="1919" height="765" alt="Screenshot 2026-02-14 201333" src="https://github.com/user-attachments/assets/ce7d6b49-eacb-45c1-89b4-343f3c7705f3" />

### Step 3: Notification
**Slack Alert:**
<img width="1908" height="858" alt="Screenshot 2026-02-14 201400" src="https://github.com/user-attachments/assets/b3fda9a5-57dd-4fe9-b4c2-9cd31529b93d" />


**Email Alert:**
<img width="1600" height="710" alt="Screenshot 2026-02-14 201430" src="https://github.com/user-attachments/assets/0f654666-73c6-4004-bced-4dceeb423fd9" />



---

## 5. Recovery
### Step 1: Resolution
command run: `sudo systemctl restart node_exporter`

### Step 2: Resolved Notifications
**Slack Resolved:**
<img width="1807" height="831" alt="Screenshot 2026-02-14 201837" src="https://github.com/user-attachments/assets/966ece75-5b21-425d-af10-c6f924a404f9" />

**Email Resolved:**
<img width="1597" height="697" alt="Screenshot 2026-02-14 201638" src="https://github.com/user-attachments/assets/39ac6cae-ead9-4db3-a5fb-5cb4b14fff60" />

