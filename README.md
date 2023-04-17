# Terraform Remote State
A simple terraform project to create remote state in AWS using S3 and DynamoDB 

## Introduction and usage
This project creates an aws remote state by creating an S3 bucket and dynamoDB locking tables.
To deploy the remote state populate the `./terraform/terraform.tfvars` file with the name you want to append to the created infrastructure.

After this run the `./deployRemoteState.sh` script

To delete the remote state, run the `./destroyRemoteState.sh` script.

## Other
If you need to remove the created infrastucture and you cannot use the destroy script or the terraform destroy commands, then you can do the following:
* Go to S3 in the AWS Console
    * There should be a bucket with the following name: {STAGE}--terraform-remote-state
    * You can delete this here
    * Please be aware any infrastructure you have provisioned and used this bucket as remote state which has not been destroyed will lose its remote state
* Go to DynamoDB in the AWS Console and click on tables
    * There should be a table called {STAGE}-terraform-remote-state-locking-table
    * You can delete this here
    * As above, any infrastrucutre provisioned which is currently provisioned and using this remote state will lose its remote state