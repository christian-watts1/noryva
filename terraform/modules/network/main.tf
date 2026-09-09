variable "name" { type = string }
variable "cidr" { type = string }
variable "availability_zones" { type = list(string) }
resource "aws_vpc" "this" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = { Name = var.name }
}
resource "aws_subnet" "private" {
  count                   = 2
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.cidr, 8, count.index)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false
}
resource "aws_route_table" "isolated" { vpc_id = aws_vpc.this.id }
resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.isolated.id
}
resource "aws_default_security_group" "closed" { vpc_id = aws_vpc.this.id }
resource "aws_security_group" "lambda" {
  name_prefix = "${var.name}-lambda-"
  vpc_id      = aws_vpc.this.id
  description = "API: only PostgreSQL egress"
}
resource "aws_security_group" "database" {
  name_prefix = "${var.name}-db-"
  vpc_id      = aws_vpc.this.id
  description = "PostgreSQL from API only; no internet"
}
resource "aws_vpc_security_group_egress_rule" "database" {
  security_group_id            = aws_security_group.lambda.id
  referenced_security_group_id = aws_security_group.database.id
  ip_protocol                  = "tcp"
  from_port                    = 5432
  to_port                      = 5432
}
resource "aws_vpc_security_group_ingress_rule" "database" {
  security_group_id            = aws_security_group.database.id
  referenced_security_group_id = aws_security_group.lambda.id
  ip_protocol                  = "tcp"
  from_port                    = 5432
  to_port                      = 5432
}
output "subnet_ids" { value = aws_subnet.private[*].id }
output "lambda_security_group_id" { value = aws_security_group.lambda.id }
output "database_security_group_id" { value = aws_security_group.database.id }
