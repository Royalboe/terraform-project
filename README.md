# terraform-project

## Description
A terraform folder that provisions resources such as virtual machines on AWS and creates a VPC, Subnets, Security groups for Virtual machines and application load balancers. It also 
creates a route53 resource that gives an A record to the application load balancer's DNS.

The script also runs ansible command to configure the virtual machines.

### NOTE
- In the root folder, create a terraform.tfvars file to store the needed variables.
- To let ansible run without prompting for authentication to add ip addresses to the known_hosts:
- Create the ssh config file by running `touch ~/.ssh/config`
- open the file with your favorite text editor and add the lines below
- 
`Host *
    StrictHostKeyChecking no `
    
- Save and exit and run terraform commands

### How to run
- `terraform init`
- `terraform validate`
- `terraform apply`
