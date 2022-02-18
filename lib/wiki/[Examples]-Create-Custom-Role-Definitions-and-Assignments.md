## Overview

This page describes how to deploy Enterprise-Scale with custom policy definitions and policy set (Initiative) definitions.

In this example we will use a policy named `Enforce-RG-Tags` and a  policy set definition (Initiative_) named `LZ-Baseline` as examples of how to create and assign custom policies.

We will update the built-in configuration by following these steps:

- Create the custom policy definition file for `Enforce-RG-Tags`

- Create the custom policy set definition file for `LZ-Baseline`

- Make the custom policy definitions available for use in Azure by extending the built-in archetype for `es_root`

- Create the policy assignment files for `Enforce-RG-Tags` and `LZ-Baseline` so that they can be assigned

- Assign the custom policy definition for `Enforce-RG-Tags` at the `root` Management Group by extending the built-in archetype for `es_root`.

- Assign the custom policy set definition for `LZ-Baseline` at the `Landing Zones` Management Group by extending the built-in archetype for `es_landing_zones`.

![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/Azure/terraform-azurerm-caf-enterprise-scale?style=flat&logo=github)

## Create Custom Policy Definition

>IMPORTANT: To make the code easier to maintain when extending your configuration, we recommend using a custom library as explained in LINK

In order to create and assign custom policies, we need to create both a definition file and an assignment file for each custom policy or custom policy set definition. In this example we will do this by using the below files:

