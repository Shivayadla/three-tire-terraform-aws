region ="us-east-1"
access_key = "xxxxxxxxxxxxx"
secret_key = "xxxxxxxxxxxxx"

vpc_name = "main"
vpc_name_cidr_block = "10.0.0.0/16"
dns_hostname_vpc = true
dns_hostname_vpc = true

public_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
aws_availability_zones.available.names ["us-east-1a", "us-east-1b"]
public_subnets_public_ip_launch = true

private_cidr_blocks = ["10.0.3.0/24", "10.0.4.0/24"]
aws_availability_zones.available.names = ["us-east-1a", "us-east-1b"]
private_subnets_public_ip_launch = true

gw_name = "igw"

presentation_tier =""
p_tire_HTTP_port_num =""
p_tire_HTTP_port_num =""
p_tire_HTTPS_port_num =""

alb_presentation_tier =""
alb_p_SSH_port_num =""
alb_p_HTTP_port_num =""
alb_p_HTTPS_port_num =""

application_tier =""
app_tire_SSH_port_num =""
app_tire_HTTP_port_num =""
app_tire_HTTPS_port_num =""

alb_application_tier =""
alb_app_SSH_port_num =""
alb_app_HTTP_port_num =""
alb_app_HTTPS_port_num =""

ecr_application_tier =""
ecr_presentation_tier =""

instance_name_type1 =""
instance_name_type2 =""

rds_db_admin =""

rds_db_password =""

multi_az =""

db_name =""

engine_version =""

allocated_storage =""

instance_class =""
 
db_engine =""