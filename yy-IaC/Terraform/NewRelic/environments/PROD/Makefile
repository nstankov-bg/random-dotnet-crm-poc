init:
	terraform init
plan:
	terraform plan -out=plan.out -var-file=terraform.tfvars
apply:
	terraform apply plan.out
output:
	terraform output key
	terraform output id

all: init plan apply output
