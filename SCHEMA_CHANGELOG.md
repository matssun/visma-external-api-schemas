# Visma External API Schema Changelog

All notable changes to the Visma eAccounting API schema will be documented in this file.

## Schema Versions

### Current: v1.0 (2024-02-08)

**Changes from previous version:**
- Consolidated 6 duplicate `RotReducedInvoicingType` enum definitions into single shared component
  - **Breaking Change Fix**: All inline enum definitions replaced with `$ref` to shared schema component
  - Impact: Fixes type compatibility issues in generated DTOs
  - Files affected: CustomerInvoiceApi, CustomerInvoiceDraftApi, OrderApi, QuoteApi, and others

**Date Updated:** 2024-02-08
**Source:** Visma eAccounting API v2
**Last Fetched:** 2024-02-08

---

## How to Track Updates

1. **Automatic Detection**: GitHub Actions runs weekly to detect schema changes
2. **Manual Check**: Run `./scripts/fetch-latest-schema.sh` to manually check for updates
3. **Review Process**: Schema updates create PRs for review before merging
4. **Archive**: Previous versions are archived in `schemas/archive/`

## Schema Update Process

When Visma updates their schema:

1. ✅ GitHub Action detects the change
2. ✅ Automatic PR is created with the diff
3. ✅ Team reviews for breaking changes
4. ✅ Once approved, version is bumped and merged
5. ✅ Main codebase fetches updated schema via git submodule

## Reporting Issues

If you notice schema inconsistencies or need to update manually:
- Edit `scripts/fetch-latest-schema.sh` to point to the source
- Run the script and commit changes
- Create a PR describing the update

---

## Archive

Previous schema versions and release notes can be found in `schemas/archive/`
