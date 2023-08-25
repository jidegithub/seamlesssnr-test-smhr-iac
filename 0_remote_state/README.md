<!-- BEGIN_TF_DOCS -->
# Terraform remote state

This module deploys AWS infrastructure to store Terraform remote state in S3 bucket and lock Terraform execution in DynamoDB table.

## Deployment

```sh
terraform init
terraform plan
terraform apply -auto-approve
```

## Tear down

```sh
terraform destroy -auto-approve
```
## Providers
aws

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Resources
AWS S3  
AWS DYNAMODB
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dynamodb-lock-table"></a> [dynamodb-lock-table](#output\_dynamodb-lock-table) | DynamoDB table for Terraform execution locks |
| <a name="output_dynamodb-lock-table-ssm-parameter"></a> [dynamodb-lock-table-ssm-parameter](#output\_dynamodb-lock-table-ssm-parameter) | SSM parameter containing DynamoDB table for Terraform execution locks |
| <a name="output_s3-state-bucket"></a> [s3-state-bucket](#output\_s3-state-bucket) | S3 bucket for storing Terraform state |
| <a name="output_s3-state-bucket-ssm-parameter"></a> [s3-state-bucket-ssm-parameter](#output\_s3-state-bucket-ssm-parameter) | SSM parameter containing S3 bucket for storing Terraform state |
<!-- END_TF_DOCS -->