- [lib/policy_definitions/policy_definition_es_enforce_rg_tags.json](#libpolicy_definitions_policy_definition_es_enforce_rg_tagsjson)
- [lib/policy_assignments/policy_assignment_es_policy_set_definition.json](#libpolicy_assignmentspolicy_assignment_es_enforce_rg_tagsjson)

In your `/lib` directory create a `policy_definitions` subdirectory.

In the `policy_definitions` subdirectory, create a `policy_definition_es_policy_enforce_rg_tags_definition.json` file. This file will contain the Policy Definition for `Enforce-RG-Tags`. Copy the below code in to the file and save it.

### `lib/policy_definitions/policy_definition_es_enforce_rg_tags.json`

```json
{
    "name": "Enforce-RG-Tags",
    "type": "Microsoft.Authorization/policyDefinitions",
    "apiVersion": "2021-06-01",
    "scope": null,
      "properties": {
        "displayName": "Enforce Mandatory Tags on Resource Groups",
        "policyType": "Custom",
        "mode": "All",
        "description": "Enforce mandatory tagging on Resource Groups",
        "metadata": {
          "version": "1.0.0",
          "category": "Tags"
        },
        "policyRule": {
        "if": {
            "allOf":[
                {            
                "field": "type",
                "equals": "Microsoft.Resources/subscriptions/resourceGroups"
                },
                {
                "anyof": [
                {
                    "field": "[concat('tags[', parameters('tag1Name'), ']')]",
                    "notin": "[parameters('tag1Value')]"
                },
                {
                    "field": "[concat('tags[', parameters('tag2Name'), ']')]",
                    "notin": "[parameters('tag2Value')]"
                }
                ]
            }
            ]
        },
        "then": {
            "effect": "deny"
        }
        },
        "parameters": {
            "tag1Name": {
                "type": "String",
                "metadata": {
                "displayName": "Tag 1 Name",
                "description": "Name of the tag, such as 'Cost Center'"
                },
                "defaultValue": "Cost Center"
            },
            "tag1Value": {
                "type": "Array",
                "metadata": {
                "displayName": "Tag 1 Value",
                "description": "Value of the tag, such as 'Joe Bloggs'"
                },
                "defaultValue": [""]
            },
            "tag2Name": {
                "type": "String",
                "metadata": {
                "displayName": "Tag 2 Name",
                "description": "Name of the tag, such as 'Department'"
                },
                "defaultValue": "Department"
            },
            "tag2Value": {
                "type": "Array",
                "metadata": {
                "displayName": "Tag 2 Value",
                "description": "Value of the tag, such as 'Joe Bloggs'"
                },
                "defaultValue": [""]
            }
        }
    }
}
```

## Create Custom Policy Set Definition

In your `/lib` directory create a `policy_set_definitions` subdirectory.

In the `policy_set_definitions` subdirectory, create a `policy_set_definition_es_lz_baseline.json` file. This file will contain the Policy Definition for `Enforce-RG-Tags`. Copy the below code in to the file and save it.

- [lib/policy_set_definitions/policy_set_definition_es_root_baseline.json](#libpolicy_assignmentspolicy_assignment_dhh_policy_set_definitionjson)

```json
{
    "name": "LZ-Baseline",
    "type": "Microsoft.Authorization/policySetDefinitions",
    "apiVersion": "2021-06-01",
    "scope": null,
    "properties": {
      "policyType": "Custom",
      "displayName": "LZ Baseline",
      "description": "Contains the core policies applicable to the  org that need to be assigned at the Landing Zone Management Group",
      "metadata": {
        "version": "1.0.0",
        "category": "General"
      },
      "parameters": {
        "Automation account variables should be encrypted": {
            "type": "String",
            "defaultValue": "Deny",
            "allowedValues": [
              "Audit",
              "Deny",
              "Disabled"
            ],
            "metadata": {
              "displayName": "Automation account variables should be encrypted",
              "description": "It is important to enable encryption of Automation account variable assets when storing sensitive data"
            }
        },
        "Azure Cosmos DB accounts should have firewall rules": {
            "type": "String",
            "defaultValue": "Audit",
            "allowedValues": [
              "Audit",
              "Deny",
              "Disabled"
            ],
            "metadata": {
              "displayName": "Azure Cosmos DB accounts should have firewall rules",
              "description": "Firewall rules should be defined on your Azure Cosmos DB accounts to prevent traffic from unauthorized sources. Accounts that have at least one IP rule defined with the virtual network filter enabled are deemed compliant. Accounts disabling public access are also deemed compliant."
            }
        }
      },
      "policyDefinitions": [
        {
          "policyDefinitionReferenceId": "Automation account variables should be encrypted",
          "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/3657f5a0-770e-44a3-b44e-9431ba1e9735",
          "parameters": {
            "effect": {
              "value": "[parameters('Automation account variables should be encrypted')]"
            }
          },
          "groupNames": []
        },
        {
          "policyDefinitionReferenceId": "Audit VMs that do not use managed disks",
          "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d",
          "groupNames": []
        },
        {
            "policyDefinitionReferenceId": "Azure Cosmos DB accounts should have firewall rules",
            "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/862e97cf-49fc-4a5c-9de4-40d4e2e7c8eb",
            "parameters": {
                "effect": {
                "value": "[parameters('Azure Cosmos DB accounts should have firewall rules')]"
                }
            },
            "groupNames": []
        }
      ],
      "policyDefinitionGroups": null
    }
  }
```

## Create Custom Policy Assignment Files

In your `/lib` directory create a `policy_assignments` subdirectory.

- [lib/policy_assignments/policy_assignment_es_enforce_rg_tags.json](#libpolicy_assignmentspolicy_assignment_es_enforce_rg_tagsjson)

- [lib/policy_assignments/policy_assignment_es_lz_baseline.json](#libpolicy_assignmentspolicy_assignment_dhh_policy_set_definitionjson)

### `lib/policy_assignments/policy_assignment_es_enforce_rg_tags.json`

```json
{
    "name": "Enforce-RG-Tags",
    "type": "Microsoft.Authorization/policyAssignments",
    "apiVersion": "2019-09-01",
    "properties": {
        "description": "Enforce Mandatory Tags on Resource Groups",
        "displayName": "Enforce Mandatory Tags on Resource Groups",
        "notScopes": [],
        "parameters": {
        } ,
        "policyDefinitionId": "${root_scope_resource_id}/providers/Microsoft.Authorization/policyDefinitions/Enforce-RG-Tags",
        "scope": "${current_scope_resource_id}",
        "enforcementMode": null,
        "nonComplianceMessages": [
        {
            "message": "Mandatory tags must be provided."
        }
        ]
    },
    "location": "${default_location}",
    "identity": {
        "type": "SystemAssigned"
    }
}
```
### `lib/policy_assignments/policy_assignment_es_lz_baseline.json`

```json
{
  "name": "LZ-Baseline",
  "type": "Microsoft.Authorization/policyAssignments",
  "apiVersion": "2019-09-01",
  "properties": {
    "description": "Contains the core policies applicable to the org that need to be assigned at the Landing Zone Management Group",
    "displayName": "LZ Baseline",
    "notScopes": [],
    "parameters": {
    },
    "policyDefinitionId": "${root_scope_resource_id}/providers/Microsoft.Authorization/policySetDefinitions/LZ-Baseline",
    "scope": "${current_scope_resource_id}",
    "enforcementMode": null
  },
  "location": "${default_location}",
  "identity": {
    "type": "SystemAssigned"
  }
}
```

## Make the Custom Policy Definition and Policy Set Definition available for use

Now that you have created your custom policy definition and policy set definition files, we need to save them at the Intermediate Root Management Group to ensure they can be used at that scope or any scope beneath. To do that, we need to extend the built-in archetype for `es_root`.

If you don't already have an `archetype_extension_es_root.tmpl.json` file within your custom `/lib` folder, create one and copy the below code in to the file. This code saves the custom policy definition and policy set definition but we have not yet assigned them.

```json
{
  "extend_es_root": {
    "policy_assignments": [],
    "policy_definitions": ["Enforce-RG-Tags"],
    "policy_set_definitions": ["LZ-Baseline"],
    "role_definitions": [],
    "archetype_config": {
      "access_control": {
      }
    }
  }
}
```
You should now run `Terraform Apply` to apply the new configuration and make the custom policies available for assignment.

```hcl
terraform apply
```

## Assign the Custom Policy at the Intermediate Root Management Group

You now need to assign the policy and in this example, we will assign it at `es_root`. To do this, update your existing `archetype_extension_es_root.tmpl.json` file with the below code and save it.

```json
{
  "extend_es_root": {
    "policy_assignments": ["Enforce-RG-Tags"],
    "policy_definitions": ["Enforce-RG-Tags"],
    "policy_set_definitions": ["LZ-Baseline"],
    "role_definitions": [],
    "archetype_config": {
      "access_control": {
      }
    }
  }
}
```

You should now run `Terraform Apply` to apply the new configuration which will assign the `Enforce-RG-Tags` policy.

```hcl
terraform apply
```

## Assign the Custom Policy Set Definition at the Landing Zones Management Group

Next, we will assign the Custom Policy Set that you previously created at the `Landing Zones` Management Group. To do this, either update your existing `archetype_extension_es_landing_zones.tmpl.json` file or create a new one with that name and copy the below code in to it and save.

```json
{
  "extend_es_landing_zones": {
    "policy_assignments": ["LZ-Baseline"],
    "policy_definitions": [""],
    "policy_set_definitions": [],
    "role_definitions": [],
    "archetype_config": {
      "access_control": {
      }
    }
  }
}
```

You now need to run `Terraform Apply` again to apply the new configuration. When complete, the `LZ-Baseline` policy set definition should be assigned.

```hcl
terraform apply
```