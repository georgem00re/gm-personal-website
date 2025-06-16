
frontend-start:
	NVM_DIR="$${HOME}/.nvm" && . "$${NVM_DIR}/nvm.sh" && cd react-app && nvm use && npm run dev

terraform-fmt:
	terraform -chdir=terraform fmt --recursive
