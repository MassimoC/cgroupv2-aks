
# 31 on 1.21

```

kubectl create namespace bbq
kubect apply -f ./bbq_net31.yaml -n bbq

for i in {1..2000};do curl -s -o /dev/null -w "HTTP %{http_code}" http://52.233.255.232.nip.io:9999/api/v1/bbq; echo; done

```

# 31 on 1.26

```
kubectl create namespace bbq
kubectl apply -f ./bbq_net60.yaml -n bbq

for i in {1..2000};do curl -s -o /dev/null -w "HTTP %{http_code}" http://old.20.86.216.236.nip.io:9999/api/v1/bbq; echo; done
```

# 60 on 1.26

```
kubectl create namespace bbq60
kubectl apply -f ./bbq_net60.yaml -n bbq60
 
for i in {1..2000};do curl -s -o /dev/null -w "HTTP %{http_code}" http:/new.20.4.149.114.nip.io:9999/api/v1/bbq; echo; done
```