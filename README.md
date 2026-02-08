# FeatureBranch-MVP-AWS Draft Version
# First onboarding making process clear and drafted 

flowchart TD
    A["Test and setup AWS Cli conform BP"] --> B["Configure dry-run modus to limit control spending"]
    B --> C["Test setup instance VPC (Virtual Private Endpoint)"]
    C --> D["Configure EC2 instance with appropriate security groups and IAM roles, shutdown after testing"]
    D --> E["Configure CloudTrail to monitor and log all API activity in the AWS environment"]
    E --> F["Script via bash a baseline to control and govern audit logs safely and secure"]
    F --> G["Configure IAM to allow only included roles , selectively 5 max"]
    G --> H["Make sure to test all components and ensure they are working correctly before proceeding with the project."]
    H --> I["Document the setup process and any configurations made for future reference and troubleshooting."]

Further topics would be :

- Test and setup AWS Cli conform BP
- Configure dry-run modus to limit control spending
- Test setup instance VPC (Virtual Private Endpoint)
- Configure EC2 instance with appropriate security groups and IAM roles, shutdown after testing
- Configure CloudTrail to monitor and log all API activity in the AWS environment
- Script via bash a baseline to control and govern audit logs safely and secure
- Configure IAM to allow only included roles , selectively 5 max
- Make sure to test all components and ensure they are working correctly before proceeding with the project.
- Document the setup process and any configurations made for future reference and troubleshooting.
- Regularly review and update the AWS environment to ensure it remains secure and efficient as the project evolves.

  E.g of ongoing dev for a GoldenPath within core AWS
  
>     > krisdevops@TopGun-X3:~/.aws$ ls amazonq  aws_vault.sh  config 
>     > credentials  node_modules  package-lock.json  package.json  sso
>     > krisdevops@TopGun-X3:~/.aws$

- Script via bash a baseline to control and govern audit logs safely and secure

#!/usr/bin/env bash
 set -euo pipefail

 AWS_VAULT_EXE="${AWS_VAULT_EXE:-aws-vault}"
 AWS_PROFILE_DEFAULT="${AWS_PROFILE_DEFAULT:-default}"
 SECRETS_SUBSCRIPTION="${SECRETS_SUBSCRIPTION:-secrets}"
 DRY_RUN="${DRY_RUN:-true}"

 AUDIT_LOG="${AUDIT_LOG:-$HOME/.aws/aws-vault-audit.log}"

 die() {
     echo "ERROR: $*" >&2
     audit_log "ERROR" "$*" "1"
     exit 1
 }

 audit_log() {
     local status="$1"
     local message="$2"
     local exitcode="${3:-0}"

     local timestamp
     timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

     local identity="unknown"
     if command -v aws >/dev/null 2>&1; then
         identity="$(aws sts get-caller-identity --output json 2>/dev/null || echo 'unavailable')"
     fi

     printf "%s | profile=%s | status=%s | exit=%s | cmd=%s | identity=%s\n" \
         "$timestamp" "$PROFILE" "$status" "$exitcode" "$CMD_STRING" "$identity" \
         >> "$AUDIT_LOG"
 }
