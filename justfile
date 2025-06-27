# Use bash and auto-load .env
set shell := ["bash", "-cu"]
set dotenv-load

# Edit this to match your container service name in docker-compose.yml
CONTAINER := 'dev'
ENV_NAME := 'base'

# Show summary by default
default:
    @just --summary

# 📊 Print environment vars
show-env:
  env | grep -E 'PROJECT_NAME|DOCKER_TAG'

# ---------------------------------------------
# 🚀 Docker
# ---------------------------------------------

# Start container via docker-compose
up:
  docker compose up -d

# Stop container
down:
  docker compose down

# Rebuild service containers (use after changing docker-compose.yaml or Dockerfile)
rebuild:
  docker compose build --no-cache

# ---------------------------------------------
# 🧪 Python Environment (inside container)
# ---------------------------------------------

# Install packages from requirements.txt
install:
  docker compose exec {{CONTAINER}} micromamba run -n {{ENV_NAME}} pip install -r requirements.txt

# Upgrade packages from requirements.txt
upgrade:
  docker compose exec {{CONTAINER}} micromamba run -n {{ENV_NAME}} pip install --upgrade --no-cache-dir -r requirements.txt

# Save current environment to requirements.txt
freeze:
  docker compose exec {{CONTAINER}} bash -c "micromamba run -n {{ENV_NAME}} pip freeze > /workspace/requirements.txt"

# Show pip-installed packages
show-pip-deps:
  docker compose exec {{CONTAINER}} micromamba run -n {{ENV_NAME}} pip list

# Show conda-installed packages
show-conda-deps:
  docker compose exec {{CONTAINER}} micromamba list -n {{ENV_NAME}}

# Show all installed packages (pip + conda)
show-deps:
  just show-conda-deps
  just show-pip-deps

# Save full environment snapshot (conda + pip)
snapshot:
  @echo "📦 Saving environment snapshot..."
  docker compose exec {{CONTAINER}} bash -c "micromamba list -n {{ENV_NAME}} > /workspace/conda-list.txt"
  docker compose exec {{CONTAINER}} bash -c "micromamba run -n {{ENV_NAME}} pip freeze > /workspace/pip-freeze.txt"
  @echo "✅ Saved to conda-list.txt and pip-freeze.txt"

# Start a Jupyter Lab server
jupyter:
  docker compose exec {{CONTAINER}} micromamba run -n {{ENV_NAME}} jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root

# Shell into the container
shell:
  docker compose exec {{CONTAINER}} bash

# ---------------------------------------------
# ℹ️ Help
# ---------------------------------------------

help:
  @echo ""
  @echo "🧰 Guild Assistant Project – Common Tasks"
  @echo "=========================================="
  @echo "  just up                  # Start the container"
  @echo "  just down                # Stop the container"
  @echo "  just rebuild             # Rebuild the container"
  @echo "  just install             # Install deps from requirements.txt"
  @echo "  just upgrade             # Upgrade deps"
  @echo "  just freeze              # Freeze deps to requirements.txt"
  @echo "  just show-pip-deps       # Show pip-installed packages"
  @echo "  just show-conda-deps     # Show conda-installed packages"
  @echo "  just show-deps           # Show all installed packages (pip + conda)"
  @echo "  just snapshot            # Save full environment snapshot"
  @echo "  just jupyter             # Start Jupyter Lab"
  @echo "  just shell               # Bash shell in dev container"
  @echo "  just show-env            # Show environment variables"
