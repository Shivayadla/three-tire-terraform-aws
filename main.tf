resource "aws_vpc" "vpc_name" {
  cidr_block = "${var.vpc_name_cidr_block}"

  enable_dns_hostnames = "${var.dns_hostname_vpc}"
  enable_dns_support   = "${var.dns_support_vpc}"
  tags = {
    Name = "${var.vpc_name}"
  }
}

# Creating public_subnets
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_cidr_blocks)
  vpc_id                  = aws_vpc.vpc_name.id
  cidr_block              = var.public_cidr_blocks[count.index]
  availability_zone       = var.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = var.public_subnets_public_ip_launch

  tags = {
    Name = "public_subnet_${count.index + 1}"
  }
}

# Creating public_subnets
resource "aws_subnet" "private_subnets" {
  count                   = length(var.private_cidr_blocks)
  vpc_id                  = aws_vpc.vpc_name.id
  cidr_block              = var.private_cidr_blocks[count.index]
  availability_zone       = var.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = var.private_subnets_public_ip_launch

  tags = {
    Name = "private_subnet_${count.index + 1}"
  }
}

#creating IGW
resource "aws_internet_gateway" "gw_name" {
  vpc_id = aws_vpc.vpc_name.id

  tags = {
    Name = "var.gw_name"
  }
}

#creating Rout table
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.vpc_name.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw_name.id
  }

  tags = {
    Name = "public_route"
  }
}

resource "aws_route_table" "private_route" {
  count  = length(aws_subnet.private_subnets)
  vpc_id = aws_vpc.vpc_name.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw_name[count.index].id
  }
  tags = {
    Name = "private_route_${count.index + 1}"
  }
}
#route_table_association

resource "aws_route_table_association" "public_route_association" {
  count          = length(var.public_cidr_blocks)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route.id
}


resource "aws_route_table_association" "private-route" {
  count          = length(var.private_cidr_blocks)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route[count.index].id
}

#security groups==========================================================

resource "aws_security_group" "var.presentation_tier" {
  name        = "allow_connection_to_presentation_tier"
  description = "Allow HTTP"
  vpc_id      = aws_vpc.vpc_name.id

  ingress {
    from_port   = var.p_tire_SSH_port_num
    to_port     = var.p_tire_SSH_port_num
    protocol    = "SSH"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description     = "HTTP from anywhere"
    from_port       = var.p_tire_HTTP_port_num
    to_port         = var.p_tire_HTTP_port_num
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_presentation_tier.id]
  }

  ingress {
    description     = "HTTP from anywhere"
    from_port       = var.p_tire_HTTPS_port_num
    to_port         = var.P_tire_HTTPS_port_num
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_presentation_tier.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "presentation_tier_sg"
  }
}

resource "aws_security_group" "var.alb_presentation_tier" {
  name        = "allow_connection_to_alb_presentation_tier"
  description = "Allow HTTP"
  vpc_id      = aws_vpc.vpc_name.id

ingress {
    from_port   = var.alb_p_SSH_port_num
    to_port     = var.alb_p_SSH_port_num
    protocol    = "SSH"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description      = "HTTP from anywhere"
    from_port        = var.alb_P_HTTP_port_num
    to_port          = var.alb_p_HTTP_port_num
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP from anywhere"
    from_port        = var.alb_p_HTTPS_port_num
    to_port          = var.alb_p_HTTPS_port_num
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb_presentation_tier_sg"
  }
}

resource "aws_security_group" "var.application_tier" {
  name        = "allow_connection_to_application_tier"
  description = "Allow HTTP"
  vpc_id      = aws_vpc.vpc_name.id
  ingress {
    from_port   = var.app_tire_SSH_port_num
    to_port     = var.app_tire_SSH_port_num
    protocol    = "SSH"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    description     = "HTTP from public subnet"
    from_port       = var.app_tire_HTTP_port_num
    to_port         = var.app_tire_HTTP_port_num
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_application_tier.id]
  }

  ingress {
    description     = "HTTP from public subnet"
    from_port       = var.app_tire_HTTPS_port_num
    to_port         = var.app_tire_HTTPS_port_num
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_application_tier.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "application_tier_sg"
  }
}

