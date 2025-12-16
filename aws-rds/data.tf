data "aws_vpc" "vpc_default" {
  default = true
}

data "aws_subnets" "nets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc_default.id]
  }
}