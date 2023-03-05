terraform {
  #   backend "s3" {
  #     bucket = "icc-terraform-states"
  #     key    = "yy-IaC/Terraform/NewRelic/environments/PRODterraform.tfstate"
  #     region = "us-east-2"
  #   }
  required_providers {
    newrelic = {
      source = "newrelic/newrelic"
    }
  }
}

# Configure the New Relic provider
provider "newrelic" {
  account_id = var.account_id # Your New Relic account ID
  api_key    = var.api_key    # Usually prefixed with 'NRAK'
  region     = "EU"           # Valid regions are US and EU
}
