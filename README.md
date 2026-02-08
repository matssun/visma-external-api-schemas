# Visma External API Schemas

📋 **Official OpenAPI schema repository for Visma eAccounting API**

This repository maintains the authoritative OpenAPI specifications for the Visma eAccounting API, with automated change detection, versioning, and integration into the main application monorepo.

## 📁 Repository Structure

```
schemas/
├── current/
│   └── visma_external_api.yaml          # Current active schema
└── archive/
    └── visma_external_api.yaml.2024-01* # Previous versions

scripts/
└── fetch-latest-schema.sh               # Manual schema update script

.github/workflows/
└── check-schema-updates.yml             # Automated change detection

SCHEMA_CHANGELOG.md                       # Detailed change history
VERSION                                  # Current version metadata
```

## 🔄 How Schema Updates Work

### Automatic Detection (Weekly)

GitHub Actions runs every Monday at 00:00 UTC to:
1. Fetch the latest Visma schema
2. Compare with current version
3. Create PR if changes detected
4. Tag with `schema-update` label

### Manual Update

To manually check for schema updates:

```bash
./scripts/fetch-latest-schema.sh
```

This will:
- Download latest schema from Visma
- Compare with current version
- Show differences
- Create a feature branch if changes found

## 📦 Integration with Main Codebase

This repository is added as a **Git submodule** to the main monorepo:

```bash
infrastructure/external-schemas/visma/
```

The main codebase references schemas from:
```
infrastructure/external-schemas/visma/schemas/current/visma_external_api.yaml
```

### Updating Schemas in Main Repo

When schema updates are merged here:

```bash
cd <main-repo>
git submodule update --remote infrastructure/external-schemas/visma

# This downloads the latest schema
# Then regenerate DTOs:
bazel build //applications/accounting_visma/visma_client_lib:regenerate_models
```

## 🚨 Breaking Changes

Any **breaking changes** in the schema are highlighted in:
- PR descriptions
- `SCHEMA_CHANGELOG.md`
- PR labels: `breaking-change`

Examples of breaking changes:
- Removing required fields
- Changing field types
- Removing API endpoints
- Changing enum values

## ✅ Schema Validation

Before accepting schema updates, verify:

- [ ] No duplicate enum definitions (consolidated with `$ref`)
- [ ] All `$ref` references are resolvable
- [ ] Required fields are clearly marked
- [ ] Field descriptions are accurate
- [ ] Examples are valid

## 🔗 Links

- **Visma eAccounting API**: https://developer.visma.com/
- **OpenAPI Specification**: https://spec.openapis.org/oas/v3.0.3
- **Main Repository**: (linked via submodule)

## 📝 License

This repository contains Visma API specifications. Usage is subject to Visma's API Terms of Service.

---

**Last Updated:** 2024-02-08
**Current Version:** v1.0
**Maintained by:** [Your Team]
