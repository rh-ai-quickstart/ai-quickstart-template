# Red Hat AI Quickstart Architecture

## Table of Contents

- [Overview](#overview)
- [What is a Red Hat AI Quickstart?](#what-is-a-red-hat-ai-quickstart)
- [Why AI Quickstarts?](#why-ai-quickstarts)
- [Core Goals](#core-goals)
- [Target Audience](#target-audience)
- [Red Hat OpenShift AI Platform](#red-hat-openshift-ai-platform)
- [Quickstart Architecture](#quickstart-architecture)
  - [Common Components](#common-components)
  - [Reference Architecture Diagram](#reference-architecture-diagram)
  - [AI Architecture Helm Charts](#ai-architecture-helm-charts)
  - [Deployment Patterns](#deployment-patterns)
- [How to Create a Quickstart](#how-to-create-a-quickstart)
  - [Getting Started](#getting-started)
  - [Repository Structure](#repository-structure)
  - [Building Your Helm Chart](#building-your-helm-chart)
  - [Model Deployment Options](#model-deployment-options)
  - [Contribution Guidelines](#contribution-guidelines)
- [Testing Best Practices](#testing-best-practices)
  - [Testing Strategy](#testing-strategy)
  - [Unit Tests](#unit-tests)
  - [Integration Tests](#integration-tests)
  - [LLM Evaluation Framework](#llm-evaluation-framework)
  - [Helm Chart Validation](#helm-chart-validation)
- [Code Quality](#code-quality)
  - [Linting](#linting)
  - [Formatting](#formatting)
  - [Type Checking](#type-checking)
  - [Custom Code Quality Rules](#custom-code-quality-rules)
- [Git Workflow and Configuration](#git-workflow-and-configuration)
  - [Branch Strategy](#branch-strategy)
  - [Version Management](#version-management)
  - [Dependency Management](#dependency-management)
  - [Container Build Patterns](#container-build-patterns)
- [GitHub Actions CI/CD](#github-actions-cicd)
  - [PR Quality Checks](#pr-quality-checks)
  - [PR Integration and E2E Tests](#pr-integration-and-e2e-tests)
  - [PR Evaluation Check](#pr-evaluation-check)
  - [PR Build Test](#pr-build-test)
  - [PR Branch Enforcement](#pr-branch-enforcement)
  - [Build and Push Images](#build-and-push-images)
  - [Nightly E2E Tests](#nightly-e2e-tests)
  - [Promotion and Version Bump](#promotion-and-version-bump)
  - [Custom GitHub Actions](#custom-github-actions)
- [Key Technology Components](#key-technology-components)
- [Community and Ecosystem](#community-and-ecosystem)
- [References](#references)

---

## Overview

Red Hat AI Quickstarts are **ready-to-run AI applications** that demonstrate real-world AI use cases deployed on [Red Hat OpenShift AI](https://www.redhat.com/en/technologies/cloud-computing/openshift/openshift-ai). Each quickstart is a complete, deployable solution — not just documentation or a reference architecture — that users can deploy into their own environment with a single `helm install` command.

Discover real-world AI use cases. Deploy them in your own environment with Red Hat AI.

AI Quickstarts go beyond traditional reference architectures by providing **deployable, testable, and reproducible software artifacts** with automated deployment. Where a reference architecture gives you a conceptual framework, a quickstart gives you running code.

---

## What is a Red Hat AI Quickstart?

A Red Hat AI Quickstart is a self-contained, production-oriented AI application that:

- **Solves a real-world business problem** using AI — such as enterprise knowledge retrieval, IT process automation, safety compliance monitoring, or financial fraud detection.
- **Runs on Red Hat OpenShift AI**, leveraging platform capabilities like model serving (vLLM/KServe), data science pipelines, workbenches, and model registry.
- **Deploys via Helm** — a single chart that brings up the full stack including AI models, vector databases, storage, backend services, and frontend UIs.
- **Uses reusable infrastructure components** from the shared [AI Architecture Charts](https://github.com/rh-ai-quickstart/ai-architecture-charts) library, ensuring consistency and reducing duplication across quickstarts.
- **Is open-source** (MIT licensed) and designed for community contribution.

AI Quickstarts are curated, end-to-end solutions that bridge the gap between AI experimentation and production deployment.

| Concept | What It Is | What It Is Not |
|---------|-----------|----------------|
| **Reference Architecture** | A conceptual framework with diagrams and documentation | Runnable code or automated deployment |
| **AI Quickstart** | A deployable AI application solving a real use case | A toy demo, tutorial, or proof-of-concept |

---

## Why AI Quickstarts?

Organizations face several challenges when moving AI projects from experimentation to production:

| Challenge | How Quickstarts Help |
|-----------|---------------------|
| **Complexity** | Pre-integrated stack reduces the effort of connecting models, databases, pipelines, and UIs |
| **Deployment friction** | Single `helm install` deploys the entire application on OpenShift AI |
| **Inconsistency** | Shared architecture charts enforce consistent patterns across solutions |
| **Time to value** | Deploy a working AI application in minutes, not weeks |
| **Skills gap** | Learn by exploring a real, working application rather than reading documentation |
| **Maintenance burden** | Versioned Helm charts with CI/CD keep components up-to-date |

### Advantages Over Traditional Reference Architectures

1. **Deployable Artifacts** — Every quickstart is a working application, not a document that requires manual assembly.
2. **Consistency and Repeatability** — Helm charts provide a single, version-controlled source of truth. Deploy the same stack identically across development, staging, and production.
3. **Reduced Time to Value** — Go from zero to a running AI application in minutes with `helm install`.
4. **Modular Design** — Components from the shared chart library (LLM Service, PGVector, MinIO, etc.) can be composed, substituted, or removed to match your needs.
5. **Continuous Maintenance** — Per-component semantic versioning with CI/CD pipelines ensures charts stay current as dependencies evolve.

---

## Core Goals

- **Demonstrate real-world AI** — Each quickstart addresses an industry-relevant use case with practical business value.
- **Lower the barrier to adoption** — Enable teams to deploy production-grade AI applications without deep platform expertise.
- **Showcase OpenShift AI capabilities** — Demonstrate model serving, pipelines, workbenches, model registry, and other platform features in context.
- **Build a reusable foundation** — Shared architecture charts provide composable building blocks that accelerate new quickstart development.
- **Foster community** — Open-source contributions expand the catalog with diverse use cases and industry perspectives.

---

## Target Audience

AI Quickstarts are designed for:

- **AI/ML Engineers** building AI-powered applications and looking for production deployment patterns on OpenShift.
- **Solution Architects** evaluating how Red Hat OpenShift AI can address specific business requirements.
- **Platform Engineers** responsible for deploying and operating AI workloads on OpenShift clusters.
- **ISV and Partner Teams** building AI solutions on the Red Hat platform and wanting a standardized framework.
- **Developers** exploring AI application development with LLMs, RAG, agents, and MCP servers.

### Prerequisites

Users should be familiar with:

- Kubernetes / OpenShift fundamentals
- Helm chart deployment
- Basic AI/ML concepts (LLMs, embeddings, vector search)

---

## Red Hat OpenShift AI Platform

AI Quickstarts are built on **Red Hat OpenShift AI**, which provides a comprehensive set of features for the full AI/ML lifecycle:

### Platform Features Leveraged by Quickstarts

| Feature | Description | How Quickstarts Use It |
|---------|-------------|----------------------|
| **Model Serving** | Serve models at scale using KServe and vLLM runtime | Deploy LLMs (Llama 3, Mistral, etc.) with OpenAI-compatible APIs |
| **Data Science Pipelines** | Build and automate ML workflows using Kubeflow Pipelines | Document ingestion, embedding generation, data processing |
| **Workbenches** | Jupyter notebook environments for development and experimentation | RAG configuration, pipeline setup, model evaluation |
| **Model Registry** | Catalog, version, and manage AI models | Track deployed models across quickstart environments |
| **Data Science Projects** | Organize resources, notebooks, and deployments | Namespace-level isolation for quickstart components |
| **Distributed Workloads** | Scale training and inference across multiple nodes | Large model training and batch processing |
| **Model Monitoring** | Track model performance, drift, and bias | Production observability for deployed models |
| **GPU Acceleration** | NVIDIA GPU and Intel Gaudi HPU support | Hardware-accelerated inference for LLMs |

For the complete platform documentation, see [Red Hat OpenShift AI Documentation](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4).

---

## Quickstart Architecture

### Common Components

A typical AI Quickstart is composed of the following layers:

```
┌─────────────────────────────────────────────────────────────────────┐
│                         User Interface                              │
│              (React/Tailwind CSS, Streamlit, Gradio)                │
├─────────────────────────────────────────────────────────────────────┤
│                      Application Backend                            │
│                   (FastAPI, Flask, Express)                          │
├──────────────┬──────────────┬──────────────┬────────────────────────┤
│  AI/Agent    │  Integration │   Safety &   │     Observability      │
│  Framework   │   Layer      │  Guardrails  │                        │
│ (LlamaStack, │ (MCP Servers,│ (Llama Guard,│  (OpenTelemetry,       │
│  LangGraph)  │  Webhooks)   │  PromptGuard)│   Langfuse, Jaeger)    │
├──────────────┴──────────────┴──────────────┴────────────────────────┤
│                       Model Serving Layer                           │
│         (vLLM on KServe / Remote MaaS Endpoint)                     │
├──────────────┬──────────────┬──────────────┬────────────────────────┤
│  Vector DB   │   Object     │  Relational  │   Document             │
│  (PGVector,  │   Storage    │  Database    │   Ingestion            │
│  Oracle 23ai)│  (MinIO/S3)  │ (PostgreSQL) │   Pipeline             │
├──────────────┴──────────────┴──────────────┴────────────────────────┤
│                    Red Hat OpenShift AI                              │
│     (KServe, Pipelines, Workbenches, Model Registry, GPUs)          │
├─────────────────────────────────────────────────────────────────────┤
│                    Red Hat OpenShift Container Platform              │
└─────────────────────────────────────────────────────────────────────┘
```

#### Component Descriptions

| Component | Purpose | Common Technologies |
|-----------|---------|-------------------|
| **Frontend** | User-facing interface for interacting with the AI application | React with Tailwind CSS, Streamlit, Gradio |
| **Backend** | Business logic, API endpoints, session management | FastAPI, Flask |
| **AI/Agent Framework** | Orchestrates LLM interactions, tool calling, and agent workflows | LlamaStack, LangGraph |
| **Model Server** | Serves AI models with high-performance inference | vLLM on KServe (OpenShift AI), or remote MaaS endpoints |
| **Vector Database** | Stores embeddings for semantic search (RAG) | PostgreSQL + PGVector, Oracle 23ai |
| **Object Storage** | Stores documents, model artifacts, and pipeline data | MinIO (S3-compatible) |
| **Ingestion Pipeline** | Processes documents: chunking, embedding, and storage | Custom pipelines, Kubeflow Pipelines |
| **MCP Servers** | Model Context Protocol servers for AI agent tool integration | Custom MCP servers (weather, databases, ServiceNow, etc.) |
| **Safety & Guardrails** | Content filtering, prompt injection protection | Llama Guard, PromptGuard |
| **Observability** | Distributed tracing, metrics, and monitoring | OpenTelemetry, Jaeger, Langfuse |

### Reference Architecture Diagram

```
                    ┌──────────┐
                    │   User   │
                    └────┬─────┘
                         │
           ┌─────────────┼─────────────┐
           │             │             │
      ┌────▼───┐   ┌─────▼────┐  ┌────▼────┐
      │  Web   │   │  Slack   │  │  Email  │
      │  UI    │   │  Bot     │  │  Client │
      └────┬───┘   └─────┬────┘  └────┬────┘
           │             │             │
           └─────────────┼─────────────┘
                         │
                  ┌──────▼──────┐
                  │   Backend   │
                  │   (FastAPI) │
                  └──────┬──────┘
                         │
              ┌──────────┼──────────┐
              │          │          │
       ┌──────▼──┐  ┌────▼────┐  ┌─▼──────────┐
       │  Llama  │  │  MCP    │  │  Safety     │
       │  Stack  │  │ Servers │  │  Shields    │
       └────┬────┘  └────┬────┘  └─────────────┘
            │             │
     ┌──────┼──────┐      │
     │      │      │      │
  ┌──▼──┐ ┌─▼───┐ ┌▼─────────┐
  │vLLM │ │ RAG │ │ External  │
  │Model│ │Store│ │ Systems   │
  │Serve│ │     │ │(ServiceNow│
  └─────┘ └──┬──┘ │ DB, APIs) │
              │    └──────────┘
        ┌─────┼─────┐
        │     │     │
    ┌───▼─┐ ┌▼────┐│
    │PG   │ │MinIO││
    │Vect.│ │ S3  ││
    └─────┘ └─────┘│
                    │
        ┌───────────▼───────────┐
        │   OpenShift AI        │
        │  (KServe, Pipelines,  │
        │   Workbenches, GPUs)  │
        └───────────────────────┘
```

### AI Architecture Helm Charts

The [AI Architecture Charts](https://github.com/rh-ai-quickstart/ai-architecture-charts) repository provides a shared library of reusable Helm charts that quickstarts compose to build their infrastructure. These charts are the building blocks of the quickstart ecosystem.

| Chart | Description | Key Features |
|-------|-------------|-------------|
| **[LLM Service](https://github.com/rh-ai-quickstart/ai-architecture-charts/tree/main/llm-service)** | High-performance model serving using vLLM on OpenShift AI/KServe | OpenAI-compatible API, GPU/CPU modes, tool calling support |
| **[LlamaStack](https://github.com/rh-ai-quickstart/ai-architecture-charts/tree/main/llama-stack)** | AI orchestration platform with unified API | Agent capabilities, safety shields, multi-provider support, automatic model discovery |
| **[PGVector](https://github.com/rh-ai-quickstart/ai-architecture-charts/tree/main/pgvector)** | PostgreSQL with pgvector extension for vector similarity search | Cosine/L2/inner product metrics, IVFFlat and HNSW indexes, ACID compliance |
| **[MinIO](https://github.com/rh-ai-quickstart/ai-architecture-charts/tree/main/minio)** | S3-compatible object storage | Web console, bucket policies, lifecycle management, sample file upload |
| **[Ingestion Pipeline](https://github.com/rh-ai-quickstart/ai-architecture-charts/tree/main/ingestion-pipeline)** | Document processing pipeline | S3/GitHub/URL sources, chunking, embedding generation, vector DB storage |
| **[Configure Pipeline](https://github.com/rh-ai-quickstart/ai-architecture-charts/tree/main/configure-pipeline)** | Jupyter notebook environment for RAG configuration | MinIO integration, template management |
| **[MCP Servers](https://github.com/rh-ai-quickstart/ai-architecture-charts/tree/main/mcp-servers)** | Model Context Protocol servers for agent tool integration | Weather services, SSE endpoints, custom tool framework |
| **[Oracle 23ai](https://github.com/rh-ai-quickstart/ai-architecture-charts/tree/main/oracle-db)** | Oracle Database with native AI vector features | TPC-DS data population, 25 synthetic test tables |
| **[Model Registry](https://github.com/rh-ai-quickstart/ai-architecture-charts/tree/main/model-registry)** | Model catalog and version management | Integration with OpenShift AI Model Registry |

#### Using Architecture Charts as Dependencies

Quickstarts reference these shared charts as Helm dependencies in their `Chart.yaml`:

```yaml
apiVersion: v2
name: my-quickstart
version: 0.1.0
dependencies:
  - name: llm-service
    version: "0.2.x"
    repository: "https://rh-ai-quickstart.github.io/ai-architecture-charts"
  - name: pgvector
    version: "0.1.x"
    repository: "https://rh-ai-quickstart.github.io/ai-architecture-charts"
  - name: minio
    version: "0.1.x"
    repository: "https://rh-ai-quickstart.github.io/ai-architecture-charts"
```

For local development, you can reference charts from a local clone:

```yaml
dependencies:
  - name: llm-service
    version: "0.2.x"
    repository: "file://../ai-architecture-charts/llm-service/helm"
```

#### Global Values

Shared configuration can be passed across subcharts using global values:

```yaml
global:
  models:
    - name: llama-3-2-3b-instruct
      url: "https://huggingface.co/meta-llama/Llama-3.2-3B-Instruct"
```

### Deployment Patterns

#### Basic RAG Application

Deploy components in this order: **PGVector -> MinIO -> LLM Service -> LlamaStack -> Ingestion Pipeline**

```bash
helm install my-rag-app ./chart --namespace my-project \
  --set global.models[0].name=llama-3-2-3b-instruct
```

#### Agent-based Application

Deploy components: **PGVector -> MinIO -> LLM Service -> LlamaStack -> MCP Servers -> Backend -> Frontend**

#### MaaS (Model as a Service)

Skip local model deployment by pointing to a remote endpoint:

```bash
helm install my-app ./chart --namespace my-project \
  --set model.name=my-model \
  --set model.endpoint=https://my-maas-instance:443 \
  --set model.api_key=my-api-key
```

---

## How to Create a Quickstart

### Getting Started

1. **Use the template repository** — Go to the [AI Quickstart Template](https://github.com/rh-ai-quickstart/ai-quickstart-template) on GitHub and click **"Use this template" -> "Create a new repository"**. This creates a new repository under your GitHub organization with the full template structure — including the Helm chart scaffold, README template, CI/CD workflows, and contribution guidelines — already in place.

   ![Use this template](https://docs.github.com/assets/cb-76823/mw-1440/images/help/repository/use-this-template-button.webp)

2. **Scaffold your application with the CLI** — Use the [AI QuickStart CLI](https://github.com/rh-ai-quickstart/quickstart-cli) to generate a production-ready sample app with React, FastAPI, and optional database support:

   ```bash
   npm install -g @rh-ai-quickstart/cli
   quickstart create my-app --packages api,ui,db
   ```

   The CLI scaffolds a full-stack monorepo with React + Tailwind CSS frontend, FastAPI backend, PostgreSQL database, developer tooling (commitlint, Husky, Storybook), and testing infrastructure — ready to build on.

3. **Define your use case** — Identify a real-world AI problem in a specific industry (healthcare, finance, retail, manufacturing, IT operations, etc.).

4. **Select your components** — Choose which architecture charts your quickstart needs from the [shared chart library](#ai-architecture-helm-charts).

5. **Build your application** — Implement the frontend, backend, and any custom logic specific to your use case.

6. **Package as a Helm chart** — Wire everything together in a single Helm chart that deploys the complete stack.

7. **Document thoroughly** — Follow the README template structure so users can understand, deploy, and extend your quickstart.

### Repository Structure

Every quickstart follows a consistent repository layout:

```
my-quickstart/
├── chart/                          # Helm chart for deployment
│   ├── Chart.yaml                  # Chart metadata and dependencies
│   ├── values.yaml                 # Default configuration values
│   └── templates/                  # Kubernetes resource templates
│       ├── deployment.yaml         # Application deployment
│       ├── service.yaml            # Service definitions
│       ├── route.yaml              # OpenShift routes
│       ├── configmap.yaml          # Configuration
│       ├── secret.yaml             # Secrets (if needed)
│       └── test-model-access.yaml  # Helm test for model connectivity
├── frontend/                       # React frontend (Tailwind CSS)
│   ├── src/                        # React components and pages
│   ├── package.json                # Node.js dependencies
│   ├── tailwind.config.js          # Tailwind CSS configuration
│   ├── Containerfile               # Container build file
│   └── tsconfig.json               # TypeScript configuration
├── backend/                        # FastAPI backend service
│   ├── src/                        # Application code
│   ├── Containerfile               # Container build file
│   └── requirements.txt            # Python dependencies (FastAPI, uvicorn, etc.)
├── mcp_servers/                    # Custom MCP servers (if needed)
├── docs/
│   └── images/                     # Architecture diagrams and screenshots
│       └── architecture-overview.png
├── .github/
│   ├── CODEOWNERS                  # Repository code owners
│   └── pull_request_template.md    # PR template
├── LICENSE                         # MIT license
└── README.md                       # Quickstart documentation
```

### Building Your Helm Chart

Your Helm chart is the heart of the quickstart. It should:

1. **Declare dependencies** on shared architecture charts in `Chart.yaml` with condition flags.
2. **Expose model configuration** through `global.models` in `values.yaml` — supporting both local and remote models.
3. **Use a Makefile** to orchestrate installation with command-line overrides for model selection, device type, and tolerations.
4. **Include a Helm test** (`test-model-access.yaml`) to validate model connectivity.
5. **Use OpenShift Routes** for exposing the UI to users.

#### Chart.yaml with Dependencies

Declare dependencies on the shared architecture charts, each gated by a condition flag:

```yaml
apiVersion: v2
name: my-quickstart
description: A Helm chart for deploying an AI quickstart on OpenShift AI
type: application
version: 0.1.0
appVersion: "0.1.0"

dependencies:
  - name: pgvector
    version: 0.5.5
    repository: https://rh-ai-quickstart.github.io/ai-architecture-charts
    condition: pgvector.enabled
  - name: llm-service
    version: 0.5.9
    repository: https://rh-ai-quickstart.github.io/ai-architecture-charts
    condition: llm-service.enabled
  - name: llama-stack
    version: 0.8.6
    repository: https://rh-ai-quickstart.github.io/ai-architecture-charts
    condition: llama-stack.enabled
  - name: ingestion-pipeline
    version: 0.7.4
    repository: https://rh-ai-quickstart.github.io/ai-architecture-charts
    condition: ingestion-pipeline.enabled
  - name: configure-pipeline
    version: 0.5.8
    repository: https://rh-ai-quickstart.github.io/ai-architecture-charts
    condition: configure-pipeline.enabled
  - name: mcp-servers
    version: 0.5.15
    repository: https://rh-ai-quickstart.github.io/ai-architecture-charts
    condition: mcp-servers.enabled
```

#### Values.yaml Structure

Models are configured under `global.models`, where each key is a model name. The presence of a `url` field distinguishes a remote/MaaS model from a locally deployed one. Subchart-specific configuration is nested under the subchart name.

```yaml
# LLM Service Configuration
llm-service:
  secret:
    hf_token: ""
    enabled: true

# Global model configuration
# Models are enabled/disabled individually
# Local models deploy vLLM pods on the cluster
# Remote models (with url field) proxy through LlamaStack
global:
  models:
    # Local model — deployed on-cluster via vLLM
    llama-3-2-3b-instruct:
      id: meta-llama/Llama-3.2-3B-Instruct
      enabled: false
      tolerations:
        - key: "nvidia.com/gpu"
          operator: Exists
          effect: NoSchedule

    # CPU variant — same model, no GPU required
    llama-3-2-1b-instruct-cpu:
      id: meta-llama/Llama-3.2-1B-Instruct
      enabled: false
      device: cpu
      resources:
        limits:
          cpu: "6"
          memory: 12Gi
        requests:
          cpu: "2"
          memory: 6Gi

    # Remote / MaaS model — no local deployment
    # remotellm:
    #   id: custom-model-id
    #   url: https://custom-server-url/v1
    #   apiToken: your-api-token
    #   enabled: false

    # Safety model (optional)
    # llama-guard-3-8b:
    #   id: meta-llama/Llama-Guard-3-8B
    #   enabled: false
    #   registerShield: true
    #   tolerations:
    #     - key: "nvidia.com/gpu"
    #       operator: Exists
    #       effect: NoSchedule

# Database Configuration (pgvector)
pgvector:
  secret:
    user: "postgres"
    password: "app_password"
    dbname: "app_db"
    host: "pgvector"
    port: "5432"

# MinIO / S3 Configuration
configure-pipeline:
  minio:
    secret:
      user: minio_user
      password: minio_password
      host: minio
      port: "9000"
    sampleFileUpload:
      enabled: true
      bucket: documents

# LlamaStack Configuration
llama-stack:
  secrets:
    TAVILY_SEARCH_API_KEY: ""

# Ingestion Pipeline Configuration
ingestion-pipeline:
  enabled: true
  pipelines:
    my-pipeline:
      enabled: true
      source: GITHUB
      embedding_model: "all-MiniLM-L6-v2"
      name: "my-vector-db"
      version: "1.0"
      vector_store_name: "my-vector-db-v1-0"
      GITHUB:
        url: https://github.com/my-org/my-repo.git
        path: data/documents
        branch: main
```

For a complete real-world example, see the [RAG quickstart values file](https://github.com/rh-ai-quickstart/RAG/blob/main/deploy/helm/rag-values.yaml.example).

#### Makefile for Installation

Use a Makefile to wrap Helm commands with sensible defaults and command-line overrides:

```makefile
NAMESPACE ?=
LLM ?=
SAFETY ?=
DEVICE ?= gpu
LLM_URL ?=
LLM_API_TOKEN ?=
LLM_TOLERATION ?= nvidia.com/gpu
HF_TOKEN ?=
CHART_DIR := chart

.PHONY: install
install: check-deps namespace depend
	$(eval HELM_ARGS :=)
ifdef LLM
	$(eval HELM_ARGS += --set global.models.$(LLM).enabled=true)
endif
ifdef LLM_URL
	$(eval HELM_ARGS += --set global.models.$(LLM).url=$(LLM_URL))
	$(eval HELM_ARGS += --set global.models.$(LLM).apiToken=$(LLM_API_TOKEN))
endif
ifdef LLM_TOLERATION
	$(eval HELM_ARGS += --set global.models.$(LLM).tolerations[0].key=$(LLM_TOLERATION))
	$(eval HELM_ARGS += --set global.models.$(LLM).tolerations[0].operator=Exists)
	$(eval HELM_ARGS += --set global.models.$(LLM).tolerations[0].effect=NoSchedule)
endif
ifdef HF_TOKEN
	$(eval HELM_ARGS += --set llm-service.secret.hf_token=$(HF_TOKEN))
endif
	helm upgrade --install my-quickstart $(CHART_DIR) \
		-n $(NAMESPACE) -f values.yaml $(HELM_ARGS)

.PHONY: uninstall
uninstall:
	helm uninstall my-quickstart -n $(NAMESPACE)
	oc delete pvc -l app=pgvector -n $(NAMESPACE) --ignore-not-found
	oc delete pvc -l app=minio -n $(NAMESPACE) --ignore-not-found

.PHONY: status
status:
	@oc get pods -n $(NAMESPACE)
	@oc get svc -n $(NAMESPACE)
	@oc get routes -n $(NAMESPACE)

.PHONY: list-models
list-models:
	@helm template my-quickstart $(CHART_DIR) --set _debugListModels=true 2>/dev/null \
		| grep "model:" || echo "No models found"

.PHONY: namespace
namespace:
	oc new-project $(NAMESPACE) 2>/dev/null || true

.PHONY: depend
depend:
	helm dependency update $(CHART_DIR)

.PHONY: check-deps
check-deps:
	@command -v helm >/dev/null || (echo "ERROR: helm not found" && exit 1)
	@command -v oc >/dev/null || (echo "ERROR: oc not found" && exit 1)
```

### Model Deployment Options

Quickstarts support two model deployment modes, distinguished by the presence of a `url` field in the model configuration.

#### Option A: Local Model Deployment (On-Cluster)

Deploy a model directly on the cluster using vLLM on OpenShift AI. The `llm-service` subchart creates a vLLM inference pod. Requires GPU (or CPU for smaller models):

```bash
# GPU deployment
make install NAMESPACE=my-app LLM=llama-3-2-3b-instruct LLM_TOLERATION="nvidia.com/gpu"

# CPU deployment (no GPU required)
make install NAMESPACE=my-app LLM=llama-3-2-1b-instruct-cpu DEVICE=cpu

# With safety model
make install NAMESPACE=my-app \
  LLM=llama-3-2-3b-instruct LLM_TOLERATION="nvidia.com/gpu" \
  SAFETY=llama-guard-3-8b SAFETY_TOLERATION="nvidia.com/gpu"
```

Supported hardware:

| Hardware | Flag | Example |
|----------|------|---------|
| NVIDIA GPU | `DEVICE=gpu` | A10, A100, L4, L40S, T4 |
| Intel Gaudi HPU | `DEVICE=hpu` | Gaudi 2, Gaudi 3 |
| Intel Xeon CPU | `DEVICE=xeon` | Sapphire Rapids+ |
| Generic CPU | `DEVICE=cpu` | Any x86_64 |

#### Option B: Remote Model / MaaS (Model as a Service)

Connect to an existing model endpoint. No GPU required — the `llm-service` does not deploy a local vLLM instance. LlamaStack proxies requests to the remote endpoint:

```bash
make install NAMESPACE=my-app \
  LLM=remotellm \
  LLM_URL=https://my-model-endpoint/v1 \
  LLM_API_TOKEN=my-api-token
```

Or configure directly in `values.yaml`:

```yaml
global:
  models:
    remotellm:
      id: custom-model-id
      url: https://my-model-endpoint/v1
      apiToken: my-api-token
      enabled: true
```

The key distinction: when a model entry has a `url` field, LlamaStack configures a remote inference provider. When `url` is absent, the `llm-service` deploys a local vLLM pod.

#### Makefile Command-Line Overrides

| Variable | Purpose |
|----------|---------|
| `LLM` | Model key to enable (e.g., `llama-3-2-3b-instruct`, `remotellm`) |
| `SAFETY` | Safety model key to enable (e.g., `llama-guard-3-8b`) |
| `LLM_URL` / `SAFETY_URL` | Remote endpoint URL (triggers MaaS mode) |
| `LLM_API_TOKEN` / `SAFETY_API_TOKEN` | Auth token for remote models |
| `LLM_TOLERATION` / `SAFETY_TOLERATION` | GPU node toleration key |
| `DEVICE` | Device type: `cpu`, `gpu`, `hpu`, `xeon` |
| `HF_TOKEN` | Hugging Face token for downloading model weights |
| `NAMESPACE` | Target OpenShift namespace |

### Contribution Guidelines

When creating a new quickstart, follow these guidelines:

1. **README template** — Use the [README template](https://github.com/rh-ai-quickstart/ai-quickstart-template/blob/main/README.md) from this repository. It includes required sections for title, description, architecture diagrams, requirements, deployment steps, and tags.

2. **Tags for catalog publication** — Every quickstart must include metadata tags:
   - **Title**: Max 64 characters, industry-focused (e.g., "Protect patient data with LLM guardrails")
   - **Description**: Max 160 characters
   - **Industry**: Healthcare, Retail, Financial Services, Manufacturing, etc.
   - **Product**: Primary Red Hat product (e.g., OpenShift AI)

3. **Architecture diagram** — Required. Place in `docs/images/` with descriptive filenames.

4. **Hardware requirements** — Be specific about CPU, memory, GPU, and storage needs.

5. **Helm test** — Include a test to validate model connectivity post-deployment.

6. **License** — Use MIT license.

---

## Testing Best Practices

AI Quickstarts should implement a multi-layered testing strategy that covers code correctness, deployment validation, and AI behavior evaluation.

### Testing Strategy

| Test Layer | Purpose | When It Runs | Tools |
|------------|---------|-------------|-------|
| **Unit Tests** | Validate individual functions and service logic | Every PR, every push | pytest |
| **Integration Tests** | Validate service-to-service communication in a deployed cluster | PR (on cluster), nightly | pytest + kubectl exec |
| **Helm Chart Validation** | Ensure Helm templates render valid Kubernetes manifests | Every PR | kubeconform |
| **LLM Evaluation** | Assess AI response quality, policy compliance, and conversation completeness | PR (short), nightly (full) | DeepEval, LLM-as-Judge |
| **Known-Bad Regression** | Verify that evaluation metrics correctly flag known failures | Every PR | DeepEval |
| **E2E (End-to-End)** | Full deployment on a real or Kind cluster with real LLM interactions | Nightly, pre-promotion | Kind cluster, Helm |

### Unit Tests

Each service in a quickstart should have its own test suite under a `tests/` directory. Use **pytest** as the test runner.

**Recommended `pyproject.toml` pytest configuration:**

```toml
[tool.pytest.ini_options]
minversion = "8.0"
addopts = ["-ra", "--strict-markers", "--strict-config", "--verbose"]
testpaths = ["tests"]
python_files = ["test_*.py"]
python_classes = ["Test*"]
python_functions = ["test_*"]
markers = [
    "slow: marks tests as slow",
    "integration: marks tests as integration tests",
    "unit: marks tests as unit tests",
]
```

**For multi-service quickstarts**, define a Makefile target that runs tests across all services:

```makefile
define run_pytest
    cd $(1) && uv sync --group dev && uv run python -m pytest tests/
endef

.PHONY: test-all
test-all:
    $(call run_pytest,shared-models)
    $(call run_pytest,shared-clients)
    $(call run_pytest,backend)
    $(call run_pytest,frontend)
```

### Integration Tests

Integration tests validate that services work together correctly when deployed on a cluster. Run these inside the cluster using `kubectl exec`:

```makefile
.PHONY: test-session-integration
test-session-integration:
    kubectl exec deploy/request-manager -n $(NAMESPACE) -- \
        python -m pytest tests/integration/ -v --timeout=120
```

Key patterns:
- Use configurable URLs (e.g., `REQUEST_MANAGER_URL`) so tests can target different deployments.
- Add stagger delays (`STAGGER_MS`) for load-balanced multi-pod scenarios.
- Wrap long-running tests with timeouts to prevent CI hangs.

### LLM Evaluation Framework

Because LLM outputs are non-deterministic, quickstarts with AI agents should include an **evaluation framework** using LLM-as-Judge patterns.

**Recommended structure:**

```
evaluations/
├── conversations_config/
│   └── conversations/          # Predefined conversation flows
│       ├── my_use_case_flow.yaml
│       └── known_bad/          # Known-bad conversations for regression
├── evaluate.py                 # Orchestrator: generate + evaluate
├── generator.py                # Synthetic conversation generator
├── deep_eval.py                # DeepEval metric evaluation
├── run_conversations.py        # Execute conversation flows
├── flow_registry.py            # Registry of evaluation flows
└── tests/
    └── test_evaluation.py      # Evaluation test entry points
```

Define conversation flows specific to your use case (e.g., a customer support flow, a document retrieval flow, a multi-step agent workflow). Known-bad conversations should exercise failure modes that your metrics must catch.

**Evaluation test sizes for CI:**

| Target | Conversations | Timeout | When to Run |
|--------|:------------:|:-------:|-------------|
| Short | 1 | 120s | Every PR |
| Medium | 5 | 600s | Pre-merge |
| Long | 20 | 1800s | Nightly |
| Concurrent | 10 x 4 workers | 1800s | Nightly |

**Example evaluation metrics** (assessed by a judge LLM):

- Turn Relevancy — Are responses on-topic for each conversation turn?
- Role Adherence — Does the agent stay within its defined persona and scope?
- Conversation Completeness — Does the agent gather all required information?
- Policy Compliance — Does the agent follow business rules and guidelines?
- Factual Accuracy — Are RAG-grounded responses factually correct?
- Safety Compliance — Are guardrails correctly applied to block harmful content?

### Helm Chart Validation

Validate that Helm chart templates render valid Kubernetes manifests using **kubeconform**:

```bash
helm template my-quickstart ./chart | kubeconform -strict -summary
```

Include this as a CI step to catch template rendering issues before deployment.

---

## Code Quality

### Linting

Use **flake8** for Python linting with the following recommended configuration:

**`.flake8`:**

```ini
[flake8]
max-line-length = 88
ignore = E203, W503, E501
max-complexity = 10
select = E, W, F
exclude = .git, __pycache__, .venv, evaluations, alembic/versions
```

### Formatting

Use **Black** for code formatting and **isort** for import sorting. These should be consistent across all services.

**`pyproject.toml`:**

```toml
[tool.black]
line-length = 88
target-version = ["py312"]

[tool.isort]
profile = "black"
line_length = 88
```

**Makefile targets:**

```makefile
.PHONY: format
format:
    uv run isort .
    uv run black .

.PHONY: lint
lint: format lint-flake8 lint-mypy check-logging
```

### Type Checking

Use **mypy** with strict mode for type safety. Run per-directory in multi-service repos:

**`pyproject.toml`:**

```toml
[tool.mypy]
python_version = "3.12"
mypy_path = "shared-clients/src:shared-models/src"
```

**Makefile target:**

```makefile
.PHONY: lint-mypy
lint-mypy:
    cd agent-service && uv run mypy --strict src/
    cd request-manager && uv run mypy --strict src/
    cd backend && uv run mypy --strict src/
```

Include type stub packages (`types-pyyaml`, `types-requests`) in dev dependencies for complete type coverage.

### Custom Code Quality Rules

For AI applications, enforce **structured logging** patterns to ensure production observability. Create a custom checker script (e.g., `scripts/check_logging_patterns.py`) that validates:

| Rule | Description | Why It Matters |
|------|-------------|---------------|
| **LOG001** | No direct `import logging` — use a shared logging configuration | Consistent log format across services |
| **LOG002** | No `print()` in `src/` directories | All output must go through structured logging |
| **LOG003** | No f-strings in logger calls — use keyword arguments | Enable structured log aggregation and search |

**Example enforcement:**

```python
# BAD
import logging
logger = logging.getLogger(__name__)
logger.info(f"Processing request {request_id}")

# GOOD
from shared_models import configure_logging
logger = configure_logging(__name__)
logger.info("Processing request", request_id=request_id)
```

---

## Git Workflow and Configuration

### Branch Strategy

Quickstarts should use a **two-branch workflow** with promotion:

```
feature branches ──► dev ──► main
                      │         │
                      │         └── Stable/release (triggers image build + push)
                      └──────────── Development (triggers dev image build)
```

| Branch | Purpose | Protection |
|--------|---------|-----------|
| **main** | Stable, production-ready code | PRs only from `dev`; CI must pass |
| **dev** | Active development and integration | PRs from feature branches; CI must pass |
| **feature/\*** | Individual feature or fix work | Merged to `dev` via PR |

Enforce branch protection via a CI workflow that rejects PRs to `main` from any branch other than `dev`:

```yaml
# .github/workflows/pr-branch-check.yml
name: Require dev branch for main PRs
on:
  pull_request:
    branches: [main]
jobs:
  check-branch:
    runs-on: ubuntu-latest
    steps:
      - name: Check source branch
        run: |
          if [[ "${{ github.head_ref }}" != "dev" && ! "${{ github.head_ref }}" =~ ^dev- ]]; then
            echo "ERROR: PRs to main must come from the dev branch"
            exit 1
          fi
```

### Version Management

Maintain consistent versions across three locations:

| File | Field | Example |
|------|-------|---------|
| `Makefile` | `BASE_VERSION` | `0.1.0` |
| `chart/Chart.yaml` | `appVersion` | `0.1.0` |
| `chart/values.yaml` | `image.tag` | `0.1.0` |

The promotion workflow should validate that all three match and that the dev version is strictly greater than the main version (semantic versioning).

**Tagging convention for container images:**

| Tag | When | Example |
|-----|------|---------|
| `{version}` | Every build | `0.1.0` |
| `{version}-{short-sha}` | Every build | `0.1.0-a1b2c3d` |
| `latest` | Push to `main` | `latest` |
| `{branch}` | Push to `dev` | `dev` |

### Dependency Management

Use **uv** as the Python package manager. Pin the uv version and validate it in CI:

**Makefile:**

```makefile
REQUIRED_UV_VERSION := 0.8.9

.PHONY: check-uv-version
check-uv-version:
    @CURRENT=$$(uv --version | awk '{print $$2}'); \
    if [ "$$CURRENT" != "$(REQUIRED_UV_VERSION)" ]; then \
        echo "ERROR: uv version mismatch (expected $(REQUIRED_UV_VERSION), got $$CURRENT)"; \
        exit 1; \
    fi

.PHONY: check-lockfiles
check-lockfiles:
    @for dir in shared-models shared-clients backend frontend; do \
        cd $$dir && uv lock --check && cd ..; \
    done

.PHONY: update-lockfiles
update-lockfiles:
    @for dir in shared-models shared-clients backend frontend; do \
        cd $$dir && uv lock && uv export --frozen --no-hashes > requirements.txt && cd ..; \
    done
```

Export `requirements.txt` from lockfiles so containerized builds can use either `uv sync` (fast) or `pip install` (cross-platform fallback).

### Container Build Patterns

Use **multi-stage builds** with UBI9 (Red Hat Universal Base Image) for production containers:

```dockerfile
# Builder stage
FROM registry.access.redhat.com/ubi9/python-312:latest AS builder
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Production stage
FROM registry.access.redhat.com/ubi9/python-312:latest
COPY --from=builder /opt/app-root /opt/app-root
COPY src/ ./src/
USER 1001
CMD ["python", "-m", "uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

**Best practices:**
- Use non-root user (`USER 1001`)
- Support both `uv sync` and `pip install` build paths for cross-architecture compatibility (e.g., QEMU on Mac M1)
- Include OpenTelemetry instrumentation by default for observability
- Pin base image versions and keep pip updated for CVE mitigation

**`.dockerignore`:**

```
.venv
__pycache__
.git
.idea
.vscode
*.pyc
*.pyo
*.egg-info
dist/
build/
```

---

## GitHub Actions CI/CD

Quickstarts should configure the following GitHub Actions workflows for comprehensive CI/CD. These workflows are organized from most frequent (every PR) to least frequent (nightly/promotion).

### PR Quality Checks

**`.github/workflows/pr-checks.yml`** — Runs on every pull request. Three parallel jobs:

```yaml
name: "Pull Request - Quality Checks & Unit Tests"
on:
  pull_request:
    branches: [dev, main]
concurrency:
  group: pr-checks-${{ github.event.pull_request.number }}
  cancel-in-progress: true

jobs:
  code-quality-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: astral-sh/setup-uv@v6
        with:
          version: "0.8.9"
      - name: Check uv version
        run: make check-uv-version
      - name: Check lockfile freshness
        run: make check-lockfiles
      - name: Check requirements.txt sync
        run: make check-requirements
      - name: Run flake8
        run: uv run flake8 .
      - name: Check formatting (black)
        run: uv run black --check .
      - name: Check imports (isort)
        run: uv run isort --check-only .
      - name: Run mypy (per-directory)
        run: make lint-mypy
      - name: Check logging patterns
        run: python scripts/check_logging_patterns.py

  helm-validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install Helm
        uses: azure/setup-helm@v4
      - name: Install kubeconform
        run: |
          curl -sSL https://github.com/yannh/kubeconform/releases/latest/download/kubeconform-linux-amd64.tar.gz \
            | tar xz -C /usr/local/bin
      - name: Validate Helm templates
        run: helm template my-quickstart ./chart | kubeconform -strict -summary

  unit-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: astral-sh/setup-uv@v6
        with:
          version: "0.8.9"
      - name: Run all unit tests
        run: make test-all
```

### PR Integration and E2E Tests

**`.github/workflows/pr-e2e-tests.yml`** — Runs integration and short evaluation tests. Uses `pull_request_target` for safe access to secrets when testing fork PRs:

```yaml
name: "Pull Request - Integration & E2E Tests"
on:
  pull_request_target:
    branches: [dev]
  schedule:
    - cron: "0 6 * * *"   # Daily fallback

jobs:
  integration-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Create Kind cluster
        uses: ./.github/actions/kind
        with:
          namespace: test-ns
      - name: Run integration tests
        run: |
          make test-session-integration NAMESPACE=test-ns
      - name: Run short evaluation (1 conversation)
        run: |
          make test-short-eval NAMESPACE=test-ns
        env:
          LLM_URL: ${{ secrets.LLM_URL }}
          LLM_API_TOKEN: ${{ secrets.LLM_API_TOKEN }}
      - name: Upload evaluation results
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: evaluation-results-${{ github.run_id }}
          path: evaluations/results/
          retention-days: 30
```

### PR Evaluation Check

**`.github/workflows/pr-evaluation-check.yml`** — Validates that the evaluation framework correctly catches known-bad conversations:

```yaml
name: "Pull Request - Evaluation Check"
on:
  pull_request:
    branches: [dev, main]

jobs:
  check-known-bad:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: astral-sh/setup-uv@v6
      - name: Check known-bad conversations
        run: make check-known-bad-conversations
      - name: Upload results
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: known-bad-results-${{ github.run_id }}
          path: evaluations/results/
          retention-days: 30
```

### PR Build Test

**`.github/workflows/pr-build-test.yml`** — Validates the container build and Helm deployment on a Kind cluster:

```yaml
name: "Pull Request - Build Test"
on:
  pull_request:
    branches: [dev]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Create Kind cluster and deploy
        uses: ./.github/actions/kind
        with:
          namespace: build-test
      - name: Verify pods are running
        run: |
          kubectl wait --for=condition=ready pod -l app=my-quickstart \
            -n build-test --timeout=300s
```

### PR Branch Enforcement

**`.github/workflows/pr-branch-check.yml`** — Ensures PRs to `main` only come from `dev`:

```yaml
name: "Require dev branch for main PRs"
on:
  pull_request:
    branches: [main]

jobs:
  check-branch:
    runs-on: ubuntu-latest
    steps:
      - name: Validate source branch
        run: |
          SOURCE="${{ github.head_ref }}"
          if [[ "$SOURCE" != "dev" && ! "$SOURCE" =~ ^dev-[a-f0-9]+$ ]]; then
            echo "::error::PRs to main must originate from the 'dev' branch."
            echo "Current source branch: $SOURCE"
            exit 1
          fi
          echo "Source branch '$SOURCE' is valid."
```

### Build and Push Images

**`.github/workflows/build-and-push.yml`** — Builds and pushes container images on merge to `main` or `dev`:

```yaml
name: "Build and Push Container Images"
on:
  push:
    branches: [main, dev]

jobs:
  build-push:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        service: [frontend, backend, agent-service]
    steps:
      - uses: actions/checkout@v4
      - name: Log in to Quay.io
        uses: docker/login-action@v3
        with:
          registry: quay.io
          username: ${{ secrets.QUAY_USERNAME }}
          password: ${{ secrets.QUAY_PASSWORD }}
      - name: Determine tags
        id: tags
        run: |
          VERSION=$(grep '^BASE_VERSION' Makefile | cut -d'=' -f2 | tr -d ' ')
          SHA=$(git rev-parse --short HEAD)
          TAGS="quay.io/${{ github.repository_owner }}/${{ matrix.service }}:${VERSION}"
          TAGS="${TAGS},quay.io/${{ github.repository_owner }}/${{ matrix.service }}:${VERSION}-${SHA}"
          if [[ "${{ github.ref_name }}" == "main" ]]; then
            TAGS="${TAGS},quay.io/${{ github.repository_owner }}/${{ matrix.service }}:latest"
          else
            TAGS="${TAGS},quay.io/${{ github.repository_owner }}/${{ matrix.service }}:${{ github.ref_name }}"
          fi
          echo "tags=${TAGS}" >> "$GITHUB_OUTPUT"
      - name: Build and push
        uses: docker/build-push-action@v6
        with:
          context: ./${{ matrix.service }}
          push: true
          tags: ${{ steps.tags.outputs.tags }}
```

### Nightly E2E Tests

**`.github/workflows/nightly-e2e.yml`** — Full end-to-end tests with longer conversation counts and multiple LLM configurations:

```yaml
name: "Nightly - E2E Tests"
on:
  schedule:
    - cron: "0 3 * * *"    # 3 AM UTC daily
  workflow_dispatch: {}

concurrency:
  group: nightly-e2e
  cancel-in-progress: false

jobs:
  e2e-long:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        prompt_config: [default, small-prompt]
    steps:
      - uses: actions/checkout@v4
      - name: Deploy to test cluster
        run: make helm-install NAMESPACE=nightly-e2e
        env:
          LLM_URL: ${{ secrets.LLM_URL }}
          LLM_API_TOKEN: ${{ secrets.LLM_API_TOKEN }}
      - name: Run long evaluation (20 conversations)
        run: |
          make test-long-eval NAMESPACE=nightly-e2e \
            PROMPT_CONFIG=${{ matrix.prompt_config }}
        timeout-minutes: 45
      - name: Upload evaluation results
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: nightly-eval-${{ matrix.prompt_config }}-${{ github.run_id }}
          path: evaluations/results/
          retention-days: 30
      - name: Cleanup
        if: always()
        run: make helm-uninstall NAMESPACE=nightly-e2e
```

For production-like testing with real external systems (e.g., ServiceNow), create a separate nightly workflow that deploys to a shared namespace with `cancel-in-progress: false` to prevent simultaneous usage.

### Promotion and Version Bump

**`.github/workflows/create-dev-to-main-pr.yml`** — Automates promotion from `dev` to `main` with validation:

```yaml
name: "Create Dev to Main PR"
on:
  workflow_dispatch: {}

jobs:
  promote:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - name: Check branch divergence
        run: |
          git fetch origin main dev
          BEHIND=$(git rev-list --count origin/dev..origin/main)
          if [ "$BEHIND" -gt 0 ]; then
            echo "::error::main has $BEHIND commits not in dev. Rebase dev first."
            exit 1
          fi
      - name: Validate version consistency
        run: |
          MK_VER=$(grep '^BASE_VERSION' Makefile | cut -d'=' -f2 | tr -d ' ')
          CHART_VER=$(grep '^appVersion' chart/Chart.yaml | cut -d'"' -f2)
          if [ "$MK_VER" != "$CHART_VER" ]; then
            echo "::error::Version mismatch: Makefile=$MK_VER, Chart.yaml=$CHART_VER"
            exit 1
          fi
      - name: Create PR
        run: |
          gh pr create --base main --head dev \
            --title "Promote dev to main (v${MK_VER})" \
            --body "Automated promotion PR"
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

**`.github/workflows/version-bump.yml`** — Auto-increments patch version across all files:

```yaml
name: "Version Bump"
on:
  workflow_dispatch:
    inputs:
      bump:
        description: "Version component to bump"
        type: choice
        options: [patch, minor, major]
        default: patch
```

### Custom GitHub Actions

Create reusable composite actions under `.github/actions/` for common CI tasks:

**`.github/actions/kind/action.yaml`** — Spin up a Kind cluster with local registry for integration testing:

```yaml
name: "Create Kind Cluster"
description: "Creates a Kind cluster with local registry and deploys the quickstart"
inputs:
  namespace:
    description: "Kubernetes namespace"
    required: true
runs:
  using: composite
  steps:
    - name: Create Kind cluster
      shell: bash
      run: |
        kind create cluster --name ci-test
        kubectl create namespace ${{ inputs.namespace }}
    - name: Build and load images
      shell: bash
      run: |
        for svc in frontend backend; do
          docker build -t localhost:5000/${svc}:test ./${svc}
          kind load docker-image localhost:5000/${svc}:test --name ci-test
        done
    - name: Deploy with Helm
      shell: bash
      run: |
        helm install my-quickstart ./chart \
          --namespace ${{ inputs.namespace }} \
          --wait --timeout 5m
```

**`.github/actions/prepare-runner/action.yaml`** — Free disk space on CI runners for GPU-heavy workloads:

```yaml
name: "Prepare CI Runner"
description: "Frees disk space and reports system resources"
runs:
  using: composite
  steps:
    - name: Free disk space
      shell: bash
      run: |
        sudo rm -rf /usr/share/dotnet /usr/local/lib/android /opt/ghc
        df -h
    - name: Report resources
      shell: bash
      run: |
        echo "Memory:" && free -h
        echo "Disk:" && df -h
        echo "CPUs:" && nproc
```

### Summary of Recommended Workflows

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| `pr-checks.yml` | Every PR | Linting, formatting, type checks, unit tests, lockfile validation |
| `pr-e2e-tests.yml` | PR to dev | Integration tests + short LLM evaluation on Kind cluster |
| `pr-evaluation-check.yml` | Every PR | Validate known-bad conversations are caught |
| `pr-build-test.yml` | PR to dev | Container build + Helm deployment validation |
| `pr-branch-check.yml` | PR to main | Enforce dev-to-main promotion path |
| `build-and-push.yml` | Push to main/dev | Build and push container images to registry |
| `nightly-e2e.yml` | Cron (daily) | Full evaluation with 20+ conversations, multiple LLM configs |
| `create-dev-to-main-pr.yml` | Manual dispatch | Automated promotion with version validation |
| `version-bump.yml` | Manual dispatch | Auto-increment version across Makefile + Chart.yaml + values.yaml |

---

## Key Technology Components

| Technology | Role in Quickstarts |
|------------|-------------------|
| **[Red Hat OpenShift AI](https://www.redhat.com/en/technologies/cloud-computing/openshift/openshift-ai)** | AI/ML platform providing model serving, pipelines, workbenches, and model registry |
| **[vLLM](https://docs.vllm.ai/)** | High-performance LLM inference engine used by the LLM Service chart |
| **[KServe](https://kserve.github.io/)** | Kubernetes-native model serving, integrated with OpenShift AI |
| **[LlamaStack](https://llama-stack.readthedocs.io/)** | Meta's AI application framework — unified API for models, agents, safety, and memory |
| **[LangGraph](https://langchain-ai.github.io/langgraph/)** | Agent orchestration framework for building stateful, multi-agent workflows |
| **[Model Context Protocol (MCP)](https://modelcontextprotocol.io/)** | Open protocol enabling AI agents to interact with external tools and data sources |
| **[PostgreSQL + PGVector](https://github.com/pgvector/pgvector)** | Vector similarity search for RAG retrieval |
| **[MinIO](https://min.io/)** | S3-compatible object storage for documents and model artifacts |
| **[Helm](https://helm.sh/)** | Kubernetes package manager used for all quickstart deployment |
| **[Tailwind CSS](https://tailwindcss.com/)** | Utility-first CSS framework for building custom user interfaces |
| **[FastAPI](https://fastapi.tiangolo.com/)** | Modern Python web framework for building backend APIs with automatic OpenAPI docs |
| **[AI QuickStart CLI](https://github.com/rh-ai-quickstart/quickstart-cli)** | CLI tool to scaffold production-ready full-stack apps with React, FastAPI, and PostgreSQL |

---

## Community and Ecosystem

AI Quickstarts are developed as open-source projects under the [rh-ai-quickstart](https://github.com/rh-ai-quickstart) GitHub organization.

### How to Contribute

1. **Build a new quickstart** — Use this template repository to create a quickstart for your industry or use case.
2. **Improve existing quickstarts** — Submit pull requests with bug fixes, documentation improvements, or new features.
3. **Contribute architecture charts** — Add new reusable Helm charts to the [ai-architecture-charts](https://github.com/rh-ai-quickstart/ai-architecture-charts) library.
4. **Share feedback** — Open issues to report bugs, request features, or suggest improvements.

### Project Navigator Integration

Red Hat Project Navigator is AI quickstart-aware — it can discover and trigger quickstart deployments through voice and GUI interactions, making it even easier to get started.

---

## References

- [Red Hat OpenShift AI Documentation](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4)
- [AI Architecture Charts Repository](https://github.com/rh-ai-quickstart/ai-architecture-charts)
- [AI Quickstart Template Repository](https://github.com/rh-ai-quickstart/ai-quickstart-template)
- [LlamaStack Documentation](https://llama-stack.readthedocs.io/)
- [Model Context Protocol Specification](https://modelcontextprotocol.io/)
- [Helm Documentation](https://helm.sh/docs/)
