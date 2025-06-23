# Use Micromamba with Debian base and Python 3.11
FROM mambaorg/micromamba:2.0-debian12-slim

# Install Git (small + essential)
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Switch back to default user of the base image
USER mambauser

# Ensure Micromamba auto-activates environments
ARG MAMBA_DOCKERFILE_ACTIVATE=1

# Install Python 3.11 and project-relevant packages
RUN micromamba install -n base -y \
    python=3.11 \
    langchain langgraph crewai \
    chromadb \
    rdflib \
    scikit-learn \
    gradio \
    jupyterlab jupyterlab-lsp jupyterlab-git \
    ipywidgets nodejs \
    -c conda-forge && \
    micromamba clean --all --yes

# Install additional pip-only packages
RUN pip install --no-cache-dir \
    langchainhub \
    langchain-openai \
    python-lsp-server[all] \
    huggingface-hub \
    accelerate \
    'crewai[tools]' \
    'weaviate-client' \
    SPARQLWrapper

# Install language servers for JSON, YAML
RUN npm install -g vscode-json-languageserver-bin yaml-language-server

# Expose JupyterLab port & VSCode remote port
EXPOSE 8888 6006

# Set working directory to /workspace
WORKDIR /workspace
VOLUME ["/workspace"]

# Run JupyterLab on container start
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]