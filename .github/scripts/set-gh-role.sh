#!/bin/bash

# Script to set the appropriate AWS role based on environment
environment="$1"

case "$environment" in
  staging)
    ROLE_ARN=${STAGING_GH_ROLE}
    ;;
  prod)
    ROLE_ARN=${PROD_GH_ROLE}
    ;;
  *)
    echo "Unknown environment: $environment"
    exit 1
    ;;
esac

echo "Assuming role $ROLE_ARN for environment: $environment"
echo "role_arn=$ROLE_ARN" >> $GITHUB_OUTPUT
