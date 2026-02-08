# ✅ Visma Schema Repository Setup Complete

**Date:** 2024-02-08
**Status:** ✅ Local repository initialized and ready for GitHub

---

## 📦 What's Been Created

### 1. **Schema Repository Structure**
```
/Users/mats/dev/visma-external-api-schemas/
├── schemas/
│   ├── current/
│   │   └── visma_external_api.yaml (v1.0 - consolidated enums)
│   └── archive/                     (for previous versions)
├── scripts/
│   └── fetch-latest-schema.sh       (smart update detection)
├── .github/workflows/
│   └── check-schema-updates.yml     (automated weekly checks)
├── README.md                         (repo documentation)
├── SCHEMA_CHANGELOG.md               (change history)
├── VERSION                           (version tracking)
└── .git/                             (git repository initialized)
```

### 2. **Current Schema**
- ✅ OpenAPI specification copied from main repo
- ✅ Fixed: Consolidated 6 duplicate `RotReducedInvoicingType` enums into single component
- ✅ All inline enums replaced with `$ref` references
- ✅ Version: v1.0 (2024-02-08)

### 3. **Automation Ready**
- ✅ GitHub Actions workflow (weekly checks on Monday 00:00 UTC)
- ✅ Manual fetch script (`scripts/fetch-latest-schema.sh`)
- ✅ Auto-detection of breaking changes
- ✅ Auto-creation of feature branches and PRs

### 4. **Documentation**
- ✅ README.md - Complete repository guide
- ✅ SCHEMA_CHANGELOG.md - Change tracking
- ✅ VERSION file - Current version metadata

---

## 🚀 Next Steps (Required)

### Phase 1: Push to GitHub (5 minutes)

1. **Create Repository on GitHub**
   ```
   Name: visma-external-api-schemas
   Visibility: Public
   Description: OpenAPI schemas for Visma eAccounting API
   ```

2. **Push Local Repository**
   ```bash
   cd /Users/mats/dev/visma-external-api-schemas
   git remote add origin https://github.com/yourorg/visma-external-api-schemas.git
   git branch -M main
   git push -u origin main
   ```

3. **Enable GitHub Actions**
   - Go to repository Settings > Actions
   - Enable "Allow all actions and reusable workflows"

4. **Add GitHub Secret (Optional)**
   - If Visma provides public schema endpoint:
   - Settings > Secrets and variables > Actions
   - Add: `VISMA_SCHEMA_URL` = (Visma API endpoint)

### Phase 2: Integrate with Main Repo (10 minutes)

1. **Create infrastructure/external-schemas directory**
   ```bash
   cd /Users/mats/dev/ws_f/code
   mkdir -p infrastructure/external-schemas
   ```

2. **Add as Git Submodule**
   ```bash
   git submodule add \
     https://github.com/yourorg/visma-external-api-schemas.git \
     infrastructure/external-schemas/visma
   ```

3. **Create BUILD file**
   See: `infrastructure/SCHEMA_SETUP_GUIDE.md`

4. **Update Main Repo BUILD Files**
   - Reference schema from submodule instead of local file
   - Update datamodel-codegen to use new path

5. **Commit and Push**
   ```bash
   git add .gitmodules infrastructure/
   git commit -m "add: Visma schema repository as git submodule"
   git push
   ```

### Phase 3: Test Integration (5 minutes)

```bash
# Pull schema from submodule
git submodule update --init --recursive

# Verify schema is accessible
ls infrastructure/external-schemas/visma/schemas/current/

# Test regeneration
bazel build //applications/accounting_visma/visma_client_lib:regenerate_models
```

---

## 🔄 How It Works

### Automatic Schema Updates (Weekly)

```
Monday 00:00 UTC
    ↓
GitHub Action triggers
    ↓
Checks for Visma schema updates
    ↓
If changes detected:
    ├─ Archives previous version
    ├─ Updates to latest schema
    ├─ Detects breaking changes
    ├─ Creates feature branch
    ├─ Commits with detailed message
    └─ Creates PR for review
        ↓
        Team reviews diff
        ↓
        If approved: merge
        ↓
        Main repo updates submodule
        ↓
        DTOs regenerated
```

### Manual Schema Update

```bash
cd infrastructure/external-schemas/visma
./scripts/fetch-latest-schema.sh

# Script:
# 1. Fetches latest from Visma (if URL configured)
# 2. Shows diff vs current
# 3. Creates feature branch if changes
# 4. Archives old version
# 5. Updates VERSION file
# 6. Creates commit
```

---

## 📊 Benefits

✅ **Version Control:** Full git history of schema changes
✅ **Change Detection:** Automated weekly checks for updates
✅ **Code Review:** PRs for all schema changes
✅ **Breaking Change Detection:** Alerts for incompatible updates
✅ **Archive:** Previous versions preserved for reference
✅ **Integration:** Single source of truth for DTOs
✅ **Documentation:** Complete changelog of modifications

---

## 📁 File Structure Summary

### Main Repo (`/Users/mats/dev/ws_f/code`)
```
infrastructure/
├── external-schemas/visma/    ← Git submodule (points to GitHub repo)
│   ├── schemas/current/visma_external_api.yaml
│   └── ...
└── SCHEMA_SETUP_GUIDE.md       ← Detailed setup instructions
```

### Schema Repo (`/Users/mats/dev/visma-external-api-schemas`)
```
schemas/current/               ← Current active schema
scripts/fetch-latest-schema.sh ← Manual update script
.github/workflows/             ← GitHub Actions automation
VERSION                        ← Version metadata
SCHEMA_CHANGELOG.md            ← Change history
README.md                      ← Documentation
```

---

## ⚙️ Configuration

### GitHub Actions Secret (Optional)

For automatic fetching, set `VISMA_SCHEMA_URL` secret:

```bash
gh secret set VISMA_SCHEMA_URL \
  --body "https://api.visma.com/v2/openapi.yaml" \
  -R yourorg/visma-external-api-schemas
```

### Manual Update Without URL

If Visma doesn't provide a public endpoint:

1. Download schema manually from Visma
2. Copy to `schemas/current/visma_external_api.yaml`
3. Run: `./scripts/fetch-latest-schema.sh` (it will detect the change)
4. Follow the branch/PR workflow

---

## 📞 Support

- **Setup Guide:** See `infrastructure/SCHEMA_SETUP_GUIDE.md`
- **Schema Repo README:** `visma-external-api-schemas/README.md`
- **Change Tracking:** `SCHEMA_CHANGELOG.md`

---

## ✨ Key Features Implemented

### Root Cause Analysis & Fix
- ✅ Identified 6 duplicate `RotReducedInvoicingType` enum definitions
- ✅ Consolidated into single shared component in schema
- ✅ Fixed type compatibility issues in generated DTOs

### Automated Change Detection
- ✅ GitHub Actions workflow for weekly checks
- ✅ Automatic PR creation with detailed diffs
- ✅ Breaking change detection and labeling

### Version Tracking
- ✅ VERSION file for current schema version
- ✅ SCHEMA_CHANGELOG.md for detailed history
- ✅ Archive directory for previous versions
- ✅ Auto-archiving of old schemas on updates

### Team Integration
- ✅ Git submodule for clean integration
- ✅ Pull request workflow for schema updates
- ✅ Comprehensive documentation
- ✅ Automated validation and testing ready

---

**🎉 Ready to push to GitHub and integrate with main repo!**
