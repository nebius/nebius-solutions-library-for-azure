# Setting up federation in Nebius through Azure AD

This repository provides a solution for setting up federation in [Nebius](https://nebius.com/il/) with Azure Active Directory.

The detailed process for configuring Azure AD federation in Nebius is described in the following documentation:
- ~~[Authentication using Azure Active Directory](/nebius.com/il/docs/organization/operations/federations/integration-azure)~~

This repository contains an example that allows to set up federation in a semi-automated way.

<br/>

## Prerequisites

The list of prerequisite tools required to configure Azure Arc connectivity includes:
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Nebius CLI](https:///nebius.com/il/docs/cli/operations/install-cli)
- [Terraform client](https://learn.hashicorp.com/tutorials/terraform/install-cli)

<br/>

## Preparing the environment

1. Please make sure that you have logged in YC CLI and initialized your profile.
2. Please make sure that you have logged in Azure CLI and initialized your profile.
3. Get your cloud-id, folder-id and organization-id with the following commands:
```
yc config list
yc organization-manager organization list
```
4. Get your Azure tenant ID using one of the following commands:
```
az login
az account list
az account tenant list
```
5. Create and fill the `private.auto.tfvars` file in the root of the `terraform` subfolder with the data acquired above. Contents of your `private.auto.tfvars` file might look like this as a result:
```
il_folder_id    = "xxx"
il_cloud_id     = "xxx"
il_org_id       = "xxx"
az_tenant_id    = "xxx"
```
6. Check your Nebius authentication in Terraform `provider.tf` file: it might use `key.json` file or `token`.
7. Initialize Terraform module and apply it:
```
terraform init
terraform apply
```

<br/>

## Nebius Federation

Terraform module creates a new Azure enterprise application in the Azure tenant provided, and sets up federation in Nebius with the Azure tenant. Some post-installation actions are still required, and these are described below.

After the Terraform module has been applied, the following output is displayed:
```
il_federation_id = <<EOT
  Nebius Federation ID is
  bpxxxxxxxxxxxx
  ---
  Use the following URL for Identitifier (Entity ID) in Azure AD SAML Configuration:
  https://auth.il.nebius.com/federations/bpxxxxxxxxxxxx
  ---
  Use the following URL for Reply URL in Azure AD SAML Configuration:"
  https://auth.il.nebius.com/federations/bpxxxxxxxxxxxx

EOT
```

This URL should be used to finish the setup in Azure.
Also note the Federation ID – you'll need it to upload the resulting certificate.

## Configuring Azure AD application

Please proceed to your [Enterprise Application](https://portal.azure.com/#blade/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/AllApps) in Azure AD, open Single Sign-On blade and choose SAML option, after that fill the required URL's with the URL from the output of the Terraform module.

<img src="images/az-saml-config.jpg?raw=true" width="400px" alt="IL Login" title="IL Login"><br/>

<br/>

Download the SAML Signing Certificate in Base64 format.

<img src="images/az-certificate.jpg?raw=true" width="400px" alt="YC Login" title="YC Login"><br/>

> The link for download will become active after the required URLs are filled.

Upload the certificate to complete the setup in Nebius using the following command (use the Federation ID from the Terraform output above):
```
yc organization-manager federation saml certificate create --federation-id <FEDERATION_ID> --name "az-il-federation" --certificate-file "az-il-federation.cer"
```

<br/>

## Result

As a result, Azure AD federation is configured with the Nebius Organization.
Authentication should be tested by opening the link `https://console.il.nebius.com/federations/bpxxxxxx` and logging in with your Azure AD user account.

> Roles and permissions for Nebius clouds and folders should be [added](https://console.il.nebius.com/cloud?section=resource-acl) for the user. The role `resource-manager.clouds.member` is required to access the cloud along-side more service-centric roles – to access the services.

> Users should be allowed to use the federation in Enterprise Application properties:

<img src="images/az-assign-users.jpg?raw=true" width="400px" alt="YC Login" title="Assign users in Azure"><br/><br/>

## Delete the resources

If you need to delete the resources that were created, please run the following command:
```
terraform destroy
```
