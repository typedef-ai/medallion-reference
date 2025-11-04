# Justfile for medallion-reference dbt project
# Project is defined in this repo
PROJECT_NAME := "medallion_reference"
PROJECT_DIR := source_directory()
# Source data model is decoupled from the project and this repo
# Need GITHUB_DBT_PROJECT_LOCAL_PATH and GITHUB_DBT_PROJECT_REPO_NAME to be set in the environment
DBT_SOURCE_PARENT_PATH := `echo "${GITHUB_DBT_PROJECT_LOCAL_PATH:-}"` # If not set, default to empty string
DBT_GITHUB_REPO_NAME := `echo "${GITHUB_DBT_PROJECT_REPO_NAME:-}"`  # If not set, default to empty string
DBT_SOURCE_PATH := if DBT_GITHUB_REPO_NAME != '' {
  DBT_SOURCE_PARENT_PATH / DBT_GITHUB_REPO_NAME
} else {
  source_directory()
}
DBT_GITHUB_URL := if DBT_GITHUB_REPO_NAME != '' {
  'git@github.com:YoungVor/' + DBT_GITHUB_REPO_NAME + '.git'
} else {
  ''
}
DATA_DB := DBT_SOURCE_PATH / PROJECT_NAME + ".duckdb"
DBT_TARGET := DBT_SOURCE_PATH / "target"
CONFIG_FILE := DBT_SOURCE_PATH / "config.falkordb.yml"

# Default recipe
default:
    @just --list

# Show current configuration
config-info:
    @echo "Configuration System"
    @echo "==================="
    @echo ""
    @echo "Config file: {{CONFIG_FILE}}"
    @echo ""
    @echo "All settings are in config.yml:"
    @echo "  - lineage.backend: neo4j"
    @echo "  - data.backend: duckdb"
    @echo "  - agent.model: anthropic:claude-sonnet-4-5-20250929"
    @echo "  - population.model: google/gemini-2.5-flash-lite"
    @echo ""
    @echo "To modify settings, edit config.yml"

# ============================================================================
# Complete Workflow
# ============================================================================

# Run complete workflow: init + dbt + load
run config_file=CONFIG_FILE: dbt
    @echo ""
    @echo "🚀 Running complete workflow..."
    @just init {{config_file}}
    @just load {{config_file}}
    @echo ""
    @echo "✅ Complete workflow finished!"
    @echo ""
    @just _print-usage

# ============================================================================
# Lineage Database
# ============================================================================

# Clone dbt project from GitHub
clone config_file=CONFIG_FILE:
    @if [ "{{DBT_GITHUB_URL}}" != "" ]; then \
        echo "🔧 Cloning dbt project..."; \
        echo "cd {{DBT_SOURCE_PARENT_PATH}} && git clone {{DBT_GITHUB_URL}}"; \
        cd {{DBT_SOURCE_PARENT_PATH}} && git clone {{DBT_GITHUB_URL}}; \
        echo "✅ Dbt project cloned!"; \
    else \
        echo "❌ No dbt project to clone!"; \
        exit 1; \
    fi

# Initialize lineage database
init config_file=CONFIG_FILE:
    @echo "🗄️  Initializing lineage database..."
    cd {{PROJECT_DIR}} && uv run lineage init --config {{CONFIG_FILE}}
    @echo "✅ Lineage database initialized!"

# Load dbt metadata with full semantic analysis
load config_file=CONFIG_FILE:
    @echo "📊 Loading dbt metadata with semantic analysis..."
    cd {{PROJECT_DIR}} && uv run lineage load-dbt-full {{DBT_TARGET}} --config {{CONFIG_FILE}} --verbose
    @echo "✅ Metadata loaded!"

# ============================================================================
# dbt Workflow
# ============================================================================

# Set DBT_PROFILES_DIR for all dbt commands
export DBT_PROFILES_DIR := PROJECT_DIR

# Run complete dbt workflow (deps, seed, run, test, docs)
dbt: dbt-deps dbt-seed dbt-run dbt-test dbt-docs dbt-create-snowflake-semantic-views

dbt-debug:
    @echo "🔧 Debugging dbt environment..."
    cd {{PROJECT_DIR}} && uv run --env-file ../../.env dbt debug

# Install dbt dependencies
dbt-deps:
    @echo "🔧 Running dbt deps..."
    cd {{PROJECT_DIR}} && uv run --env-file ../../.env dbt deps

# Load seed data
dbt-seed:
    @echo "🌱 Running dbt seed..."
    cd {{PROJECT_DIR}} && uv run --env-file ../../.env dbt seed

# Run dbt models
dbt-run:
    @echo "🏗️  Running dbt run..."
    cd {{PROJECT_DIR}} && uv run --env-file ../../.env dbt run

