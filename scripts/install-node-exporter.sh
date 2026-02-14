#!/bin/bash

# Variables
NODE_EXP_VERSION="1.6.1"
NODE_EXP_FOLDER="node_exporter-${NODE_EXP_VERSION}.linux-amd64"
NODE_EXP_URL="https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXP_VERSION}/${NODE_EXP_FOLDER}.tar.gz"

echo "Using Node Exporter version: $NODE_EXP_VERSION"

# 1. Create User
echo "Creating node_exporter user..."
sudo useradd --no-create-home --shell /bin/false node_exporter

# 2. Download and Extract
echo "Downloading Node Exporter..."
cd /tmp
wget -q $NODE_EXP_URL
tar -xvf ${NODE_EXP_FOLDER}.tar.gz
cd $NODE_EXP_FOLDER

# 3. Move Binaries
echo "Installing binary..."
sudo cp node_exporter /usr/local/bin/
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

# 4. Create Systemd Service
echo "Creating systemd service..."
sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<EOF
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

# 5. Start Service
echo "Starting Node Exporter..."
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter

# 6. Check Status
sudo systemctl status node_exporter --no-pager

echo "Node Exporter installed and started!"
