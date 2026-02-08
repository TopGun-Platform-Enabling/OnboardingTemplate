# FeatureBranch-MVP-AWS Draft Version

## First definition and onboarding of solution blocks to make process clear and drafted 


<img width="1240" height="6310" alt="AWS IAM CloudTrail Flow-2026" src="https://github.com/user-attachments/assets/8accc302-ba62-4f76-a942-c84e6609ad34" />

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

## Gathering phasis 2 - more data and audit logging

>  AUDIT_LOG="${AUDIT_LOG:-$HOME/.aws/aws-vault-audit.log}"
> 
>  die() {
>      echo "ERROR: $*" >&2
>      audit_log "ERROR" "$*" "1"
>      exit 1  }
> 
>  audit_log() {
>      local status="$1"
>      local message="$2"
>      local exitcode="${3:-0}"
> 
>      local timestamp
>      timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
> 
>      local identity="unknown"
>      if command -v aws >/dev/null 2>&1; then
>          identity="$(aws sts get-caller-identity --output json 2>/dev/null || echo 'unavailable')"
>      fi
> 
>      printf "%s | profile=%s | status=%s | exit=%s | cmd=%s | identity=%s\n" \
>          "$timestamp" "$PROFILE" "$status" "$exitcode" "$CMD_STRING" "$identity" \
>          >> "$AUDIT_LOG"  }
         >> "$AUDIT_LOG"
 }
