#!/bin/bash

az deployment group create --resource-group kube-proj-sep-24 --template-file ./vnet-subnet.bicep

az deployment group create --resource-group kube-proj-sep-24 --template-file ./keyvault-vm.bicep

az provider register --namespace Microsoft.ContainerRegistry

az deployment group create \
  --resource-group kube-proj-sep-24 \
  --template-file ./acr.bicep \
  --query "{acrLoginServer:properties.outputs.acrLoginServer.value, acrAdminUsername:properties.outputs.acrAdminUsername.value, acrAdminPassword:properties.outputs.acrAdminPassword.value}" \
  --output json > acr_output.json

az deployment group create \
  --resource-group kube-proj-sep-24 \
  --template-file ./aks-node-2.bicep \
  --parameters @aks-param.json