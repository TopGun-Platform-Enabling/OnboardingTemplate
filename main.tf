# Using kubectl for onboarding respectively dev env and pods
# Governed and controlled by Python core engine and kube control plane

provider "kubectl" {
  config_path = "~/.kube/config"
}

# kubectl kustomize render manifests
# data block for rendering possible manifests through GH
# aws lambda check on trigger

provider "aws" {
  region = "eu-central-1"

  # Make it faster by skipping something
  skip_metadata_api_check     = false
  skip_region_validation      = false
  skip_credentials_validation = true
}

##########################################
# Lambda Function (with various triggers)
##########################################

module "lambda_function" {
  source = "../../modules"

  function_name = "${random_pet.this.id}-lambda-triggers"
  description   = "Lambda function"
  handler       = "index.lambda_handler"
  runtime       = "python3.12"
  publish       = true

  create_package         = true
  local_existing_package = "${path.module}/../fixtures/python-zip/existing_package.zip"

  allowed_triggers = {
    ScanAmiRule = {
      principal  = "events.amazonaws.com"
      source_arn = aws_cloudwatch_event_rule.scan_ami.arn
    }

 ##################
# Extra resources
##################

resource "random_pet" "this" {
  length = 2
}

##################################
# Cloudwatch Events (EventBridge)
##################################
resource "aws_cloudwatch_event_rule" "scan_ami" {
  name          = "EC2CreateImageEvent"
  description   = "EC2 Create Image Event..."
  event_pattern = <<EOF
{
  "source": ["aws.ec2"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["ec2.amazonaws.com"],
    "eventName": ["CreateImage"]
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "scan_ami_lambda_function" {
  rule = aws_cloudwatch_event_rule.scan_ami.name
  arn  = module.lambda_function.lambda_function_arn
}
