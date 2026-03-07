# Deployment Guide: AWS Prometheus & Grafana Monitoring Stack

This guide provides step-by-step instructions to deploy a completely container-less (native systemd services) Prometheus and Grafana monitoring stack on an AWS EC2 instance.

## 📋 Prerequisites

Before you begin, ensure you have the following installed on your local machine:

- **AWS CLI** properly configured (`aws configure`) with valid credentials.
- **Git Bash** or WSL (if you are on Windows) to execute the shell scripts.
- **SSH client** installed.

---

## 🚀 Step 1: Provision AWS Infrastructure

The deployment process is heavily automated using bash scripts. The first step generates all required AWS resources.

The `provision-aws-infrastructure.sh` script automatically creates:

- A new **VPC** (`10.0.0.0/16`) and **Public Subnet**.
- An **Internet Gateway** and **Route Table**.
- A **Security Group** (`PrometheusSG`) allowing inbound traffic for SSH (`22`), Prometheus (`9090`), Grafana (`3000`), and Alertmanager (`9093`).
- An **EC2 Key Pair** named `us-east1.pem`.
- An **EC2 Instance** (`t3.medium`) running Ubuntu 22.04 LTS.

To provision the infrastructure:

```bash
cd scripts
./provision-aws-infrastructure.sh
```

**Note:** Save the output of this script! It will contain your newly created instance's **Public IP** and the exact **SSH Command** needed to connect.

---

## 🔑 Step 2: Upload Configuration and Scripts

Once the EC2 instance is running, you need to transfer the installation scripts and configuration files to the server.

From your local machine's `monitoring` project root, run the following secure copy (`scp`) command. Replace `<PublicIP>` with your instance's actual IP address:

```bash
# Ensure the key pair has the correct permissions (if on Linux/Mac/WSL)
chmod 400 scripts/us-east1.pem

# Secure copy scripts and configs to the instance
scp -i "scripts/us-east1.pem" scripts/*.sh config/*.yml ubuntu@<PublicIP>:~
```

---

## 🛠 Step 3: Connect to the Instance

SSH into your freshly provisioned EC2 instance:

```bash
ssh -i "scripts/us-east1.pem" ubuntu@<PublicIP>
```

---

## ⚙️ Step 4: Install the Monitoring Services

Now that you are connected to the EC2 instance, make the uploaded scripts executable and install the services sequentially.

These scripts will download the required binaries, set up dedicated system users, configure directories, and create `systemd` services to ensure the tools run continuously in the background.

```bash
# Make all scripts executable
chmod +x *.sh

# 1. Install Prometheus
./install-prometheus.sh

# 2. Install Node Exporter (For Hardware/OS metrics)
./install-node-exporter.sh

# 3. Install Alertmanager
./install-alertmanager.sh

# 4. Install Grafana
./install-grafana.sh
```

---

## alerts Step 5: Configure Notifications (Slack / Email)

Alertmanager controls where your alerts are routed. By default, it uses a template. You need to provide your actual Slack Webhook URL and SMTP (Email) credentials.

1. Open the uploaded `alertmanager.yml` file on your EC2 instance:

   ```bash
   nano ~/alertmanager.yml
   ```

2. Update the Slack API URL and Email SMTP settings with your credentials.
3. Move the configuration file to the correct directory and restart Alertmanager:

   ```bash
   sudo mv ~/alertmanager.yml /etc/alertmanager/alertmanager.yml
   sudo systemctl restart alertmanager
   sudo systemctl status alertmanager
   ```

---

## 📊 Step 6: Access the Dashboards

With the installation complete, you can access the web interfaces for the services using your browser. Replace `<PublicIP>` with the public IP address of your EC2 instance:

| Service | Address / URL | Default Credentials | Description |
| :--- | :--- | :--- | :--- |
| **Prometheus** | `http://<PublicIP>:9090` | N/A | View targets, active alerts, and test PromQL queries. |
| **Grafana** | `http://<PublicIP>:3000` | `admin` / `admin` | Build and view system metric dashboards. |
| **Alertmanager**| `http://<PublicIP>:9093` | N/A | View grouped alerts and silence notifications. |

*Note: On your first login to Grafana, you will be prompted to change the default `admin` password.*

---

## 🧹 Teardown & Cleanup

When you are done testing or no longer need the monitoring stack, you can completely clean up the AWS environment to avoid ongoing charges.

From your **local machine**, navigate to your `scripts` directory and run:

```bash
cd scripts
./cleanup-aws-infrastructure.sh
```

This script safely and systematically deletes the EC2 Instance, Key Pair, Security Group, Subnet, Route Table, Internet Gateway, and VPC.
