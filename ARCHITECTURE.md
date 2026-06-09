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
- [Existing Quickstarts](#existing-quickstarts)
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
│              (Streamlit, React/PatternFly, Gradio)                  │
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
| **Frontend** | User-facing interface for interacting with the AI application | Streamlit, React with PatternFly, Gradio |
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

1. **Use the template repository** — Start by creating a new repository from the [AI Quickstart Template](https://github.com/rh-ai-quickstart/ai-quickstart-template).

2. **Define your use case** — Identify a real-world AI problem in a specific industry (healthcare, finance, retail, manufacturing, IT operations, etc.).

3. **Select your components** — Choose which architecture charts your quickstart needs from the [shared chart library](#ai-architecture-helm-charts).

4. **Build your application** — Implement the frontend, backend, and any custom logic specific to your use case.

5. **Package as a Helm chart** — Wire everything together in a single Helm chart that deploys the complete stack.

6. **Document thoroughly** — Follow the README template structure so users can understand, deploy, and extend your quickstart.

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
├── frontend/                       # Frontend application source
│   ├── app.py / src/               # Application code
│   ├── Containerfile               # Container build file
│   └── requirements.txt            # Dependencies
├── backend/                        # Backend application source
│   ├── app.py / src/               # Application code
│   ├── Containerfile               # Container build file
│   └── requirements.txt            # Dependencies
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

1. **Declare dependencies** on shared architecture charts in `Chart.yaml`.
2. **Expose configuration** through `values.yaml` — model selection, resource limits, feature toggles.
3. **Support both MaaS and local model deployment** via the `model` values block.
4. **Include a Helm test** (`test-model-access.yaml`) to validate model connectivity.
5. **Use OpenShift Routes** for exposing the UI to users.

Example `values.yaml` structure:

```yaml
# Model configuration
model: {}
# model:
#   name: llama-3-2-3b-instruct
#   endpoint: https://my-maas-instance:443
#   api_key: my-api-key

# Application configuration
app:
  replicas: 1
  image: quay.io/my-org/my-app:latest
  resources:
    requests:
      cpu: "2"
      memory: "4Gi"
    limits:
      cpu: "4"
      memory: "8Gi"

# Feature toggles
features:
  safety: false          # Enable Llama Guard safety shields
  ingestion: true        # Deploy document ingestion pipeline
  mcpServers: false      # Deploy MCP servers
```

### Model Deployment Options

Quickstarts support two model deployment modes:

#### Option A: Model as a Service (MaaS)

Connect to an existing model endpoint — no GPU required on the cluster:

```bash
helm install my-app ./chart \
  --set model.name=my-model \
  --set model.endpoint=https://my-endpoint \
  --set model.api_key=my-key
```

#### Option B: Local Model Deployment

Deploy a model directly on the cluster using vLLM on OpenShift AI. Requires GPU:

```bash
helm install my-app ./chart \
  --set model.name=llama-3-2-3b-instruct \
  --set model.huggingface_token=hf_xxx
```

Supported hardware for local deployment:

| Hardware | Flag | Example |
|----------|------|---------|
| NVIDIA GPU | `DEVICE=gpu` | A10, A100, L4, L40S, T4 |
| Intel Gaudi HPU | `DEVICE=hpu` | Gaudi 2, Gaudi 3 |
| Intel Xeon CPU | `DEVICE=xeon` | Sapphire Rapids+ |
| Generic CPU | `DEVICE=cpu` | Any x86_64 |

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

## Existing Quickstarts

The following quickstarts are available today, spanning multiple industries and AI patterns:

### Enterprise RAG Chatbot

**Use case**: Centralize company knowledge with an AI-powered chatbot that answers questions from your enterprise documents.

| Attribute | Details |
|-----------|---------|
| **Repository** | [rh-ai-quickstart/RAG](https://github.com/rh-ai-quickstart/RAG) |
| **Industry** | Cross-industry |
| **AI Pattern** | Retrieval-Augmented Generation (RAG) |
| **Components** | Streamlit UI, LlamaStack, vLLM (Llama 3), PGVector, MinIO, Ingestion Pipeline |
| **Key Features** | Document upload, vector search, agent-based RAG mode, safety guardrails (Llama Guard) |
| **Demo Scenario** | "FantaCo" — employees access HR, procurement, sales, and IT documentation through a chat interface |

### IT Self-Service Agent — Laptop Refresh

**Use case**: Automate routine IT processes like laptop refresh requests using AI agents that integrate with enterprise systems.

| Attribute | Details |
|-----------|---------|
| **Repository** | [rh-ai-quickstart/it-self-service-agent](https://github.com/rh-ai-quickstart/it-self-service-agent) |
| **Industry** | IT Operations |
| **AI Pattern** | Multi-agent with MCP tool integration |
| **Components** | Agent Service (LangGraph), Request Manager, Slack/Email integration, ServiceNow MCP Server, PromptGuard, PostgreSQL |
| **Key Features** | Multi-channel input (Slack, Email, API), routing and specialist agents, knowledge bases, evaluation framework, OpenTelemetry tracing |
| **Demo Scenario** | Employee requests laptop refresh via Slack or email; AI agent validates eligibility, presents options, and submits ServiceNow ticket |

### AI Virtual Agent

**Use case**: Build and deploy conversational AI agents with knowledge bases, tool integration, and safety guardrails.

| Attribute | Details |
|-----------|---------|
| **Repository** | [rh-ai-quickstart/ai-virtual-agent](https://github.com/rh-ai-quickstart/ai-virtual-agent) |
| **Industry** | Cross-industry |
| **AI Pattern** | Conversational AI platform with RAG and MCP |
| **Components** | React/PatternFly UI, FastAPI backend, LlamaStack, PGVector, MinIO, MCP Servers |
| **Key Features** | Agent creation and management, knowledge base upload, streaming responses, Oracle DB integration |

### PPE Compliance Monitor

**Use case**: Use predictive and generative AI to keep workers safe on the job site by automatically detecting personal protective equipment.

| Attribute | Details |
|-----------|---------|
| **Industry** | Manufacturing / Construction |
| **AI Pattern** | Multi-modal (Computer Vision + Generative AI) |
| **Key Features** | Real-time video feed analysis, PPE detection (hardhats, masks, safety vests), safety trend reporting, chat-based assistant |

### Spending Transaction Monitor

**Use case**: Define personalized financial alert rules using natural language to reduce fraud exposure and improve customer trust.

| Attribute | Details |
|-----------|---------|
| **Industry** | Financial Services |
| **AI Pattern** | NLU + rule generation |
| **Key Features** | Natural language alert rule creation, transaction monitoring dashboard, AI-powered anomaly detection |

### AI Product Recommendations

**Use case**: Transform product discovery with personalized recommendations, AI-generated review summaries, and intelligent search.

| Attribute | Details |
|-----------|---------|
| **Industry** | Retail / E-commerce |
| **AI Pattern** | Recommendation engine + NLU |
| **Key Features** | Product search, AI review summarization, personalized recommendations |

### Observability Data Analyzer

**Use case**: Summarize and analyze vLLM model observability data with AI-generated insights and actionable recommendations.

| Attribute | Details |
|-----------|---------|
| **Industry** | IT Operations |
| **AI Pattern** | Metrics analysis + generative AI |
| **Key Features** | vLLM metrics monitoring, AI performance analysis reports, GPU/temperature/latency monitoring, chat-based assistant for metrics |

### Lemonade Stand Assistant

**Use case**: Secure customer service agent demonstrating content safety — validates user interactions and AI responses for safety and compliance.

| Attribute | Details |
|-----------|---------|
| **Industry** | Cross-industry (Safety demonstration) |
| **AI Pattern** | Guardrailed chatbot |
| **Key Features** | Prompt injection detection, content filtering dashboard (swearing, non-English, jailbreak), safety metrics visualization |

### Mortgage Lending with Multi-Agent AI

**Use case**: Handle loan applications at scale with automated document processing and agentic workflows for the fictitious lender "Fed Aura Capital".

| Attribute | Details |
|-----------|---------|
| **Industry** | Financial Services |
| **AI Pattern** | Multi-agent workflow |
| **Key Features** | Pre-qualification, risk assessment, compliance checks (ECOA, ATR/QM), AI-powered underwriting assistant |

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
| **[PatternFly](https://www.patternfly.org/)** | Red Hat's UI design system, used in React-based quickstart frontends |

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
