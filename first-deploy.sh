
sbt buildApp
kubectl create ns hello-world
./setup-example-rbac.sh
helm repo add stable https://charts.helm.sh/stable --force-update | true
helm repo update
helm upgrade -i nfs-server-provisioner stable/nfs-server-provisioner --set storageClass.provisionerName=cloudflow-nfs --namespace hello-world
kubectl apply -f flink-pvc.yaml -n hello-world
kubectl apply -f hello-world.yaml
./deploy.sh
