az login
az group create --name k8-rg --location eastus

az aks create --resource-group k8-rg --name k8cluster --node-count 1 --node-vm-size Standard_DS2_v2 --location eastus
az aks nodepool add --resource-group k8-rg --cluster-name k8cluster --name backendpool --node-count 1 --labels app=greetings-app
az aks nodepool add --resource-group k8-rg --cluster-name k8cluster --name frontendpool --node-count 1 --labels app=redis

az aks nodepool update --cluster-name k8cluster --name frontendpool --resource-group k8-rg --labels app=greetings-app
az aks nodepool update --cluster-name k8cluster --name backendpool --resource-group k8-rg --labels app=redis


az acr create --resource-group k8-rg --name k8taskregistry --sku Basic

#registry name :k8taskregistry    and enable the docker login option as it is private registry  


docker build -t k8taskregistry.azurecr.io/my-python-app:v1 .

#docker tag mypythonapp myacrname.azurecr.io/mypythonapp:v1

docker login k8taskregistry.azurecr.io   

#(in above command give user name and password which is generated after enabling)
docker images
docker push k8taskregistry.azurecr.io/my-python-app:v1



az aks get-credentials --resource-group k8-rg --name k8cluster

#New-Alias -Name 'k' -Value 'kubectl'

#k8taskregistry.azurecr.io/my-python-app:latest
kubectl create secret docker-registry acr-secret --docker-server=k8taskregistry.azurecr.io --docker-username=k8taskregistry --docker-password=kQS8s2BN31RkOG1JkrVOiHFTj2Ue9LU597G+4jE8+z+ACRD11VSg --docker-email=abhay_varshney@epam.com

kubectl apply -f k8s-deployment.yaml

kubectl get secret