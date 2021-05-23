# AWS/GCP Secrets And Okta SSO

### Pre-reqs:

* AWS CLI v2

* Running t.2 micro instance

* Google Cloud SDK

## Enabling AWS IAM Role As A Secret

1. Login to your AWS Account

2. Navigate to IAM admin page

3. Click on "Users"

4. Click "Add User"

5. Enter a name of the name you want the Vault account to use and select programatic access

    > _*IMPORTANT NOTE:*_ Vault can use IAM role if it is an EC2, ECS, or other AWS resource. In this tutorial, we are using key credentials if you ever need to set up access from outside of AWS and need to use key based authentication.

6. Select admin permissions since we want this account to generate credentials

7. Click through and create user

8. Save the Access ID and Key for the user

9. Login to the Vault server

10. Enable the AWS secrets engine

    `vault secrets enable aws`

11. Write the credentials to Vault

    `vault write aws/config/root \`
    
    `access_key={{AWS_ACCESS_KEY}} \`
    
    `secret_key={{AWS_SECRET_KEY}} \`
    
    `region={{default-region}}`

12. Create a policy json from our template

    `vim aws-iam.json`

13. Create a role with in Vault with access to EC2 instances in AWS

    `vault write aws/roles/aws-test-role \`

    `credential_type=iam_user \`

    `policy_document=aws-iam.json`

14. Read the credentials from the AWS role we created in Vault

    `vault read aws/creds/aws-test-role`

15. Edit AWS CLI config to use those credentials

16. Run the following command to test

    `aws ec2 describe-instances --filters "Name=instance-type,Values=t2.micro"`

## Enabling GCP As A Secret

_(In Progress)_

## Using Okta SSO With Vault

_(In Progress)_