#!/bin/bash

if [ -d ".terraform" ]; then
  sudo rm -r .terraform
fi

branch=$(git rev-parse --abbrev-ref HEAD)

cp ./providers/providers.$branch.tf providers.tf
cp ./tfvars/terraform.$branch.tfvars terraform.tfvars