resource "aws_security_group" "var.alb_application_tier" {
  name        = "allow_connection_to_alb_application_tier"
  description = "Allow HTTP"
  vpc_id      = aws_vpc.vpc_name.id
  ingress {
    from_port   = var.alb_app_SSH_port_num
    to_port     = var.alb_app_SSH_port_num
    protocol    = "SSH"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description     = "HTTP from anywhere"
    from_port       = var.alb_app_HTTP_port_num
    to_port         = var.alb_app_HTTP_port_num
    protocol        = "tcp"
    security_groups = [aws_security_group.presentation_tier.id]
  }

  ingress {
    description     = "HTTP from anywhere"
    from_port       = var.alb_app_HTTPS_port_num
    to_port         = var.alb_app_HTTPS_port_num
    protocol        = "tcp"
    security_groups = [aws_security_group.presentation_tier.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb_application_tier_sg"
  }
}

#creating NAT gateway ==============================================

resource "aws_nat_gateway" "nat_gw_" {
  count         = length(aws_subnet.public_subnets)
  allocation_id = aws_eip.nat_ip[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id
  depends_on    = [aws_internet_gateway.gw_name]
  tags = {
    "Name" = "nat_gw_${count.index + 1}"
  }
}

#Creating Elastic ip=========================================================================================================
resource "aws_eip" "nat_ip" {
  count      = length(aws_subnet.public_subnets)
  depends_on = [aws_internet_gateway.gw_name]
  tags = {
    "Name" = "nat_ip_${count.index + 1}"
  }
}

#Ec2 creating ===============================================================================================================

data "aws_ami" "amazon_linux_2" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

data "aws_caller_identity" "current" {}

resource "aws_iam_instance_profile" "ec2_ecr_connection" {
  name = "ec2_ecr_connection"
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "role" {
  name = "allow_ec2_access_ecr"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "access_ecr_policy" {
  name = "allow_ec2_access_ecr"
  role = aws_iam_role.role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ecr:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_launch_template" "presentation_tier" {
  name = "presentation_tier"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 8
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_ecr_connection.name
  }

  instance_type = "var.instance_name_type"
  image_id      = data.aws_ami.amazon_linux_2.id

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.presentation_tier.id]
  }

  user_data = base64encode(templatefile("./../user-data/user-data-presentation-tier.sh", {
    application_load_balancer = aws_lb.application_tier.dns_name,
    ecr_url                   = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com"
    ecr_repo_name             = var.ecr_presentation_tier,
    region                    = var.region
  }))

  depends_on = [
    aws_lb.application_tier
  ]
}

resource "aws_launch_template" "application_tier" {
  name = "application_tier"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 8
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_ecr_connection.name
  }

  instance_type = "var.instance_name_type2"
  image_id      = data.aws_ami.amazon_linux_2.id

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.application_tier.id]
  }

  user_data = base64encode(templatefile("./../user-data/user-data-application-tier.sh", {
    rds_hostname  = module.rds.rds_address,
    rds_username  = var.rds_db_admin,
    rds_password  = var.rds_db_password,
    rds_port      = 3306,
    rds_db_name   = var.db_name
    ecr_url       = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com"
    ecr_repo_name = var.ecr_application_tier,
    region        = var.region
  }))

  depends_on = [
    aws_nat_gateway.nat_gw_
  ]
}

#creating rds===========================================
module "rds" {
  source            = "./modules/rds"
  subnets           = aws_subnet.private_subnets
  vpc_id            = aws_vpc.vpc_name.id
  from_sgs          = [aws_security_group.application_tier]
  allocated_storage = var.allocated_storage
  engine_version    = var.engine_version
  multi_az          = true
  db_name           = var.db_name
  db_username       = var.rds_db_admin
  db_password       = var.rds_db_password
  instance_class    = var.instance_class
  engine            = var.db_engine
}