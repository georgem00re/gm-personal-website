include .env

frontend-start:
	NVM_DIR="$${HOME}/.nvm" && . "$${NVM_DIR}/nvm.sh" && cd react-app && nvm use && npm run dev

# Local infrastructure commands for faster dev — skip CI and use local backend to deploy/test infrastructure
# very quickly. For Terraform, you must first remove the 'backend "s3"' block from main.tf before running.

cloudformation-deploy-stack:
	aws cloudformation deploy \
	  --stack-name $(CLOUDFORMATION_STACK_NAME) \
	  --template-file ./cloudformation-templates/main.yml \
	  --capabilities CAPABILITY_NAMED_IAM \
	  --region $(AWS_REGION) \
      --profile $(AWS_PROFILE) \
      --parameter-overrides \
          RepositoryName=$(REPOSITORY_NAME) \
          RepositoryOwner=$(ORGANISATION_NAME) \

cloudformation-delete-stack:
	aws cloudformation delete-stack \
	  --stack-name $(CLOUDFORMATION_STACK_NAME) \
	  --region $(AWS_REGION) \
	  --profile $(AWS_PROFILE)

terraform-fmt:
	terraform -chdir=terraform fmt --recursive

# Remove the 'backend "s3"' block from terraform/main.tf before running.
terraform-init:
	terraform -chdir=terraform init

terraform-plan:
	AWS_REGION=$(AWS_REGION) AWS_PROFILE=$(AWS_PROFILE) terraform -chdir=terraform plan \
		-var="ORGANISATION_NAME=$(ORGANISATION_NAME)" \
		-var="REPOSITORY_NAME=$(REPOSITORY_NAME)"

terraform-apply:
	AWS_REGION=$(AWS_REGION) AWS_PROFILE=$(AWS_PROFILE) terraform -chdir=terraform apply \
		-var="ORGANISATION_NAME=$(ORGANISATION_NAME)" \
		-var="REPOSITORY_NAME=$(REPOSITORY_NAME)"

terraform-destroy:
	AWS_REGION=$(AWS_REGION) AWS_PROFILE=$(AWS_PROFILE) terraform -chdir=terraform destroy \
		-var="ORGANISATION_NAME=$(ORGANISATION_NAME)" \
		-var="REPOSITORY_NAME=$(REPOSITORY_NAME)"

terraform-output:
	terraform -chdir=terraform output

build-react-app:
	NVM_DIR="$${HOME}/.nvm" && . "$${NVM_DIR}/nvm.sh" && cd react-app && nvm use && npm run build

push-react-app-to-s3-bucket:
	aws s3 sync react-app/dist/ s3://$$(terraform -chdir=terraform output -raw s3_bucket_name) --region $(AWS_REGION) --profile $(AWS_PROFILE)
