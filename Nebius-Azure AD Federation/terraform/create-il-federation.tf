resource "yandex_organizationmanager_saml_federation" "il_federation" {
  depends_on                    = [azuread_application.az-app]
  name                          = var.app_name
  description                   = "Azure-il Federation"
  organization_id               = var.il_org_id
  sso_url                       = "https://login.microsoftonline.com/${var.az_tenant_id}/saml2"
  issuer                        = "https://sts.windows.net/${var.az_tenant_id}/"
  cookie_max_age                = "12h"
  auto_create_account_on_login  = true
  sso_binding                   = "POST"
}

output "il_federation_id" {
  value = <<EOT
  CloudIL Federation ID is 
  ${yandex_organizationmanager_saml_federation.il_federation.id}
  ---
  Use the following URL for Identitifier (Entity ID) in Azure AD SAML Configuration: 
  https://auth.cloudil.co.il/federations/${yandex_organizationmanager_saml_federation.il_federation.id}
  ---
  Use the following URL for Reply URL in Azure AD SAML Configuration:"
  https://auth.cloudil.co.il/federations/${yandex_organizationmanager_saml_federation.il_federation.id}
  EOT
}