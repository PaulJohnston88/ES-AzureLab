# Get the current client configuration from the AzureRM provider.
# This is used to populate the root_parent_id variable with the
# current Tenant ID used as the ID for the "Tenant Root Group"
# Management Group.

module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "1.1.1"

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
    azurerm.management   = azurerm.management
  }

  root_parent_id = data.azurerm_client_config.core.tenant_id
  root_id        = var.root_id
  root_name      = var.root_name
  library_path   = "${path.root}/lib"

  deploy_core_landing_zones    = true
  deploy_management_resources  = var.deploy_management_resources
  subscription_id_management   = "b7190f8a-860a-428c-a303-7231b1eb2f60"
  deploy_connectivity_resources = var.deploy_connectivity_resources
  configure_connectivity_resources = local.configure_connectivity_resources
  subscription_id_connectivity = "e0583bb4-bb6c-44b8-9b39-72b0d4a1a6eb"

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