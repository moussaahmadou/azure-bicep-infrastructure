#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: bash deploy.sh <dev|prod> <subscription-id> <resource-group> <resource-group-location>" >&2
  echo "Example: bash deploy.sh prod 00000000-0000-0000-0000-000000000000 rg-network-prod westeurope" >&2
}

if [[ $# -ne 4 ]]; then
  usage
  exit 2
fi

environment=$1
subscription_id=$2
resource_group=$3
resource_group_location=$4

case "$environment" in
  dev|prod) ;;
  *)
    echo "Environment must be 'dev' or 'prod'." >&2
    usage
    exit 2
    ;;
esac

if ! command -v az >/dev/null 2>&1; then
  echo "Azure CLI ('az') is not installed or is not on PATH." >&2
  exit 1
fi

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
template_file="$script_dir/main.bicep"
parameter_file="$script_dir/$environment.bicepparam"

if [[ ! -f "$template_file" || ! -f "$parameter_file" ]]; then
  echo "Could not find the Bicep template or parameter file for '$environment'." >&2
  exit 1
fi

az account show --output none
az account set --subscription "$subscription_id"

active_subscription_id="$(az account show --query id --output tsv)"
if [[ "$active_subscription_id" != "$subscription_id" ]]; then
  echo "The active Azure subscription does not match '$subscription_id'." >&2
  exit 1
fi

az group create \
  --name "$resource_group" \
  --location "$resource_group_location" \
  --subscription "$subscription_id" \
  --output none

deployment_name="vnet-${environment}-$(date -u +%Y%m%d%H%M%S)"

az deployment group create \
  --name "$deployment_name" \
  --resource-group "$resource_group" \
  --template-file "$template_file" \
  --parameters "$parameter_file" \
  --subscription "$subscription_id"
