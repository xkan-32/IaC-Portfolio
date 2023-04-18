#-------------------------------------------------------
# EC2 Instance SecurityGroup
#-------------------------------------------------------
resource "aws_security_group" "TeradaSecurityGroup01" {
  name        = "EC2Instance-SecurityGroup-${var.NameBase}"
  description = "EC2 Instance SecurityGroup"
  vpc_id      = var.vpc_id

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

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Environment = var.env
  }
}
#-------------------------------------------------------
# ALB SecurityGroup
#-------------------------------------------------------
resource "aws_security_group" "TeradaSecurityGroup02" {
  name        = "ALB-SecurityGroup-${var.NameBase}"
  description = "ALB SecurityGroup"
  vpc_id      = var.vpc_id

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
  tags = {
    Environment = var.env
  }
}
#-------------------------------------------------------
# RDS SecurityGroup
#-------------------------------------------------------
resource "aws_security_group" "TeradaSecurityGroup03" {
  name        = "RDS-SecurityGroup-${var.NameBase}"
  description = "RDS SecurityGroup"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Environment = var.env
  }
}
#-------------------------------------------------------
# OutPuts
#-------------------------------------------------------
output "SecurityGroup01outputs" {
  value = aws_security_group.TeradaSecurityGroup01.id
}

output "SecurityGroup02outputs" {
  value = aws_security_group.TeradaSecurityGroup02.id
}

output "SecurityGroup03outputs" {
  value = aws_security_group.TeradaSecurityGroup03.id
}