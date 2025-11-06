# Fetch latest Ubuntu 24.04 AMI
data "aws_ssm_parameter" "ubuntu_24_ami" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

# Security Group
resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow HTTP, HTTPS, SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create 2 EC2 instances
resource "aws_instance" "node" {
  count                  = 2
  ami                    = data.aws_ssm_parameter.ubuntu_24_ami.value
  instance_type          = var.instance_type
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  root_block_device {
    volume_size = var.root_volume_size_gb
  }

  user_data = templatefile("${path.module}/deploy_script.sh", {
    domain      = count.index == 0 ? "node1.divyanshutiwari.site" : "node2.divyanshutiwari.site"
    github_repo = var.github_repo
    github_pat  = var.github_pat
    email       = var.ssl_email
  })

  tags = {
    Name = count.index == 0 ? "node1" : "node2"
  }
}

# Output IPs
output "node_ips" {
  value = {
    node1 = aws_instance.node[0].public_ip
    node2 = aws_instance.node[1].public_ip
  }
}
