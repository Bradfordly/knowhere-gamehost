# Knowhere
![GitHub Release](https://img.shields.io/github/v/release/Bradfordly/bradfordly-gamehost)
![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/Bradfordly/bradfordly-gamehost/main.yml)

### AWS Instance Management System

Bootstrap and management scripts for hosting game servers on one instance with minimal uptime.

## Usage

[CloudFormation Template (CFT)](knowhere-cft.yaml) is used to manage the infrastructure involved with running Knowhere. You can upload the CFT to S3 as-is and apply the CFT with CloudFormation. *Important Note:* The CFT does not provision an IAM Role which is required for the EC2 instance to interface with AWS Systems Manager.

Once the EC2 instance is provisioned the [userdata script](knowhere-userdata.sh) will execute. Staging important server management scripts and initializing server installations. When the server is fully configured, the script will conclude with a quick update to Route 53. Updating the CNAME record with the EC2 instance's new public DNS name.

## Development Setup

GitHub Actions have been setup to run jobs to deploy resources for testing. Branches should match the following naming conventions:

* `feature/name-of-feature/issue#`
* `bugfix/name-of-bug/issue#`

**PLEASE** ensure any AWS resources deployed outside of the `main` and `develop` branches are cleaned up quickly. If possible, downsize EC2 types (such as t2.micro, free tier eligbale) for feature/bugfix branches.
