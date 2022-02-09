# Jenkins CI/CD automated creation

In order to work with this repo you should have:

- Terraform: v1.1.2
- Packer: ~>1.7.8

First start by configuring your AWS credentials using
```
aws configure
```
After completing the configuration first apply /terraform/vpc/main.tf

```
cd ./terraform/vpc
terraform apply
```
Create the Jenkins AMI using packer by running:
```
cd ./packer
packer validate jenkins.pkr.hcl
packer build jenkins.pkr.hcl
```
## Creation of a Jenkins instance
After the AMI is created, in order to create and configure the Jenkins instance run the following commands:
```
cd ./terraform/jenkins
terraform apply
```
After the terraform is applied, a .pem file should be created containing the key to ssh into the instance.