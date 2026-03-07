# dotNetBench — .NET Development Bench

Full-featured .NET development container using the workBenches layered image system.

## Layer Architecture

```
Layer 0: workbench-base:latest     — Ubuntu 24.04, system tools, AI CLIs
Layer 1: devbench-base:latest      — Python, Node.js, dev tools
Layer 2: dotnet-bench:latest       — .NET SDK, cloud CLIs, DB clients (this image)
Layer 3: dotnet-bench:{username}   — User account (built automatically)
Runtime: devcontainer.json mounts  — Credentials, shell config, AI auth
```

## What Layer 2 Installs (v2.0.0)

### .NET SDK & Runtimes
- .NET 10 SDK, runtime, ASP.NET Core runtime
- Workloads: **Aspire**, **wasm-tools** (Blazor WASM AOT)

### .NET Global Tools (18+)
- **EF Core**: dotnet-ef
- **Diagnostics**: dotnet-trace, dotnet-dump, dotnet-counters, dotnet-monitor
- **Code quality**: dotnet-sonarscanner, coverlet, dotnet-stryker, dotnet-format
- **Scaffolding**: dotnet-aspnet-codegenerator, libman
- **Utilities**: dotnet-outdated, dotnet-retire, dotnet-depends, dotnet-script
- **Web**: httprepl, Swashbuckle CLI
- **Versioning**: GitVersion, ReportGenerator

### Cloud CLIs
- **Azure CLI** (includes Bicep)
- **AWS CLI v2**
- **Docker CLI** + Docker Compose (client only — host socket mount)
- **kubectl** (Kubernetes 1.32)
- **Helm 3**

### Database Clients
- PostgreSQL (`psql`)
- MySQL (`mysql`)
- SQLite (`sqlite3`)
- Redis (`redis-cli`)
- **MSSQL** (`sqlcmd` via mssql-tools18)

### PowerShell
- Cross-platform PowerShell (from Microsoft repo)

### System Utilities
- htop, tree, less

## Getting Started

### Build
```bash
# Build Layer 2 (requires devbench-base:latest)
docker build -t dotnet-bench:latest -f Dockerfile.layer2 .

# Or use the build script
./scripts/build-layer2.sh
```

### Open
1. Open this folder in VS Code
2. Click **"Reopen in Container"**
3. Layer 3 builds automatically via `ensure-layer3.sh`

### Verify
```bash
dotnet --version          # .NET 10 SDK
dotnet ef --version       # EF Core tools
dotnet-trace --version    # Diagnostics
az --version              # Azure CLI
aws --version             # AWS CLI
docker --version          # Docker client
kubectl version --client  # Kubernetes
helm version              # Helm
psql --version            # PostgreSQL client
sqlcmd --version          # MSSQL client
pwsh --version            # PowerShell
```

## Pre-configured Aliases

```bash
# .NET
dn / dnr / dnb / dnt / dnw    # dotnet run/build/test/watch
dnef / dna / dnrs / dnnew     # dotnet ef/add/restore/new

# Docker
d / dc / dps / di             # docker / compose / ps / images

# Kubernetes
k / kgp / kgs / kgd           # kubectl get pods/services/deployments
```

## Forwarded Ports

- `5000` — .NET HTTP
- `5001` — .NET HTTPS
- `7071` — Azure Functions
- `8080` — Dev Server
- `3000` — Frontend dev
- `4200` — Angular dev

## VS Code Extensions

Pre-configured: C# Dev Kit, Blazor WASM Companion, PowerShell, Azure Functions, Docker, Copilot, GitLens, Playwright, REST Client, NuGet Package Manager, and more.
