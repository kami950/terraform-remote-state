#!/bin/bash

cd ./terraform
rm -rf .terraform
terraform init && terraform plan -out plan.tfplan && terraform apply plan.tfplan
cd ..