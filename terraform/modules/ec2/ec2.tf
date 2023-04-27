#-------------------------------------------------------
# EC2
#-------------------------------------------------------
data "aws_ssm_parameter" "LatestAmiId" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

locals {
  EC2Instances_map = {
    "instance1" = var.publicsubnet1a
    # "instance2" = var.publicsubnet1b
  }
}



resource "aws_instance" "TeradaEC2Instance" {
  for_each = local.EC2Instances_map

  ami           = data.aws_ssm_parameter.LatestAmiId.value
  instance_type = var.InstanceType
  key_name      = var.key_name

  root_block_device {
    volume_type = var.volume_type
    volume_size = var.InstanceVolumes
    encrypted   = false
  }

  vpc_security_group_ids = [var.vpc_security_group]

  subnet_id = each.value

  tags = {
    Name        = "TeradaEC2Instance-${each.key}-${var.NameBase}"
    Environment = var.env
  }
}

#-------------------------------------------------------
# OutPuts
#-------------------------------------------------------
output "EC2Instanceoutputs1" {
  value = aws_instance.TeradaEC2Instance["instance1"].id
}

# output "EC2Instanceoutputs2" {
#   value = aws_instance.TeradaEC2Instance["instance2"].id
# }

output "EC2InstanceoutputsIP1" {
  value = aws_instance.TeradaEC2Instance["instance1"].public_ip
}

# output "EC2InstanceoutputsIP2" {
#   value = aws_instance.TeradaEC2Instance["instance2"].public_ip
# }