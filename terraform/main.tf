
terraform {
  required_version = ">= 1.4.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.95.0"
    }
  }
  backend "s3" {
    key = "terraform.tfstate"
  }
}

provider "aws" {}

resource "aws_vpc" "example" {
  cidr_block = "192.0.0.0/16"
}
