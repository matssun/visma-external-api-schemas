# Visma External API Schemas - Setup Guide

## 📦 Current Status

✅ **Local Schema Repository Created** at: `/Users/mats/dev/visma-external-api-schemas`

The schema repository has been initialized with:
- Current OpenAPI schema (v1.0 - 2024-02-08)
- Automated update detection script
- GitHub Actions workflow for weekly checks
- Version tracking and changelog

## 🚀 Next Steps: Push to GitHub

### 1. Create GitHub Repository

Create a new public repository on GitHub:

```
Repository name: visma-external-api-schemas
Description: OpenAPI schemas for Visma eAccounting API with automated change detection
Visibility: Public
```

### 2. Push Local Repository

```bash
cd /Users/mats/dev/visma-external-api-schemas

# Add GitHub as remote
git remote add origin https://github.com/yourorg/visma-external-api-schemas.git

# Rename to main branch (optional but recommended)
git branch -M main

# Push to GitHub
git push -u origin main
```

### 3. Add as Submodule to Main Repo

```bash
cd /Users/mats/dev/ws_f/code

# Add schema repo as submodule
git submodule add \
  https://github.com/yourorg/visma-external-api-schemas.git \
  infrastructure/external-schemas/visma

# Commit the submodule
git add .gitmodules infrastructure/external-schemas/visma
git commit -m "add: Visma External API Schemas as git submodule"
```

### 4. Update BUILD Files

Update the Bazel BUILD file to reference the submodule:

**File:** `applications/accounting_visma/visma_client_lib/BUILD.bazel`

```python
# Update the regenerate_models target to use submodule schema:

genrule(
    name = "regenerate_models",
    srcs = [
        # Change from:
        # "//applications/accounting_visma/visma_client_lib/openapi:visma_external_api.yaml",

        # To:
        "//infrastructure/external-schemas/visma:schema",
    ],
    outs = ["models_marker.txt"],
    cmd = """
        set -euo pipefail
        REPO=/Users/mats/dev/ws_f/code

        rm -rf "$$REPO/applications/accounting_visma/visma_client_lib/src/visma_client_lib/generated/models"

        "$$REPO/.venv/bin/datamodel-codegen" \\
            --input $(location //infrastructure/external-schemas/visma:schema) \\
            --input-file-type openapi \\
            --output "$$REPO/applications/accounting_visma/visma_client_lib/src/visma_client_lib/generated/models" \\
            --output-model-type pydantic_v2.BaseModel \\
            --module-split-mode single \\
            --use-annotated \\
            --snake-case-field

        "$$REPO/.venv/bin/python" "$$REPO/infrastructure/scripts/generate_module_inits.py" \\
            --package "$$REPO/applications/accounting_visma/visma_client_lib/src/visma_client_lib/generated"

        echo "Models regenerated" > "$@"
    """,
    local = True,
    tags = ["manual"],
)
```

### 5. Update Bazel BUILD for Schema Repo

Create: `infrastructure/external-schemas/visma/BUILD.bazel`

```python
load("@rules_python//python:defs.bzl", "py_binary")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "schema",
    srcs = ["schemas/current/visma_external_api.yaml"],
)

# Target to fetch latest schema manually
py_binary(
    name = "fetch_updates",
    srcs = ["scripts/fetch-latest-schema.sh"],
    data = ["schemas/current/visma_external_api.yaml"],
)
```

### 6. Configure GitHub Actions Secret

For automatic schema updates, add GitHub secret to the schema repo:

**Setting:** `Settings > Secrets and variables > Actions`

Add secret:
```
Name: VISMA_SCHEMA_URL
Value: <Visma OpenAPI endpoint URL>
```

If Visma doesn't provide a public endpoint, you can manually trigger updates by:
```bash
cd infrastructure/external-schemas/visma
./scripts/fetch-latest-schema.sh
```

### 7. Update Main Codebase

After schema updates are merged:

```bash
cd /Users/mats/dev/ws_f/code

# Pull latest schema from submodule
git submodule update --remote infrastructure/external-schemas/visma

# Regenerate DTOs
bazel build //applications/accounting_visma/visma_client_lib:regenerate_models

# Commit schema update
git add applications/accounting_visma/
git commit -m "chore: Regenerate DTOs from updated Visma schema"
```

## 📋 File Locations

### Schema Repository
- **Local:** `/Users/mats/dev/visma-external-api-schemas`
- **GitHub:** `https://github.com/yourorg/visma-external-api-schemas`

### Current Schema
- **Source:** `infrastructure/external-schemas/visma/schemas/current/visma_external_api.yaml`
- **Used by:** `bazel build //applications/accounting_visma/visma_client_lib:regenerate_models`

### Update Script
- **Location:** `infrastructure/external-schemas/visma/scripts/fetch-latest-schema.sh`
- **Manual update:** `./scripts/fetch-latest-schema.sh`

## 🔄 Workflow

### Automatic Updates (Weekly)
1. GitHub Action checks for schema updates every Monday at 00:00 UTC
2. If changes detected, creates PR with diff
3. Team reviews for breaking changes
4. Once approved, updates merged
5. Main repo updates submodule reference
6. DTOs regenerated and committed

### Manual Updates
1. Run fetch script: `./scripts/fetch-latest-schema.sh`
2. Creates feature branch with changes
3. Push and create PR
4. Follow same review process

## ✅ Checklist

- [ ] Create GitHub repository `visma-external-api-schemas`
- [ ] Push local repository to GitHub
- [ ] Add as git submodule in main repo
- [ ] Update BUILD files to reference submodule
- [ ] Create BUILD.bazel in schema repo directory
- [ ] Configure GitHub Actions secret (if using automatic fetching)
- [ ] Test schema regeneration
- [ ] Commit submodule reference to main repo
- [ ] Document in team wiki/confluence

## 📚 References

- [Git Submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
- [GitHub Actions](https://docs.github.com/en/actions)
- [datamodel-codegen](https://github.com/koxudaxi/datamodel-code-generator)

---

**Status:** Local setup complete, waiting for GitHub repository creation
**Next:** Push to GitHub and configure submodule integration