# Run dbt models with OpenLineage instrumentation
dbt-run-ol:
    @echo "🏗️  Running dbt run with OpenLineage..."
    cd {{PROJECT_DIR}} && OPENLINEAGE_URL=http://localhost:8080/api/v1/lineage \
    OPENLINEAGE_NAMESPACE=dbt://{{PROJECT_NAME}} \
    OPENLINEAGE_DISABLED=false \
    uv run --env-file ../../.env dbt-ol run

# Run dbt tests
dbt-test:
    @echo "🧪 Running dbt test..."
    cd {{PROJECT_DIR}} && uv run --env-file ../../.env dbt test

# Generate dbt docs (creates catalog.json)
dbt-docs:
    @echo "📚 Generating dbt docs..."
    cd {{PROJECT_DIR}} && uv run --env-file ../../.env dbt docs generate

# Build specific model
dbt-build model:
    @echo "🏗️  Building {{model}}..."
    cd {{PROJECT_DIR}} && uv run --env-file ../../.env dbt run --select {{model}}

# Build model and dependents
dbt-build-plus model:
    @echo "🏗️  Building {{model}}+ (with dependents)..."
    cd {{PROJECT_DIR}} && uv run --env-file ../../.env dbt run --select {{model}}+

dbt-create-snowflake-semantic-views:
    @echo "🔧 Creating Snowflake semantic views..."
    cd {{PROJECT_DIR}} && uv run lineage create-snowflake-semantic-views {{PROJECT_DIR}}
    @echo "✅ Snowflake semantic views created!"

# ============================================================================
# CLI Agents (Command Line Testing)
# ============================================================================

# Run Data Engineering agent interactively (uses config.yml)
de-cli:
    cd {{PROJECT_DIR}} && uv run --env-file ../../.env lineage-de-cli --config {{CONFIG_FILE}} --dbt-project . -i

de-cli-verbose:
    cd {{PROJECT_DIR}} && uv run --env-file ../../.env lineage-de-cli --config {{CONFIG_FILE}} --dbt-project . -i --verbose
# ============================================================================
# Utilities
# ============================================================================

# Clean all generated artifacts
clean:
    @echo "🧹 Cleaning generated artifacts..."
    rm -rf {{PROJECT_DIR}}/target/
    rm -rf {{PROJECT_DIR}}/dbt_packages/
    rm -rf {{PROJECT_DIR}}/logs/
    rm -f {{DATA_DB}}
    rm -f {{DATA_DB}}.wal
    @echo "✅ Cleaned!"
    @echo ""
    @echo "Note: Lineage database location is defined in config.yml"
    @echo "To clean lineage data, remove the database manually"

# Install dependencies
install:
    @echo "📦 Installing dependencies..."
    uv sync
    @echo "✅ Dependencies installed!"

# Format code (if any Python scripts exist)
fmt:
    uv run ruff format . || true

# Lint code (if any Python scripts exist)
lint:
    uv run ruff check . || true

# Show project info
info:
    @echo "📁 Project: {{PROJECT_NAME}}"
    @echo "📂 Directory: {{PROJECT_DIR}}"
    @echo "📄 Config: {{CONFIG_FILE}}"
    @echo "💾 Data DB: {{DATA_DB}}"
    @echo "🎯 dbt Target: {{DBT_TARGET}}"
    @echo ""
    @just _check-status

# Internal: Check project status
_check-status:
    #!/usr/bin/env bash
    if [ -f "{{CONFIG_FILE}}" ]; then
        echo "✅ Config file exists"
    else
        echo "❌ Config file missing"
    fi
    if [ -f "{{DATA_DB}}" ]; then
        echo "✅ Data DB exists"
    else
        echo "❌ Data DB missing (run: just dbt)"
    fi
    if [ -f "{{PROJECT_DIR}}/target/manifest.json" ]; then
        echo "✅ dbt manifest exists"
    else
        echo "❌ dbt manifest missing (run: just dbt)"
    fi

# Internal: Print usage instructions
_print-usage:
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    @echo "🤖 Next steps:"
    @echo ""
    @echo "   # Start WebUI (PydanticAI orchestrator)"
    @echo "   just webui"
    @echo ""
    @echo "   # CLI Agents (fast command-line testing)"
    @echo "   just cli-analyst              # Interactive analyst"
    @echo "   just cli-engineer             # Interactive engineer"
    @echo "   just cli-quality              # Interactive quality"
    @echo ""
    @echo "   # Ask quick questions from CLI"
    @echo "   just ask-analyst 'What views are available?'"
    @echo "   just ask-engineer 'Show models in marts'"
    @echo "   just ask-quality 'Find failed runs'"
    @echo ""
    @echo "   # Legacy CLI agent (older interface)"
    @echo "   just agent"
    @echo ""
    @echo "   # Query specific model semantics"
    @echo "   just query fct_arr_reporting_monthly"
    @echo ""
    @echo "   # View configuration"
    @echo "   just config-info"
    @echo ""
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
