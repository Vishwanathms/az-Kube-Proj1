# Kubernetes Based microservice Deployment with Code and Image Scanning using Azure pipeline

## This is project work for below flow 
* Bicep Templates
* Azure Devops 
* Kubernetes 
* Docker 
* Azure container Registry  -- To Store 
* SonarQube -- Code scanner 
* Trivy -- Docker Image scanner
* Artifactory 
* Azure key vault
* Kubernetes Monitoring tools


## Steps
### Step1

* create azure repo 
* Login to it.
```
    git init
    git checkout -b main
    git add .
    git commit -m "Initial commit"
    git remote add origin git@ssh.dev.azure.com:v3/tg-vishwa-aug24/Kube-Proj1/Kube-Proj1
    git push
    git push --set-upstream origin main
```
### Step2
* Create bicep template for creating below resource 
  * Az login to login to azure 
  * vnet and subnet 
```
az deployment group create --resource-group kube-proj-sep-24 --template-file ./vnet-subnet.bicep

az deployment group list --resource-group kube-proj-sep-24 --query "[].{Name:name}" -o table

az deployment group delete --name vnet-subnet --resource-group kube-proj-sep-24

```
  * azure key vault 
  * Build Agent with docker installed 
```
az deployment group create --resource-group kube-proj-sep-24 --template-file ./keyvault-vm.bicep

az deployment group delete --name keyvault-vm --resource-group kube-proj-sep-24
```
  * ACR 
```
az provider register --namespace Microsoft.ContainerRegistry

az deployment group create \
  --resource-group kube-proj-sep-24 \
  --template-file ./acr.bicep \
  --query "{acrLoginServer:properties.outputs.acrLoginServer.value, acrAdminUsername:properties.outputs.acrAdminUsername.value, acrAdminPassword:properties.outputs.acrAdminPassword.value}" \
  --output json > acr_output.json

az deployment group delete --name  acr --resource-group kube-proj-sep-24

```
  * AKS with 2 nodes
```
az network vnet show --resource-group <your-resource-group> --name <your-vnet-name> --query id --output tsv 

az deployment group create \
  --resource-group kube-proj-sep-24 \
  --template-file ./aks-node-2.bicep \
  --parameters @aks-param.json


az deployment group delete --name  aks-node-2 --resource-group kube-proj-sep-24
```

```
    aksClusterName='myAKSCluster' \
    kubernetesVersion='1.28.0' \
    nodeCount=2 \
    nodeVmSize='Standard_DS2_v2' \
    vnetId='/subscriptions/{subscription-id}/resourceGroups/{resource-group}/providers/Microsoft.Network/virtualNetworks/{vnet-name}' \
    subnetName='mySubnet'


```
  * Kubernetes monitoring tools

