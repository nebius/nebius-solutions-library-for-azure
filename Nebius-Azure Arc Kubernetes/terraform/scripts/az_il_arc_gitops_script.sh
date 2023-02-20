#!/bin/sh

# Creating Gitops configuration
echo "# Creating k8s-configuration for Gitops"
az k8s-configuration create --name azure-arc-demo --cluster-name azure-arc --resource-group RG-azure-arc --operator-instance-name azure-arc-demo --operator-namespace azure-arc-demo --operator-params='--git-branch=main' --repository-url https://github.com/knpsh/k8s-app --scope cluster --cluster-type connectedClusters