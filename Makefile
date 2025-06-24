include .env

frontend-start:
	NVM_DIR="$${HOME}/.nvm" && . "$${NVM_DIR}/nvm.sh" && cd react-app && nvm use && npm run dev

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

# To deploy the Terraform infrastructure locally, you must first
# remove the 'backend "s3"' block from terraform/main.tf.
terraform-init:
	terraform -chdir=terraform init

terraform-plan:
	AWS_REGION=$(AWS_REGION) AWS_PROFILE=$(AWS_PROFILE) terraform -chdir=terraform plan \
		-var="ORGANISATION_NAME=$(ORGANISATION_NAME)" \
		-var="REPOSITORY_NAME=$(REPOSITORY_NAME)"
