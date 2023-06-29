#!/bin/bash
SID="c1537527-c126-428d-8f72-1ac9f2c63c1f"
az account set --subscription $SID

INFRACODE="cgroup"
LOCATION="westeurope"
RESOURCE_GROUP="rg-${INFRACODE}"
WORKSPACE_NAME="${INFRACODE}-wrk"
LOG_ANALYTICS_WORKSPACE="${INFRACODE}-law"

#output values
OUT='\033[0;37m'
#debug
DBG='\033[0;32m'

#--------------------------------
#--- shared infra
#--------------------------------

# azure container registry
AKS_NAME="${INFRACODE}-aks"

# AAD
AZURE_AD_TENANTID="7517bc42-bcf8-4916-a677-b5753051f846"
AKS_AD_AKSADMIN_GROUP_ID="90f35468-e4ac-494a-93f5-bfe6156f1031"

WHITE='\033[0;37m' 
RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
