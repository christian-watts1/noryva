mock_provider "aws" {}
variables {
  name               = "noryva-test"
  cidr               = "10.41.0.0/16"
  availability_zones = ["eu-west-2a", "eu-west-2b"]
}
run "isolated_network" {
  command = plan
  assert {
    condition     = alltrue([for subnet in aws_subnet.private : !subnet.map_public_ip_on_launch])
    error_message = "Database subnets cannot allocate public IP addresses."
  }
  assert {
    condition     = aws_vpc_security_group_egress_rule.database.from_port == 5432 && aws_vpc_security_group_egress_rule.database.to_port == 5432 && aws_vpc_security_group_egress_rule.database.cidr_ipv4 == null
    error_message = "API egress must target only the database security group on PostgreSQL."
  }
  assert {
    condition     = aws_vpc_security_group_ingress_rule.database.from_port == 5432 && aws_vpc_security_group_ingress_rule.database.cidr_ipv4 == null
    error_message = "Database cannot allow public CIDR ingress."
  }
}
