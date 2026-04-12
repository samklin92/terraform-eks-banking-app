# Bootstrap

This folder creates the S3 bucket and DynamoDB table needed for the main
Terraform remote state backend. It must be deployed ONCE before running
the main Terraform configuration.

## Deploy

cd bootstrap
terraform init
terraform apply

## Get bucket name

terraform output state_bucket_name
Copy the bucket name and update backend.tf in the root module.

## Destroy

Only destroy this after destroying the main infrastructure first.
The state bucket must be emptied manually before destroy will work.

terraform destroy
