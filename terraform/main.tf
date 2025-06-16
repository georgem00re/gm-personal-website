
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

// Because an OIDC provider for GitHub Actions has already been created (in the CloudFormation templates),
// we can use a data block to reference the existing provider rather than attempting to recreate it.
data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}

module "aws_iam_policy_document" {
  source                      = "./modules/aws_iam_policy_document"
  openid_connect_provider_arn = data.aws_iam_openid_connect_provider.github.arn
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
