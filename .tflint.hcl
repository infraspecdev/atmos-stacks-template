plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

plugin "aws" {
    enabled = true
    version = "0.32.0"
    source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

# Disabled because tags are managed centrally via Atmos globals.yaml
# and passed dynamically via var.tags, which tflint can't detect
rule "aws_resource_missing_tags" {
  enabled = false
}

# Disallow output declarations without description.
rule "terraform_documented_outputs" {
  enabled = true
}

# Disallow variables, data sources, and locals that are declared but never used.
rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_module_pinned_source" {
  enabled = true
  style = "flexible"
  default_branches = ["dev"]
}

# Enforces naming conventions
rule "terraform_naming_convention" {
  enabled = true

  #Require specific naming structure
  variable {
  format = "snake_case"
  }

  locals {
  format = "snake_case"
  }

  output {
  format = "snake_case"
  }
}
