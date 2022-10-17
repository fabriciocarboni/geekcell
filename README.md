# AWS automation in order to provision the infra needed for a ECS Fargate cluster

Ps: Terragrunt implementation of this stack is available [here](https://github.com/fabriciocarboni/geekcell-terragrunt)

## Requirements:

Terraform version 1.3.2 ( https://releases.hashicorp.com/terraform/1.3.2/ )
 
```
  wget https://releases.hashicorp.com/terraform/1.3.2/terraform_1.3.2_linux_amd64.zip
  unzip terraform_1.3.2_linux_amd64.zip
  sudo mv terraform /usr/local/bin/
  rm -fr terraform_1.3.2_linux_amd64.zip
```

AWS CLI (https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)

## Credentials
In order to start this:
1) Copy your aws credentials in your terminal so AWSCLI can have access on it as environment variables. Place the credentials within the commas.
```
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
```

2) Create in the github repository the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY in order to the github actions be able to push the app image to ECR. Settings -> Secrets -> Actions -> New Repository Secret.

# Steps

## Create network with 2 publics & 2 privates subnet (vpc.tf) (2 differents AZs)
- 2 publics subnets: To acomodate our application load balancer
- 2 private subnets: To acomodate our fargate tasks
- 1 Internet Gateway along with route table
- 2 NAT Gateways along with its route tables and subnets association.

## Create security groups
- 1 security group has been created for our load balancer (security_groups.tf)
- 1 security group has been created for our ecs service. This security group allows our fargate tasks pull image from ecr and allow inbound requests from load balancer security group. (ecs_fargate.tf)

## Create a load balancer (ALB) (elb.tf)
The Application Load Balancer that is responsible to balance requests among two tasks

## Create Elastic Container Registry(ECR) repository (ecr.tf)
A repository has been created in order to accommodate our app image. As soon as a push is made on our branch in github, it will push to our repository in aws. (.github/workflows/deploy.yaml)

## Create a user on which is responsible to deploy/push the app image to ECR along with permissions accordingly (deployment_user.tf)

## Create a Fargate cluster (ecs_fargate.tf)
1. Fargate cluster
2. A task definition
3. A service has been created. It's responsible to guarantee that we will always have our minimum tasks running at all times

## Diagram of our environment

![](https://i.ibb.co/qC7vWTQ/VPC-diagram-Page-1.jpg)

## CI/CD to deploy app
![](https://i.ibb.co/vPRJNG3/git-hub-actions.jpg)
Considerations: 
- When the deploy is run via github actions, it needs to update the task definition with the new image:tag generated and then it deploys the new task definition
- The Fargate tasks in turn starts provisioning the new tasks but the original tasks is still running. Only after the health check executed by load balancer on the target group is healthy and the previous targets are completely drained and deregistered, then the previous tasks are stopped from ecs tasks.

Not completed tasks:
- Redirect port 80 to 443. When I tried to do it, aws requested to import a certificate. I was asked about a domain name. After some research I tried to implement the certificate on my own domains which are hosted on Cloudflare. However when I set the CNAMEs names pointing to AWS CNAMEs Values, I was informed that I should buy a Advanced Certificate Manager on Cloudflare which would cost me some money.
- Blue/Green deployment. I would need more time to finish this too.

Ps.: For this challenge I have used my own account at acloud.guru