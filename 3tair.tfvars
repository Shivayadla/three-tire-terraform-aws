region ="us-east-1"
access_key = "xxxxxxxxxxxxxx"
secret_key = "xxxxxxxxxxxxxx"

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

presentation_tier ="presentation_tier"
p_tire_SSH_port_num ="22"
p_tire_HTTP_port_num ="80"
p_tire_HTTPS_port_num ="443"

alb_presentation_tier ="alb_presentation_tier"
alb_p_SSH_port_num ="22"
alb_p_HTTP_port_num ="80"
alb_p_HTTPS_port_num ="443"

application_tier ="application_tier"
app_tire_SSH_port_num ="22"
app_tire_HTTP_port_num ="80"
app_tire_HTTPS_port_num ="443"

alb_application_tier ="alb_application_tier"
alb_app_SSH_port_num ="22"
alb_app_HTTP_port_num ="80"
alb_app_HTTPS_port_num ="443"

ecr_application_tier ="demo_application_tier"
ecr_presentation_tier ="demo_presentation_tier"

instance_name_type1 ="t2.nano"
instance_name_type2 ="t2.nano"

rds_db_admin ="admin"

rds_db_password ="123456789"

multi_az = true

db_name ="mydb"

engine_version ="5.7.31"

allocated_storage ="10"

instance_class ="db.t3.micro"
 
db_engine ="mysql"