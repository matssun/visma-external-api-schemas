# ✅ Visma Schema Repository Setup Checklist

## Phase 1: Local Setup ✅ COMPLETE

- [x] Create schema repository directory structure
- [x] Copy current OpenAPI schema (v1.0 - 2024-02-08)
- [x] Consolidate 6 duplicate `RotReducedInvoicingType` enums
- [x] Create VERSION file with current version
- [x] Create SCHEMA_CHANGELOG.md with history
- [x] Create README.md with documentation
- [x] Create fetch-latest-schema.sh automation script
- [x] Create GitHub Actions workflow (check-schema-updates.yml)
- [x] Initialize git repository
- [x] Create initial commit
- [x] Create SETUP_COMPLETE.md
- [x] Create QUICKSTART.md
- [x] Create SCHEMA_SETUP_GUIDE.md in main repo

**Status:** ✅ Ready to push to GitHub

---

## Phase 2: GitHub Integration (NEXT)

### Step 1: Create GitHub Repository
- [ ] Go to https://github.com/new
- [ ] Repository name: `visma-external-api-schemas`
- [ ] Make it **Public**
- [ ] Leave empty (no README, .gitignore, license)
- [ ] Click "Create repository"

### Step 2: Push to GitHub
- [ ] Run commands from `/Users/mats/dev/visma-external-api-schemas/QUICKSTART.md`
- [ ] Verify push succeeded: `git log --oneline`

### Step 3: Enable GitHub Actions
- [ ] Go to repository Settings
- [ ] Click "Actions"
- [ ] Allow "All actions and reusable workflows"

### Step 4: (Optional) Configure Auto-Fetching
- [ ] If Visma has public schema URL:
  - [ ] Settings > Secrets and variables > Actions
  - [ ] Create secret: `VISMA_SCHEMA_URL`
  - [ ] Value: (Visma API endpoint)

**Expected Result:** GitHub repo with automated weekly checks configured

---

## Phase 3: Main Repository Integration (THEN)

### Step 5: Add as Git Submodule
- [ ] Navigate to `/Users/mats/dev/ws_f/code`
- [ ] Run: `git submodule add https://github.com/yourorg/visma-external-api-schemas.git infrastructure/external-schemas/visma`
- [ ] Verify: `ls infrastructure/external-schemas/visma/schemas/current/`
- [ ] Commit: `git add .gitmodules infrastructure/external-schemas/visma`
- [ ] Commit: `git commit -m "add: Visma schema repository as git submodule"`

### Step 6: Create BUILD File for Schema Repo
- [ ] Create: `infrastructure/external-schemas/visma/BUILD.bazel`
- [ ] Copy content from QUICKSTART.md
- [ ] Verify file exists and is readable

### Step 7: Update Main Repo BUILD Files
- [ ] Edit: `applications/accounting_visma/visma_client_lib/BUILD.bazel`
- [ ] Update `regenerate_models` genrule:
  - [ ] Change source from local openapi path to submodule
  - [ ] Change command to use new path
- [ ] Review changes in diff

### Step 8: Test Integration
- [ ] Run: `git submodule update --init --recursive`
- [ ] Verify: `ls infrastructure/external-schemas/visma/schemas/current/visma_external_api.yaml`
- [ ] Run: `bazel build //applications/accounting_visma/visma_client_lib:regenerate_models`
- [ ] Verify: No build errors
- [ ] Verify: DTOs regenerated successfully

### Step 9: Final Commit
- [ ] Stage all changes: `git add -A`
- [ ] Commit: `git commit -m "chore: Integrate Visma schema repository as git submodule"`
- [ ] Push: `git push`

**Expected Result:** Main repo using schema from submodule, DTOs regenerate successfully

---

## Phase 4: Verification & Handoff (FINALLY)

### Step 10: Verify Complete Integration
- [ ] Clone repo in fresh location
- [ ] Run: `git submodule update --init`
- [ ] Verify schema file exists
- [ ] Run: `bazel build //applications/accounting_visma/visma_client_lib:regenerate_models`
- [ ] Verify no errors

### Step 11: Document Team Process
- [ ] Share SCHEMA_SETUP_GUIDE.md with team
- [ ] Share QUICKSTART.md for operations team
- [ ] Update team wiki/confluence if applicable
- [ ] Brief team on weekly auto-updates

### Step 12: Configure Backup Plan
- [ ] If no Visma public API:
  - [ ] Document manual update process
  - [ ] Create runbook for team
  - [ ] Test fetch-latest-schema.sh script

**Expected Result:** Team ready to manage schema updates

---

## 📊 Quick Status

| Phase | Component | Status |
|-------|-----------|--------|
| 1 | Local Repository | ✅ Complete |
| 2 | GitHub Push | ⏳ Next |
| 2 | GitHub Actions | ⏳ After push |
| 3 | Git Submodule | ⏳ After GitHub |
| 3 | BUILD Files | ⏳ After submodule |
| 3 | Integration Test | ⏳ After BUILD |
| 4 | Team Documentation | ⏳ Final |

---

## 📍 Key Locations

**Schema Repository:**
```
Local:   /Users/mats/dev/visma-external-api-schemas/
GitHub:  https://github.com/yourorg/visma-external-api-schemas
```

**Integration Points:**
```
Main Repo: /Users/mats/dev/ws_f/code/
├── infrastructure/external-schemas/visma/          ← Git submodule
├── infrastructure/SCHEMA_SETUP_GUIDE.md            ← Setup guide
└── applications/accounting_visma/visma_client_lib/ ← Uses schema
```

---

## 📚 Documentation

| Document | Location | Purpose |
|----------|----------|---------|
| QUICKSTART.md | Schema repo | 5-min setup guide |
| SETUP_COMPLETE.md | Schema repo | What was created |
| README.md | Schema repo | Repository overview |
| SCHEMA_SETUP_GUIDE.md | Main repo | Detailed integration |
| SCHEMA_CHANGELOG.md | Schema repo | Change history |

---

## 🎯 Success Criteria

✅ **Phase 1 Complete When:**
- [x] Schema repo directory exists with all files
- [x] Git repository initialized with initial commit
- [x] Documentation complete and reviewed

✅ **Phase 2 Complete When:**
- [ ] Schema pushed to GitHub
- [ ] GitHub Actions enabled
- [ ] Can view repo on GitHub
- [ ] Commits visible in GitHub

✅ **Phase 3 Complete When:**
- [ ] Submodule added to main repo
- [ ] Build files updated
- [ ] DTOs regenerate without errors
- [ ] All changes committed and pushed

✅ **Phase 4 Complete When:**
- [ ] Fresh clone can regenerate DTOs
- [ ] Team documentation completed
- [ ] Team briefed on process
- [ ] Manual update script tested

---

## 🚀 Ready to Start?

1. Start with Phase 2, Step 1: Create GitHub repository
2. Follow QUICKSTART.md for exact commands
3. Check off each item as completed
4. Ask for help if stuck on any step

**Estimated Total Time:** 30 minutes for all phases

---

**Last Updated:** 2024-02-08
**Setup Status:** ✅ Phase 1 Complete, Ready for Phase 2
