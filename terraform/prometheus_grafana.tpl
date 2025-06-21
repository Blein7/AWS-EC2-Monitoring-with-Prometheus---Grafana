#!/bin/bash
# Install Prometheus
useradd --no-create-home --shell /bin/false prometheus
mkdir /etc/prometheus
mkdir /var/lib/prometheus

curl -LO https://github.com/prometheus/prometheus/releases/download/v2.44.0/prometheus-2.44.0.linux-amd64.tar.gz
tar xvf prometheus-2.44.0.linux-amd64.tar.gz
cp prometheus-2.44.0.linux-amd64/prometheus /usr/local/bin/
cp prometheus-2.44.0.linux-amd64/promtool /usr/local/bin/
cp -r prometheus-2.44.0.linux-amd64/consoles /etc/prometheus
cp -r prometheus-2.44.0.linux-amd64/console_libraries /etc/prometheus

chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus /usr/local/bin/prometheus /usr/local/bin/promtool

cat > /etc/prometheus/prometheus.yml <<EOL
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'node_exporter_nodes'
    static_configs:
      ${scrape_targets}
EOL

cat > /etc/systemd/system/prometheus.service <<EOF
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \\
  --config.file=/etc/prometheus/prometheus.yml \\
  --storage.tsdb.path=/var/lib/prometheus/ \\
  --web.console.templates=/etc/prometheus/consoles \\
  --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable prometheus
systemctl start prometheus

# Install Grafana
yum install -y https://dl.grafana.com/oss/release/grafana-9.5.5-1.x86_64.rpm
systemctl daemon-reload
systemctl enable grafana-server
systemctl start grafana-server
