# Use bash and auto-load .env
set shell := ["bash", "-cu"]
set dotenv-load

# Edit this to match your container service name in docker-compose.yml
CONTAINER := env_var("CONTAINER_NAME")
PY_ENV_NAME := 'base'

# Show summary by default
default:
        @just --summary

# -------------------------------------------
# Environment
# -------------------------------------------

# 📊 Print environment vars
show-env:
    @env | grep -E 'PROJECT_NAME|DOCKER_TAG|CONTAINER_NAME|PY_ENV_NAME'

# Justfile for guild-assistant

# Copy .env.example to .env if .env does not exist
init-env:
        @if [ ! -f .env ]; then cp .env.example .env && echo ".env initialized from .env.example"; else echo ".env already exists"; fi

# -------------------------------------------
# 🚀 Docker
# -------------------------------------------

# Start container via docker-compose
up:
    docker compose up -d

# Stop container
down:
    docker compose down

status:
    docker compose ps

# Rebuild service containers (use after changing docker-compose.yaml or Dockerfile)
rebuild:
    docker compose build --no-cache

# ---------------------------------------------
# 🧪 Python Environment (inside container)
# ---------------------------------------------

# Install packages from requirements.txt
install:
    @docker compose exec {{CONTAINER}} micromamba run -n {{PY_ENV_NAME}} pip install -r requirements.txt

# Upgrade packages from requirements.txt
upgrade:
   @docker compose exec {{CONTAINER}} micromamba run -n {{PY_ENV_NAME}} pip install --upgrade --no-cache-dir -r requirements.txt

# Save current environment to requirements.txt
freeze:
    @docker compose exec {{CONTAINER}} bash -c "micromamba run -n {{PY_ENV_NAME}} pip list --format=freeze > /workspace/requirements.txt"

# Show pip-installed packages
show-pip-deps:
    @docker compose exec {{CONTAINER}} micromamba run -n {{PY_ENV_NAME}} pip list

# Show conda-installed packages
show-conda-deps:
    @docker compose exec {{CONTAINER}} micromamba list -n {{PY_ENV_NAME}}

# Show all installed packages (pip + conda)
show-deps:
    @just show-conda-deps
    @just show-pip-deps

# Save full environment snapshot (conda + pip)
snapshot:
    @echo "📦 Saving environment snapshot..."
    @docker compose exec {{CONTAINER}} bash -c "micromamba list -n {{PY_ENV_NAME}} > /workspace/conda-list.txt"
    @docker compose exec {{CONTAINER}} bash -c "micromamba run -n {{PY_ENV_NAME}} pip freeze > /workspace/pip-freeze.txt"
    @echo "✅ Saved to conda-list.txt and pip-freeze.txt"

# Start a Jupyter Lab server
jupyter:
    @docker compose exec {{CONTAINER}} micromamba run -n {{PY_ENV_NAME}} jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root

# Shell into the container
shell:
    @docker compose exec {{CONTAINER}} bash

# Run a command in the dev container
exec-in-dev CMD:
    @docker compose exec {{CONTAINER}} bash -ic '{{CMD}}'
        
# ---------------------------------------------
# Dev Helper Tasks
# ---------------------------------------------

# Scaffold multiple directories with __init__.py and README.md"
scaffold *dirs:
    @for dir in {{dirs}}; do \
        mkdir -p "$dir" && \
        touch "$dir/__init__.py" && \
        [ -f "$dir/README.md" ] || echo "# $dir" > "$dir/README.md"; \
    done

# ==========================================
# 🧪 Linting, Formatting, Testing, Running
# ==========================================

# Lint code with ruff
lint:
	@just exec-in-dev "ruff check /workspace/src /workspace/tests"

# Auto-fix code style issues
format:
	@just exec-in-dev "ruff format /workspace/src /workspace/tests"

# Run tests using pytest
test:
    @docker compose exec {{CONTAINER}} bash -ic "PYTHONPATH=src pytest tests" || if [ $? -ne 5 ]; then echo "No Tests to run!"; exit 0; fi

# -------------------------------------------
# ℹ️ Help
# ---------------------------------------------

help:
    @echo ""
    @echo "🧰 Guild Assistant Project – Common Tasks"
    @echo "=========================================="
    @echo "  just up                  # Start the container"
    @echo "  just down                # Stop the container"
    @echo "  just status              # Show container status"
    @echo "  just rebuild             # Rebuild the container"
    @echo "  just freeze              # Freeze deps to requirements.txt"
    @echo "  just install             # Install deps from requirements.txt"
    @echo "  just upgrade             # Upgrade deps from requirements.txt"
    @echo "  just show-pip-deps       # Show pip-installed packages"
    @echo "  just show-conda-deps     # Show conda-installed packages"
    @echo "  just show-deps           # Show all installed packages (pip + conda)"
    @echo "  just snapshot            # Save full environment snapshot"
    @echo "  just jupyter             # Start Jupyter Lab"
    @echo "  just shell               # Bash shell in dev container"
    @echo "  just exec-in-dev CMD     # Run a command in the dev container"
    @echo "  just show-env            # Show environment variables"
    @echo "  just init-env            # Initialize .env from .env.example"
    @echo "  just scaffold *dirs      # Scaffold multiple directories with __init__.py and README.md"
    @echo "  just lint                # Lint code with ruff"
    @echo "  just format              # Auto-fix code style issues"
    @echo "  just test                # Run tests using pytest"
    @echo "  just help                # Show this help"
    