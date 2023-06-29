#!/bin/bash
echo "... Loading variables"
. ./variables.sh

export NS="pinfo1"

echo "${DBG}... create namespace [$NS]"
kubectl create namespace $NS

echo "${DBG}... label the namespace for istio asm [$NS]"
kubectl label namespace $NS istio.io/rev=asm-1-17


echo "${DBG}... deploy podinfo on namespace [$NS]"
helm repo add podinfo https://stefanprodan.github.io/podinfo

echo "${DBG}... ... frontend"
helm upgrade --install --wait frontend --namespace $NS --set replicaCount=2 --set backend=http://backend-podinfo:9898/echo podinfo/podinfo
helm test frontend --namespace $NS

echo "${DBG}... ... backend"
helm upgrade --install --wait backend --namespace $NS --set replicaCount=2  --set redis.enabled=true podinfo/podinfo


echo "${DBG}... deploy debug pod on ns [$NS]"
kubectl apply -f ../k8s/curl.yaml -n $NS

helm list -A

# helm uninstall frontend -n $NS
# helm uninstall backend -n $NS

echo "${DBG}... get load balancer IP"
LB_IP=$(kubectl -n kube-system get svc aks-istio-ingressgateway-external -n aks-istio-ingress -o json | jq -r .status.loadBalancer.ingress[0].ip)
echo "${DBG}... LB_IP : $LB_IP"


echo "${DBG}... deploy istio gateway and virtual-service for pinfo on namespace [$NS]"
kubectl apply -f - <<EOF
---
apiVersion: networking.istio.io/v1beta1
kind: Gateway
metadata:
 name: istio-ingress-$NS
 namespace: $NS
spec:
 selector:
   istio: aks-istio-ingressgateway-external
 servers:
 - port:
     number: 80
     name: http
     protocol: HTTP
   hosts:
   - '$NS.$LB_IP.nip.io'
---
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
 name: virtual-pinfo
 namespace: $NS
spec:
 hosts:
   - "$NS.$LB_IP.nip.io"
 gateways:
   - $NS/istio-ingress-$NS
 http:
 - match:
   - uri:
       prefix: "/"
   route:
   - destination:
       host: "frontend-podinfo.$NS.svc.cluster.local"
       port:
         number: 9898
EOF



