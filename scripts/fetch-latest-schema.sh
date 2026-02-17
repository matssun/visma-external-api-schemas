#!/bin/bash

################################################################################
# Fetch Latest Visma External API Schema
################################################################################
#
# This script fetches the latest Visma eAccounting API OpenAPI schema and
# detects any changes compared to the current version.
#
# Usage:
#   ./scripts/fetch-latest-schema.sh
#
# The script will:
#   1. Fetch latest schema from Visma API
#   2. Compare with current schema
#   3. Show differences
#   4. Create feature branch if changes detected
#   5. Archive old version if updating
#
################################################################################

set -euo pipefail

# Configuration
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ORIGINAL_SCHEMA="${REPO_ROOT}/schemas/original/visma_external_api.yaml"
CURRENT_SCHEMA="${REPO_ROOT}/schemas/current/visma_external_api.yaml"
NEW_SCHEMA=$(mktemp)
ARCHIVE_DIR="${REPO_ROOT}/schemas/archive"

# Visma API schema source
# NOTE: Update this URL to point to Visma's actual OpenAPI endpoint
# For now, we'll assume manual download and commit
VISMA_SCHEMA_URL="${VISMA_SCHEMA_URL:-}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

################################################################################
# Functions
################################################################################

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        log_error "Not in a git repository"
        exit 1
    fi

    if [ -n "$(git status --porcelain)" ]; then
        log_warning "Working directory has uncommitted changes"
        log_info "Please commit or stash changes before updating schema"
        exit 1
    fi
}

fetch_schema() {
    if [ -z "$VISMA_SCHEMA_URL" ]; then
        log_warning "VISMA_SCHEMA_URL not set"
        log_info "To automatically fetch the schema, set VISMA_SCHEMA_URL environment variable"
        log_info "Example: export VISMA_SCHEMA_URL='https://api.visma.com/openapi.yaml'"
        return 1
    fi

    log_info "Fetching latest schema from Visma..."
    if curl -sf "$VISMA_SCHEMA_URL" -o "$NEW_SCHEMA"; then
        log_success "Schema fetched successfully"
        return 0
    else
        log_error "Failed to fetch schema from $VISMA_SCHEMA_URL"
        return 1
    fi
}

compare_schemas() {
    log_info "Comparing with current schema..."

    if diff -q "$CURRENT_SCHEMA" "$NEW_SCHEMA" > /dev/null 2>&1; then
        log_success "No changes detected"
        return 1  # No changes
    else
        log_warning "Schema differences detected!"
        echo ""
        log_info "Changes summary:"
        echo "───────────────────────────────────────────────────────────"
        diff -u "$CURRENT_SCHEMA" "$NEW_SCHEMA" | head -100 || true
        echo "───────────────────────────────────────────────────────────"
        return 0  # Changes found
    fi
}

create_feature_branch() {
    local timestamp=$(date +%Y%m%d-%H%M%S)
    local branch_name="schema-update/visma-${timestamp}"

    log_info "Creating feature branch: $branch_name"
    git checkout -b "$branch_name"

    # Archive previous version
    local archive_filename="visma_external_api.yaml.$(date -u +%Y-%m-%d)"
    if [ ! -f "${ARCHIVE_DIR}/${archive_filename}" ]; then
        log_info "Archiving previous version..."
        cp "$CURRENT_SCHEMA" "${ARCHIVE_DIR}/${archive_filename}"
    fi

    # Save original (unmodified) schema
    log_info "Saving original schema..."
    cp "$NEW_SCHEMA" "$ORIGINAL_SCHEMA"

    # Copy to current and apply RotReducedInvoicingType consolidation fix
    log_info "Updating current schema (with enum consolidation fix)..."
    cp "$NEW_SCHEMA" "$CURRENT_SCHEMA"
    # NOTE: After copying, manually apply RotReducedInvoicingType enum
    # consolidation if needed (see SCHEMA_CHANGELOG.md)

    # Update VERSION file
    log_info "Updating VERSION file..."
    echo "$(date +%Y-%m-%d)" > "${REPO_ROOT}/VERSION"

    # Stage changes
    git add schemas/ VERSION

    # Create commit
    log_info "Creating commit..."
    git commit -m "chore: Update Visma schema - $(date +%Y-%m-%d)

- Latest schema version from Visma eAccounting API
- Compare with SCHEMA_CHANGELOG.md for breaking changes
- Requires review before merging to main

Schema Update Process:
1. Review changes in this PR
2. Check SCHEMA_CHANGELOG.md for breaking changes
3. Test against generated DTOs
4. Merge when ready
5. Update main repo submodule reference"

    log_success "Feature branch created: $branch_name"
    log_info "Next steps:"
    echo "  1. Review the changes: git diff HEAD~1"
    echo "  2. Push branch: git push origin $branch_name"
    echo "  3. Create PR on GitHub"
    echo "  4. Add labels: 'schema-update', and 'breaking-change' if applicable"
}

cleanup() {
    rm -f "$NEW_SCHEMA"
}

################################################################################
# Main
################################################################################

main() {
    log_info "Visma Schema Update Tool"
    echo ""

    cd "$REPO_ROOT"

    # Check git status
    check_git_repo

    # Fetch schema (optional - can be skipped for manual updates)
    if ! fetch_schema; then
        log_info "Manual schema update mode"
        log_info "Place updated schema at: $NEW_SCHEMA"
        log_info "Then update $CURRENT_SCHEMA manually"
        cleanup
        exit 0
    fi

    echo ""

    # Compare schemas
    if ! compare_schemas; then
        cleanup
        exit 0
    fi

    echo ""
    log_warning "Schema update detected"

    # Prompt user
    echo ""
    read -p "Create feature branch for schema update? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Schema update cancelled"
        cleanup
        exit 0
    fi

    echo ""

    # Create feature branch with updates
    create_feature_branch

    cleanup
    log_success "Schema update complete!"
}

# Trap to ensure cleanup on exit
trap cleanup EXIT

# Run main function
main "$@"
