# AWS EC2 Monitoring Solution: Prometheus & Grafana with Terraform

This repository provides a robust, production-ready monitoring stack for AWS EC2 instances, leveraging Prometheus, Grafana, and Node Exporter. Infrastructure is provisioned and managed using Terraform, ensuring repeatability and scalability. The solution is optimized for the AWS Free Tier and demonstrates best practices in AWS and Infrastructure as Code (IaC).

---

## Key Features

- **Modular Terraform Infrastructure:** Easily reusable and extensible modules for AWS resources.
- **Automated EC2 Provisioning:** User data scripts handle all software installation and configuration.
- **Comprehensive Monitoring:** Prometheus collects metrics from all EC2 instances via Node Exporter.
- **Advanced Visualization:** Grafana dashboards provide real-time insights into CPU, memory, disk, and network usage.
- **Dynamic Configuration:** Prometheus configuration is templated using Terraform’s `templatefile()` for flexibility.
- **Secure by Default:** Security groups restrict access to only essential ports (22, 9090, 3000, 9100).
- **AWS Free Tier Friendly:** Designed to minimize costs while providing full functionality.

---

## Technology Stack

- **Terraform** – Infrastructure as Code
- **AWS EC2** – Compute resources
- **Prometheus** – Metrics collection and alerting
- **Node Exporter** – System metrics exporter
- **Grafana** – Visualization and dashboards
- **Amazon VPC, Security Groups, User Data** – Networking and automation

---

## Project Structure

```text
.
├── terraform/                  # All Terraform configuration files and templates
│   ├── main.tf                 # Main Terraform configuration
│   ├── variables.tf            # Input variables
│   ├── outputs.tf              # Terraform outputs (Grafana URL, IPs, etc.)
│   ├── prometheus_grafana.tpl  # User data template for Prometheus & Grafana setup
│   ├── node_exporter.tpl       # User data template for Node Exporter setup
├── Screenshots/                # Screenshots of project
├── stress-test/                # Stress testing scripts and resources
└──Readme.MD                    # Readme file
```

---

## Getting Started

1. **Prerequisites:**
   - AWS CLI configured
   - Terraform installed

2. **Deployment:**
   ```bash
   git clone https://github.com/blein7/aws-monitoring-prometheus-grafana.git
   cd aws-monitoring-prometheus-grafana
   terraform init
   terraform plan
   terraform apply
   ```

3. **Access:**
   - **Prometheus:** http://<prometheus-ec2-public-ip>:9090
   - **Grafana:** http://<prometheus-ec2-public-ip>:3000 (Default login: admin/admin)
   - **Node Exporter:** Scraped automatically by Prometheus

---

## Visualization

- Import the official Node Exporter Full dashboard (ID: 1860) in Grafana for comprehensive system metrics.
- Key metrics include:
  - CPU Load / Usage %
  - RAM Utilization
  - Disk I/O
  - Network In/Out
  - Uptime / System Time

---

## Security Considerations

- Only essential ports (22, 9090, 3000, 9100) are open by default.
- For production, restrict access further using IP filtering or VPN.

---

## Next Steps & Enhancements

- Integrate alerting via AWS SNS or Grafana Alerts
- Push logs and metrics to Amazon CloudWatch
- Refactor infrastructure using reusable Terraform modules
- Add support for auto-scaling groups and target groups

---
