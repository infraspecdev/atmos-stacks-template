# Atmos Stacks Template

This template is for managing infrastructure deployments using [Atmos](https://atmos.tools/) with Terraform. It provides a structured approach to defining environment-specific stack configurations that reference versioned components.

## Prerequisites

1. [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) (>= 1.13.0)
2. [Install Atmos](https://atmos.tools/install) (>= 1.204.0)
3. [Install pre-commit](https://pre-commit.com/#install)
4. Configure pre-commit: `pre-commit install`

## Getting Started

1. **Clone this template:**
   ```bash
   git clone <REPO_URL>
   cd <REPO_NAME>
   ```

2. **Update `stacks/globals.yaml`** with your organization's common tags.

3. **Create a stack file** under `stacks/<environment>/` (e.g., `stacks/staging/my-component.yaml`). Use `stacks/staging/sample-component.yaml` as a reference.

4. **Create a JSON schema** under `stacks/schemas/jsonschema/<environment>/` for input validation.

5. **Validate your stacks:**
   ```bash
   atmos validate stacks
   ```

6. **Plan and apply:**
   ```bash
   atmos terraform plan <component> -s <stage>
   atmos terraform apply <component> -s <stage>
   ```

## Repository Structure

```
.
├── atmos.yaml                          # Atmos configuration
├── stacks/
│   ├── globals.yaml                    # Shared variables across all stacks
│   ├── staging/                        # Staging environment stacks
│   │   └── sample-component.yaml       # Example stack definition
│   ├── prod/                           # Production environment stacks
│   └── schemas/jsonschema/             # JSON schemas for validation
│       └── staging/
│           └── sample-component.json
├── components/terraform/               # Vendored components (auto-managed)
├── .github/
│   ├── workflows/
│   │   ├── terraform-deployment.yaml   # Auto deploy on stack changes
│   │   ├── manual-terraform.yaml       # Manual plan/apply/destroy
│   │   └── pre-commit-checks.yaml      # Pre-commit CI checks
│   └── scripts/
│       └── set-gh-role.sh              # AWS role selection per environment
├── .pre-commit-config.yaml
├── .tflint.hcl
└── .gitignore
```

## Stack File Structure

Each stack file follows the bellow pattern:

```yaml
import:
  - ../globals

vars:
  stage: <component>-<environment>
  aws_region: <region>
  environment: <environment>

components:
  terraform:
    <component-name>:
      settings:
        validation:
          validate-<component>:
            schema_type: jsonschema
            schema_path: "<environment>/<component>.json"
            description: Validate <component> component variables
      source:
        uri: github.com/<org>/terraform-infrastructure-components.git//components/terraform/<component>
        version: <version-tag>
      backend_type: s3
      backend:
        s3:
          bucket: "<backend-bucket>"
          key: "terraform.tfstate"
          region: "<region>"
          encrypt: true
      vars:
        # Component-specific variables
```

## GitHub Actions Workflows

| Workflow | Trigger | Description |
|---|---|---|
| `terraform-deployment.yaml` | PR / Push to `main` on `stacks/**` | Auto-detects changed stacks, runs plan on PR, apply on merge |
| `manual-terraform.yaml` | Manual dispatch | Plan, apply, or destroy a specific stack |
| `pre-commit-checks.yaml` | PR / Push to `main` | Runs pre-commit hooks (YAML lint, atmos validate) |

## Required GitHub Secrets

| Secret | Description |
|---|---|
| `STAGING_GH_ROLE` | AWS IAM Role ARN for staging deployments |
| `PROD_GH_ROLE` | AWS IAM Role ARN for production deployments |
| `COMPONENTS_ACCESS_TOKEN` | GitHub personal access token for accessing private component repos |
