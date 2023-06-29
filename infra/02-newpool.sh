#!/bin/bash
echo "... Loading variables"
. ./variables.sh

echo "${DBG}... Creating the user node pool"
az aks nodepool add \
  --resource-group $RESOURCE_GROUP \
  --cluster-name $AKS_NAME \
  --name newpool \
  --node-count 3 \
  --mode User


echo "${DBG}... Script completed"
