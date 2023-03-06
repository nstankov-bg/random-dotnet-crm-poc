## 📜 SRC Description:

-   A random-off-the shelf stateless app ( because stateless means happy Ops ) app, that simulates a weather API at /api/weather

## 🚀 Features:

-   🐳 Uses Docker Buildx for cross-architecture image builds (Welcome to the age of Apple Silicon)
-   🕸️ Uses NewRelic as an APM to establish tracing & basic SLAs
-   🐳 Uses k3d and/or compose with backwards compatibility for local development
-   🚀 Uses Kompose for compose -> helm conversion
-   🚀 Uses ArgoCD for best practice deployments & self-healing
-   🛠️ Uses Make to establish quality of life improvements
-   🐛 Uses K6 (open source) to do Continuous Stress Testing & Implementation Testing cross-platform
-   🔗 Uses github submodules to establish basic repository templating
-   📝 Uses EditorConfig to establish basic code style

## 🧪 BETA Features:

-   🔭 Trying out Hashicorp Waypoint, because why not.
-   📦 Uses Okteto to deploy ephemeral environments for testing, debugging, and reviewing

## 🛠️TODO:

-   [ ] Implement SEMVER
-   [ ] Implement Github Actions for basic CI
