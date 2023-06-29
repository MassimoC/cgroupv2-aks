echo ".................................................." 
echo ">>> Creating resources for [$INFRACODE] <<<"
echo ".................................................." 

echo "${DBG}... Create resource group [$RESOURCE_GROUP]"
az group create -l $LOCATION -n $RESOURCE_GROUP

echo "${DBG}... Creating AKS [$AKS_NAME]"
az aks create -g $RESOURCE_GROUP -n $AKS_NAME \
  --kubernetes-version "1.26.3" \
  --node-count 1 \
  --enable-cluster-autoscaler \
  --min-count 1 \
  --max-count 3 \
  --enable-aad \
  --aad-admin-group-object-ids $AKS_AD_AKSADMIN_GROUP_ID \
  --aad-tenant-id $AZURE_AD_TENANTID \
  --enable-managed-identity \
  --enable-oidc-issuer \
  --enable-asm \
  --os-sku AzureLinux \
  --nodepool-name systempool \
  --node-count 3 \
  --enable-workload-identity --generate-ssh-keys  

echo "${DBG}... Updating the system node pool"
az aks nodepool update -g $RESOURCE_GROUP \
  -n systempool \
  --cluster-name $AKS_NAME \
  --node-taints CriticalAddonsOnly=true:NoSchedule 

echo "${DBG}... Creating the user node pool"
az aks nodepool add \
  --resource-group $RESOURCE_GROUP \
  --cluster-name $AKS_NAME \
  --name userpool \
  --node-count 3 \
  --mode User

echo "${DBG}... enable ingress on [$AKS_NAME]"
az aks mesh enable-ingress-gateway --resource-group $RESOURCE_GROUP --name $AKS_NAME --ingress-gateway-type external

echo "${DBG}... Script completed"
