#!/bin/bash

# Variables
AM_VERSION="0.25.0"
AM_FOLDER="alertmanager-${AM_VERSION}.linux-amd64"
AM_URL="https://github.com/prometheus/alertmanager/releases/download/v${AM_VERSION}/${AM_FOLDER}.tar.gz"

echo "Using Alertmanager version: $AM_VERSION"

# 1. Create User
echo "Creating alertmanager user..."
sudo useradd --no-create-home --shell /bin/false alertmanager

# 2. Create Directories
echo "Creating directories..."
sudo mkdir -p /etc/alertmanager
sudo mkdir -p /var/lib/alertmanager
sudo chown alertmanager:alertmanager /etc/alertmanager
sudo chown alertmanager:alertmanager /var/lib/alertmanager

# 3. Download and Extract
echo "Downloading Alertmanager..."
cd /tmp
wget -q $AM_URL
tar -xvf ${AM_FOLDER}.tar.gz
cd $AM_FOLDER

# 4. Move Binaries
echo "Installing binary..."
sudo cp alertmanager /usr/local/bin/
sudo cp amtool /usr/local/bin/
sudo chown alertmanager:alertmanager /usr/local/bin/alertmanager
sudo chown alertmanager:alertmanager /usr/local/bin/amtool

# 5. Move Config
echo "Installing config..."
if [ -f "alertmanager.yml" ]; then
    echo "Found alertmanager.yml, using it."
    sudo cp alertmanager.yml /etc/alertmanager/
else
    echo "Using default alertmanager.yml."
    sudo cp alertmanager.yml /etc/alertmanager/
fi
sudo chown -R alertmanager:alertmanager /etc/alertmanager

# 6. Create Systemd Service
echo "Creating systemd service..."
sudo tee /etc/systemd/system/alertmanager.service > /dev/null <<EOF
[Unit]
Description=Alertmanager
Wants=network-online.target
After=network-online.target

[Service]
User=alertmanager
Group=alertmanager
Type=simple
ExecStart=/usr/local/bin/alertmanager \
    --config.file /etc/alertmanager/alertmanager.yml \
    --storage.path /var/lib/alertmanager

[Install]
WantedBy=multi-user.target
EOF

# 7. Start Service
echo "Starting Alertmanager..."
sudo systemctl daemon-reload
sudo systemctl start alertmanager
sudo systemctl enable alertmanager

# 8. Check Status
sudo systemctl status alertmanager --no-pager

echo "Alertmanager installed and started! Access it at http://<PublicIP>:9093"
