#!/bin/bash

az deployment group delete --name  aks-node-2 --resource-group kube-proj-sep-24

az deployment group delete --name  acr --resource-group kube-proj-sep-24

az deployment group delete --name keyvault-vm --resource-group kube-proj-sep-24

az deployment group delete --name vnet-subnet --resource-group kube-proj-sep-24