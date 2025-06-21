provider "aws" {
  region = var.region
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  owners = ["amazon"]
}

resource "aws_security_group" "monitoring_sg" {
  name        = "monitoring_sg"
  description = "Allow Prometheus and Grafana traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow Prometheus scraping (Node Exporter)"
    from_port        = 9100
    to_port          = 9100
    protocol         = "tcp"
    self             = true  # Allow instances in this SG to talk to each other
  }

  ingress {
    description      = "Allow Prometheus web UI"
    from_port        = 9090
    to_port          = 9090
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow Grafana web UI"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "node" {
  count                     = var.node_count
  ami                       = data.aws_ami.amazon_linux.id
  instance_type             = "t3.micro"
  subnet_id                 = var.subnet_id
  key_name                  = var.key_name
  vpc_security_group_ids    = [aws_security_group.monitoring_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              curl -LO https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
              tar xvf node_exporter-1.7.0.linux-amd64.tar.gz
              cd node_exporter-1.7.0.linux-amd64
              ./node_exporter &
              EOF

  tags = {
    Name = "monitor-node-${count.index + 1}"
  }
}

locals {
  scrape_targets = join("\n", [
    for instance in aws_instance.node : "      - '${instance.private_ip}:9100'"
  ])
}

resource "aws_instance" "prometheus" {
  ami                       = data.aws_ami.amazon_linux.id
  instance_type             = "t3.micro"
  subnet_id                 = var.subnet_id
  key_name                  = var.key_name
  vpc_security_group_ids    = [aws_security_group.monitoring_sg.id]
  associate_public_ip_address = true

  user_data = templatefile("prometheus_grafana.tpl", {
    scrape_targets = local.scrape_targets
  })

  tags = {
    Name = "prometheus-server"
  }
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}