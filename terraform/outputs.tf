output "prometheus_server_public_ip" {
  description = "Public IP of Prometheus and Grafana server"
  value       = aws_instance.prometheus.public_ip
}

output "prometheus_server_public_dns" {
  description = "Public DNS of Prometheus and Grafana server"
  value       = aws_instance.prometheus.public_dns
}

output "node_private_ips" {
  description = "Private IPs of Node Exporter instances"
  value       = [for n in aws_instance.node : n.private_ip]
}
