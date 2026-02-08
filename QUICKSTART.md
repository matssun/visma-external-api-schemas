# 🚀 Quick Start Guide

## Current Status
✅ **Local repository ready** - see `SETUP_COMPLETE.md` for details

---

## Push to GitHub (< 5 min)

```bash
# 1. Create repo on GitHub: visma-external-api-schemas (public)

# 2. Push this repo
cd /Users/mats/dev/visma-external-api-schemas
git remote add origin https://github.com/yourorg/visma-external-api-schemas.git
git branch -M main
git push -u origin main

# 3. Enable Actions: GitHub > Settings > Actions > Allow all actions
```

---

## Add to Main Repo (< 10 min)

```bash
cd /Users/mats/dev/ws_f/code

# Add submodule
git submodule add https://github.com/yourorg/visma-external-api-schemas.git \
  infrastructure/external-schemas/visma

# Commit
git add .gitmodules infrastructure/external-schemas/visma
git commit -m "add: Visma schema repository as git submodule"
git push
```

---

## Update Main Repo BUILD Files

**File:** `applications/accounting_visma/visma_client_lib/BUILD.bazel`

In the `regenerate_models` genrule, change:

```python
# FROM:
srcs = [
    "//applications/accounting_visma/visma_client_lib/openapi:visma_external_api.yaml",
],

# TO:
srcs = [
    "//infrastructure/external-schemas/visma:schema",
],
```

Then update the command to use the new path if needed.

---

## Create BUILD File for Schema Repo

**File:** `infrastructure/external-schemas/visma/BUILD.bazel`

```python
package(default_visibility = ["//visibility:public"])

filegroup(
    name = "schema",
    srcs = ["schemas/current/visma_external_api.yaml"],
)
```

---

## Test Integration

```bash
# 1. Initialize submodule
cd /Users/mats/dev/ws_f/code
git submodule update --init

# 2. Verify schema exists
ls infrastructure/external-schemas/visma/schemas/current/visma_external_api.yaml

# 3. Regenerate DTOs
bazel build //applications/accounting_visma/visma_client_lib:regenerate_models

# 4. Verify it worked
echo "✅ If no errors above, integration is successful!"
```

---

## Using the Schema Repository

### Check for Updates (Automatic)
- Runs every Monday at 00:00 UTC
- Creates PR if changes detected
- You review and merge

### Manual Update
```bash
cd infrastructure/external-schemas/visma
./scripts/fetch-latest-schema.sh
```

### View Changes
```bash
cd infrastructure/external-schemas/visma
cat SCHEMA_CHANGELOG.md
```

---

## 📋 Checklist

- [ ] Create GitHub repo `visma-external-api-schemas`
- [ ] Push local repository to GitHub
- [ ] Add as submodule to main repo
- [ ] Create `infrastructure/external-schemas/visma/BUILD.bazel`
- [ ] Update `applications/accounting_visma/visma_client_lib/BUILD.bazel`
- [ ] Test with `bazel build //applications/accounting_visma/visma_client_lib:regenerate_models`
- [ ] Commit everything to main repo
- [ ] Done! 🎉

---

## Commands Reference

```bash
# View what changed in schema
cd infrastructure/external-schemas/visma
git log --oneline

# Fetch latest (if VISMA_SCHEMA_URL configured)
./scripts/fetch-latest-schema.sh

# Update main repo with latest schema
cd /Users/mats/dev/ws_f/code
git submodule update --remote infrastructure/external-schemas/visma

# Regenerate DTOs after schema update
bazel build //applications/accounting_visma/visma_client_lib:regenerate_models
```

---

## 📞 See Also

- `SETUP_COMPLETE.md` - What's been created
- `README.md` - Repository documentation
- `/Users/mats/dev/ws_f/code/infrastructure/SCHEMA_SETUP_GUIDE.md` - Detailed setup

---

**Next:** Push to GitHub and run through the checklist! 🚀
