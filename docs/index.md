# Red Hat AI Quickstart Documentation

## Architecture and Concepts

- [Architecture Guide](../ARCHITECTURE.md) - Comprehensive guide to understanding Red Hat AI Quickstarts: what they are, how they work, the platform capabilities they leverage, the shared Helm chart library, and how to create your own quickstart.

### Architecture Guide Contents

| Section | Description |
|---------|-------------|
| [What is a Red Hat AI Quickstart?](../ARCHITECTURE.md#what-is-a-red-hat-ai-quickstart) | Definition, purpose, and comparison with reference architectures, NVIDIA Blueprints, and Validated Patterns |
| [Why AI Quickstarts?](../ARCHITECTURE.md#why-ai-quickstarts) | The problems they solve and advantages over traditional approaches |
| [Red Hat OpenShift AI Platform](../ARCHITECTURE.md#red-hat-openshift-ai-platform) | Platform features leveraged by quickstarts — model serving, pipelines, workbenches, model registry, and more |
| [Quickstart Architecture](../ARCHITECTURE.md#quickstart-architecture) | Common components, reference diagrams, and the shared AI Architecture Helm Charts library |
| [AI Architecture Helm Charts](../ARCHITECTURE.md#ai-architecture-helm-charts) | Reusable charts: LLM Service, LlamaStack, PGVector, MinIO, Ingestion Pipeline, MCP Servers, Oracle 23ai, Model Registry |
| [How to Create a Quickstart](../ARCHITECTURE.md#how-to-create-a-quickstart) | Step-by-step guide: repository structure, Helm chart setup, model deployment options, and contribution guidelines |
| [Existing Quickstarts](../ARCHITECTURE.md#existing-quickstarts) | Catalog of available quickstarts across industries — RAG, IT Self-Service Agent, AI Virtual Agent, PPE Monitor, and more |
| [Key Technology Components](../ARCHITECTURE.md#key-technology-components) | Technology stack: vLLM, KServe, LlamaStack, LangGraph, MCP, PGVector, MinIO, PatternFly |

## Additional Resources

- [Architecture Diagrams](images/) - Visual diagrams for your quickstart (add your own here)
- [AI Architecture Charts Repository](https://github.com/rh-ai-quickstart/ai-architecture-charts) - Shared Helm chart library
- [Red Hat OpenShift AI Documentation](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4)
- [AI Quickstart Template](https://github.com/rh-ai-quickstart/ai-quickstart-template) - This template repository
