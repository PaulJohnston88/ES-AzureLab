# Get the current client configuration from the AzureRM provider.
# This is used to populate the root_parent_id variable with the
# current Tenant ID used as the ID for the "Tenant Root Group"
# Management Group.

module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "6.0.0"

  default_location = "northeurope"

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
    azurerm.management   = azurerm.management
  }

  root_parent_id = data.azurerm_client_config.core.tenant_id
  root_id        = var.root_id
  root_name      = var.root_name
  library_path   = "${path.root}/lib"

  deploy_core_landing_zones        = var.deploy_core_landing_zones
  deploy_management_resources      = var.deploy_management_resources
  subscription_id_management       = "3441441c-93d4-4e85-aef4-08f3f178ba71"
  deploy_connectivity_resources    = var.deploy_connectivity_resources
  configure_connectivity_resources = local.configure_connectivity_resources
  subscription_id_connectivity     = "3441441c-93d4-4e85-aef4-08f3f178ba71"
  subscription_id_identity         = "3441441c-93d4-4e85-aef4-08f3f178ba71"

/*   subscription_id_overrides = {
    "sandboxes" = ["5329ee2f-5c1f-4a2c-8a21-8850ab27057f"]
    "landing-zones" = ["e9df7556-4ca8-4e12-bcc5-55d29dd7fd5d"]
  } */

  custom_landing_zones = {
    "${var.root_id}-online" = {
      display_name               = "${upper(var.root_id)} Online"
      parent_management_group_id = "${var.root_id}-landing-zones"
      subscription_ids           = []
      archetype_config = {
        archetype_id   = "customer_online"
        parameters     = {}
        access_control = {}
      }
    }
    "${var.root_id}-corp" = {
      display_name               = "${upper(var.root_id)} Corp"
      parent_management_group_id = "${var.root_id}-landing-zones"
      subscription_ids           = []
      archetype_config = {
        archetype_id = "customer_online"
        parameters = {
          Deny-Resource-Locations = {
            listOfAllowedLocations = ["west europe", "north europe"]
          }
          Deny-RSG-Locations = {
            listOfAllowedLocations = ["west europe", "north europe"]
          }
        }
        access_control = {}
      }
    }
  }
}