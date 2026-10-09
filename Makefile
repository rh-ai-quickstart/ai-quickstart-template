.PHONY: help demo up down logs ingest test lint shellcheck demo-local gateway-only test-webhook webhook-receiver \
        validate-manifests compose-e2e build-images deploy-openshift verify-openshift guidellm-openshift \
        undeploy-openshift run-on-kind destroy-kind kind-e2e test-openshift-overlay \
        quadlet-setup quadlet-build quadlet-up quadlet-down quadlet-reset quadlet-verify quadlet-ingest \
        quadlet-deploy quadlet-relaunch guidellm-quadlet quadlet-e2e \
        ci-install ci-test ci-uninstall

NAMESPACE ?= helpdesk-email-triage

help: ## Show this help message
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} \
	  /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-26s\033[0m %s\n", $$1, $$2 } \
	  /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' $(MAKEFILE_LIST)

##@ Local demo (Compose)

demo: ## Start mock inference + gateway + Streamlit UI (recommended for local evaluation)
	podman compose -f compose.mock.demo.yml up --build

gateway-only: ## Start mock inference + gateway only (no Streamlit UI)
	podman compose -f compose.gateway-only.yml up --build

demo-local: ## Run the demo stack via helper script
	./scripts/run-demo-local.sh

up: ## Start the full stack with real inference in detached mode (compose.yml)
	podman compose -f compose.yml up --build -d

down: ## Stop and remove all Compose stacks and volumes
	podman compose -f compose.yml down -v || true
	podman compose -f compose.mock.demo.yml down -v || true
	podman compose -f compose.gateway-only.yml down -v || true

logs: ## Follow logs from the mock demo stack
	podman compose -f compose.mock.demo.yml logs -f

ingest: ## POST sample emails to the running gateway
	./scripts/ingest-sample.sh

##@ Development

build-images: ## Build all container images locally with Podman
	podman build -f email-gateway/Containerfile -t localhost/helpdesk-email-gateway:local .
	podman build -f agent-dashboard/Containerfile -t localhost/helpdesk-triage-ui:local .
	podman build -f inference-mock/Containerfile -t localhost/helpdesk-inference-mock:local ./inference-mock

test: ## Run unit tests for the email gateway
	test -d .venv || python3 -m venv .venv
	.venv/bin/pip install -q -r email-gateway/requirements.txt pytest
	PYTHONPATH=email-gateway .venv/bin/python -m pytest email-gateway/tests -q

lint: ## Run ruff linter over gateway, dashboard, and mock
	test -d .venv || python3 -m venv .venv
	.venv/bin/pip install -q ruff
	.venv/bin/ruff check email-gateway agent-dashboard inference-mock

shellcheck: ## Run shellcheck (warning level) over all scripts
	command -v shellcheck >/dev/null || { echo "shellcheck not installed" >&2; exit 1; }
	shellcheck -S warning -x scripts/*.sh

test-webhook: ## Run self-contained webhook sink end-to-end test (no Compose required)
	chmod +x scripts/test-webhook-sink.sh scripts/webhook-receiver.py
	./scripts/test-webhook-sink.sh

webhook-receiver: ## Start a local webhook listener for manual testing
	chmod +x scripts/webhook-receiver.py
	./scripts/webhook-receiver.py --secret $${TICKET_SINK_SECRET:-demo-secret}

##@ OpenShift — Track 1

deploy-openshift: ## Deploy to OpenShift (INFERENCE=rhaii [default] or mock)
	chmod +x scripts/deploy-openshift.sh scripts/openshift-rhaii-secrets.sh scripts/openshift-verify.sh
	INFERENCE="$${INFERENCE:-rhaii}" ./scripts/deploy-openshift.sh

verify-openshift: ## Verify the OpenShift deployment (routes, health, tickets)
	chmod +x scripts/openshift-verify.sh
	./scripts/openshift-verify.sh

guidellm-openshift: ## Run GuideLLM inference benchmark on OpenShift
	chmod +x scripts/guidellm-openshift.sh
	./scripts/guidellm-openshift.sh

undeploy-openshift: ## Remove all OpenShift resources (add DELETE_NAMESPACE=1 to drop the project)
	chmod +x scripts/undeploy-openshift.sh
	./scripts/undeploy-openshift.sh

validate-manifests: ## Validate Kustomize manifests without applying them
	chmod +x scripts/validate-openshift-manifests.sh
	./scripts/validate-openshift-manifests.sh

test-openshift-overlay: ## Smoke-test the OpenShift Kustomize overlay rendering
	chmod +x scripts/test-openshift-overlay.sh
	./scripts/test-openshift-overlay.sh

run-on-kind: ## Deploy the stack on a local Kind cluster
	chmod +x scripts/run-on-kind.sh scripts/kind-lib.sh
	./scripts/run-on-kind.sh

destroy-kind: ## Tear down the Kind cluster
	chmod +x scripts/destroy-kind.sh
	./scripts/destroy-kind.sh

kind-e2e: ## End-to-end test on Kind (deploy → verify → destroy)
	chmod +x scripts/kind-e2e.sh scripts/kind-lib.sh scripts/destroy-kind.sh scripts/wait-for-tickets.sh
	./scripts/kind-e2e.sh

##@ RHEL Quadlet — Track 2

quadlet-deploy: quadlet-setup quadlet-build quadlet-up ## Full setup: install units, build images, start services (recommended starting point)

quadlet-setup: ## One-time setup: create dirs, install Quadlet units, scaffold secrets.env
	chmod +x scripts/quadlet-*.sh
	./scripts/quadlet-setup.sh

quadlet-build: ## Build gateway and dashboard container images for Quadlet
	chmod +x scripts/quadlet-*.sh
	./scripts/quadlet-build.sh

quadlet-up: ## Start inference, wait for readiness, then start gateway and dashboard
	chmod +x scripts/quadlet-*.sh
	./scripts/quadlet-up.sh

quadlet-down: ## Stop all Quadlet services (keeps units and data volumes)
	chmod +x scripts/quadlet-*.sh
	./scripts/quadlet-down.sh

quadlet-verify: ## Check status of all Quadlet services and gateway health
	chmod +x scripts/quadlet-*.sh
	./scripts/quadlet-verify.sh

quadlet-ingest: ## Ingest sample emails into the running Quadlet stack
	chmod +x scripts/quadlet-*.sh
	./scripts/quadlet-ingest-samples.sh

quadlet-reset: ## Full teardown of Quadlet state — requires QUADLET_RESET_CONFIRM=1
	chmod +x scripts/quadlet-*.sh
	./scripts/quadlet-reset.sh

quadlet-relaunch: ## Reset then redeploy (requires QUADLET_RESET_CONFIRM=1)
	@test "$(QUADLET_RESET_CONFIRM)" = "1" || { \
	  echo "Set QUADLET_RESET_CONFIRM=1 to wipe Quadlet state, e.g.:" >&2; \
	  echo "  QUADLET_RESET_CONFIRM=1 make quadlet-relaunch" >&2; \
	  exit 1; \
	}
	$(MAKE) quadlet-reset
	$(MAKE) quadlet-deploy

guidellm-quadlet: ## Run GuideLLM inference benchmark on RHEL (targets http://127.0.0.1:8000)
	chmod +x scripts/guidellm-quadlet.sh scripts/quadlet-lib.sh
	./scripts/guidellm-quadlet.sh

##@ CI (maintainers)

ci-install: ## Deploy with auto inference for CI and wait for readiness
	chmod +x scripts/deploy-openshift.sh scripts/openshift-rhaii-secrets.sh scripts/openshift-verify.sh
	INFERENCE=auto ./scripts/deploy-openshift.sh "$(NAMESPACE)"

ci-test: ## Verify the CI deployment
	chmod +x scripts/openshift-verify.sh
	./scripts/openshift-verify.sh "$(NAMESPACE)"

ci-uninstall: ## Remove CI deployment resources (does not delete the namespace)
	chmod +x scripts/undeploy-openshift.sh
	./scripts/undeploy-openshift.sh "$(NAMESPACE)"

compose-e2e: ## End-to-end Compose test (deploy → ingest → verify → teardown)
	chmod +x scripts/compose-e2e.sh scripts/wait-for-tickets.sh
	./scripts/compose-e2e.sh

quadlet-e2e: ## Maintainer-only Quadlet end-to-end test on a RHEL host
	chmod +x scripts/quadlet-*.sh scripts/wait-for-tickets.sh scripts/guidellm-quadlet.sh
	./scripts/quadlet-e2e.sh
