# terraform-project

## Description
A terraform folder that provisions resources such as virtual machines on AWS and creates a VPC, Subnets, Security groups for Virtual machines and application load balancers. It also 
creates a route53 resource that gives an A record to the application load balancer's DNS.

The script also runs ansible command to configure the virtual machines.

### NOTE
In the root folder, create a terraform.tfvars file to store the needed variables.

### How to run
`terraform init`
`terraform validate`
`terraform apply`
