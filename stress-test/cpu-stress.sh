#!/bin/bash
# Simple CPU stress script

sudo yum install -y epel-release stress || sudo apt-get install -y stress

# Run stress for 5 min with 4 CPU workers
stress --cpu 4 --timeout 300
🚀 Deployment Steps

🛠 Prerequisite: AWS CLI configured & Terraform installed
git clone https://github.com/your-username/aws-monitoring-prometheus-grafana.git
cd aws-monitoring-prometheus-grafana
terraform init
terraform plan
terraform apply

Once deployed:

    Prometheus: http://<prometheus-ec2-public-ip>:9090

    Grafana: http://<prometheus-ec2-public-ip>:3000 (Default: admin/admin)

    EC2 Instances: Scraped automatically via private IPs

📊 Visualizations

Import the official Node Exporter Full dashboard (ID 1860) in Grafana.

Steps:

    Go to Grafana → Dashboards → Import

    Enter ID 1860 and click "Load"

    Select your Prometheus data source and import

🧪 Metrics to Visualize

    CPU Load / Usage %

    RAM Utilization

    Disk I/O

    Network In/Out

    Uptime / System Time

    Custom simulated CPU stress (optional)

🔐 Security Notes

    Only port 22, 9090, 3000, and 9100 are opened

    Production use should restrict access via IP filtering or VPN

📌 Next Steps / Ideas

    Add alerting via AWS SNS or Grafana Alerts

    Push logs to CloudWatch

    Use Terraform modules for reusability

    Add auto-scaling groups and target groups