#!/bin/bash
echo "... Loading variables"
. ./variables.sh

echo ".................................................." 
echo ">>> Prerequisites for [$INFRACODE] <<<"
echo ".................................................." 

echo "${DBG}... Register feature [AzureServiceMeshPreview]"
az feature register --namespace "Microsoft.ContainerService" --name "AzureServiceMeshPreview"

echo "${DBG}... Waiting for the registration to complete [AzureServiceMeshPreview]"
while [ "$(az feature show --namespace "Microsoft.ContainerService" --name "AzureServiceMeshPreview" --query properties.state -o tsv | tr -d '[:space:]')" != "Registered" ]; do sleep 10; done

echo "${DBG}... Provider registration "
az provider register --namespace Microsoft.ContainerService

echo "${DBG}... Script completed"