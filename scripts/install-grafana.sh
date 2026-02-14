#!/bin/bash

echo "Installing Grafana..."

# 1. Install prerequisites
sudo apt-get install -y apt-transport-https software-properties-common wget

# 2. Add GPG Key
sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null

# 3. Add Repository
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list

# 4. Install Grafana
sudo apt-get update
sudo apt-get install -y grafana

# 5. Start and Enable Service
sudo systemctl daemon-reload
sudo systemctl start grafana-server
sudo systemctl enable grafana-server

# 6. Check Status
sudo systemctl status grafana-server --no-pager

echo "Grafana installed and started! Access it at http://<PublicIP>:3000"
