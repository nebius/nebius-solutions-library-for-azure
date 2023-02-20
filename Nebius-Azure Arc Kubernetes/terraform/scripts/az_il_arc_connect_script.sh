#!/bin/sh

# Re-setting up extensions
echo "# Setting up Azure extensions"
az extension remove --name connectedk8s
az extension remove --name k8s-configuration
rm -rf ~/.azure/AzureArcCharts
az extension add --name connectedk8s
az extension add --name k8s-configuration

# Setting up connected cluster with Azure Arc
echo "# Log in to Azure using service principal"
az login --service-principal --username 619d5d9a-26f9-4a1f-9824-83f728e101cf --password kvc8Q~tih9fIauJnhavVCrX1DwZnL~DWEU1V9bZy --tenant 8dfe9017-7fce-45cd-a294-8799321cc073

echo "# Connecting the YC K8S cluster to Azure Arc"
az connectedk8s connect --name azure-arc --resource-group RG-azure-arc --location westeurope --tags "Project=azure-arc-demo"

echo "# Enabling Cluster Connect feature"
az connectedk8s enable-features --features cluster-connect -n azure-arc -g RG-azure-arc

# Configure service account for token authentication
echo "# Configuring service account for token authentication in Azure Arc portal"
kubectl create serviceaccount azure-arc-user
kubectl create clusterrolebinding azure-arc-binding --clusterrole cluster-admin --serviceaccount default:azure-arc-user
SECRET_NAME=$(kubectl get serviceaccount azure-arc-user -o jsonpath='{$.secrets[0].name}')
TOKEN=$(kubectl get secret $SECRET_NAME -o jsonpath='{$.data.token}' | base64 -d | sed $'s/$/\\\n/g')
echo "# Use the token below during authentication in Azure Arc portal:"
echo "-----"
echo $TOKEN
echo "-----"