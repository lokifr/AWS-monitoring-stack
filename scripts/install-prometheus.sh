#!/bin/bash

# Variables
PROM_VERSION="2.45.0"
PROM_FOLDER="prometheus-${PROM_VERSION}.linux-amd64"
PROM_URL="https://github.com/prometheus/prometheus/releases/download/v${PROM_VERSION}/${PROM_FOLDER}.tar.gz"

echo "Using version: $PROM_VERSION"

# 1. Create User
echo "Creating prometheus user..."
sudo useradd --no-create-home --shell /bin/false prometheus

# 2. Create Directories
echo "Creating directories..."
sudo mkdir -p /etc/prometheus
sudo mkdir -p /var/lib/prometheus
sudo chown prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus

# 3. Download and Extract
echo "Downloading Prometheus..."
cd /tmp
wget -q $PROM_URL
tar -xvf ${PROM_FOLDER}.tar.gz
cd $PROM_FOLDER

# 4. Move Binaries
echo "Installing binaries..."
sudo cp prometheus /usr/local/bin/
sudo cp promtool /usr/local/bin/
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool

# 5. Move Config (Default or Custom)
echo "Installing config..."
# Assuming prometheus.yml is in the same directory as this script or /tmp if uploaded
if [ -f "prometheus.yml" ]; then
    echo "Found prometheus.yml, using it."
    sudo cp prometheus.yml /etc/prometheus/
else
    echo "Using default prometheus.yml."
    sudo cp prometheus.yml /etc/prometheus/
    sudo cp -r consoles /etc/prometheus
    sudo cp -r console_libraries /etc/prometheus
fi

sudo chown -R prometheus:prometheus /etc/prometheus

# 6. Create Systemd Service
echo "Creating systemd service..."
sudo tee /etc/systemd/system/prometheus.service > /dev/null <<EOF
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOF

# 7. Start Service
echo "Starting Prometheus..."
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus

# 8. Check Status
sudo systemctl status prometheus --no-pager

echo "Prometheus installed and started!"
