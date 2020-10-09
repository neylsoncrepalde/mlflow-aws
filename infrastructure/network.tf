data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}


data "aws_subnet" "subnet1" {
  id = var.subnet1_id
}

data "aws_subnet" "subnet2" {
  id = var.subnet2_id
}


