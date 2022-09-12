variable "region" {}
variable "access_key" {}
variable "secret_key" {}

variable "vpc_name" {}
variable "vpc_name_cidr_block" {}
variable "dns_hostname_vpc" {}
variable "dns_hostname_vpc" {}

variable "public_cidr_blocks" {}
variable "aws_availability_zones.available.names" {}
variable "public_subnets_public_ip_launch" {}

variable "private_cidr_blocks" {}
variable "aws_availability_zones.available.names" {}
variable "private_subnets_public_ip_launch" {}

variable "gw_name" {}

variable "presentation_tier" {}
variable "p_tire_SSH_port_num" {}
variable "p_tire_HTTP_port_num" {}
variable "p_tire_HTTPS_port_num" {}

variable "alb_presentation_tier" {}
variable "alb_p_SSH_port_num" {}
variable "alb_p_HTTP_port_num" {}
variable "alb_p_HTTPS_port_num" {}

variable "application_tier" {}
variable "app_tire_SSH_port_num" {}
variable "app_tire_HTTP_port_num" {}
variable "app_tire_HTTPS_port_num" {}

variable "alb_application_tier" {}
variable "alb_app_SSH_port_num" {}
variable "alb_app_HTTP_port_num" {}
variable "alb_app_HTTPS_port_num" {}

variable "ecr_application_tier" {}
variable "ecr_presentation_tier" {}

variable "instance_name_type" {}
variable "instance_name_type2" {}

variable "rds_db_admin" {}

variable "rds_db_password" {}

variable "multi_az" {}

variable "db_name" {}

variable "engine_version" {}

variable "allocated_storage" {}

variable "instance_class" {}

variable "db_engine" {}