
frontend-start:
	NVM_DIR="$${HOME}/.nvm" && . "$${NVM_DIR}/nvm.sh" && cd react-app && nvm use && npm run dev

terraform-fmt:
	terraform -chdir=terraform fmt --recursive

# To deploy the Terraform infrastructure locally, you must first
# remove the 'backend "s3"' block from terraform/main.tf.
terraform-init:
	terraform -chdir=terraform init
