
variable "ORGANISATION_NAME" {}
variable "REPOSITORY_NAME" {}

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

module "aws_iam_openid_connect_provider" {
  source = "./modules/aws_iam_openid_connect_provider"
}

module "aws_iam_policy_document" {
  source                      = "./modules/aws_iam_policy_document"
  openid_connect_provider_arn = module.aws_iam_openid_connect_provider.arn
  organisation_name           = var.ORGANISATION_NAME
  repository_name             = var.REPOSITORY_NAME
}

module "aws_iam_role" {
  source             = "./modules/aws_iam_role"
  assume_role_policy = module.aws_iam_policy_document.json
}

module "aws_s3_bucket" {
  source             = "./modules/aws_s3_bucket"
  can_put_and_delete = module.aws_iam_role.arn
}
