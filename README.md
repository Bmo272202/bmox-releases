<p align="center">
  <img src="https://bmox.io/logo.svg" alt="Bmox" height="72" />
</p>

<h1 align="center">Bmox</h1>

<p align="center"><em>The infrastructure that makes existing software think.</em></p>

<p align="center">
  <a href="https://github.com/bmo272202/bmox-releases/releases/latest">
    <img alt="Latest release" src="https://img.shields.io/github/v/release/bmo272202/bmox-releases?color=%23e86c3a&label=latest&style=flat-square">
  </a>
  <img alt="Platforms" src="https://img.shields.io/badge/platforms-Windows%20%7C%20macOS%20%7C%20Linux-e86c3a?style=flat-square">
  <img alt="License" src="https://img.shields.io/badge/license-Proprietary-e86c3a?style=flat-square">
  <img alt=".NET" src="https://img.shields.io/badge/.NET-10.0-e86c3a?style=flat-square">
</p>

---

> Like a database doesn't build your application but your application doesn't work without it —
> **Bmox doesn't build your software, but your software has no intelligence without it.**

Bmox is a **CLI runtime** that lets you define AI agents as deterministic, composable blueprints (`.bmo` files) and run them anywhere — from your terminal, a Docker container, or an HTTP server your existing stack can call.

No frameworks to learn. No Python dependencies to manage. One binary. One command.

---

## Install

### macOS · Linux
```bash
curl -fsSL https://raw.githubusercontent.com/bmo272202/bmox-releases/main/install.sh | bash
```

### Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/bmo272202/bmox-releases/main/install.ps1 | iex
```

> After installing, **open a new terminal** and run `bmox --version` to confirm.

---

## Quickstart

```bash
# 1. Create a project
bmox init my-project && cd my-project

# 2. Connect your model (OpenAI, Anthropic, Gemini, Ollama, or free Demo)
bmox config

# 3. Run your first agent
bmox run main "Summarize everything in this folder"
```

That's it. No boilerplate, no SDK imports, no cloud signup required.

---

## What can Bmox do?

| Capability | Details |
|---|---|
| **21 node types** | `prompt`, `router`, `parallel`, `http`, `transform`, `retry`, `circuit_breaker`, `guardrail`, and more |
| **23 built-in skills** | File system, HTTP, SQLite, JSON/CSV, shell, webhooks — ready to use in any agent |
| **Multi-model** | OpenAI · Anthropic · Gemini · Ollama · built-in Demo (no key needed) |
| **MCP support** | Connect any external tool server via Model Context Protocol |
| **HTTP server mode** | `bmox serve` — expose a REST API your existing apps can call |
| **Multi-agent ecosystems** | Orchestrate fleets of agents with a single `ecosystem.bmo` file |
| **Docker ready** | Graceful shutdown, health endpoint, single-binary image *(Coming Soon)* |

---

## This repository

This is the **public release repository** for Bmox. Binaries are compiled from the private source repository and published here on every release, so anyone can install Bmox without needing access to the source code.

All releases follow [Semantic Versioning](https://semver.org/).

| Asset | Platform |
|---|---|
| `bmox-win-x64.zip` | Windows x64 (Intel / AMD) |
| `bmox-win-arm64.zip` | Windows ARM64 (Snapdragon) |
| `bmox-osx-arm64.tar.gz` | macOS Apple Silicon (M1 / M2 / M3) |
| `bmox-linux-x64.zip` | Linux x64 (Intel / AMD) |
| `bmox-linux-arm64.tar.gz` | Linux ARM64 (Raspberry Pi, AWS Graviton) |

---

## Documentation

Full documentation, tutorials, and the SDK guide are available at **[bmox.io/docs](https://bmox.io/docs)**.

---

<p align="center">
  Free to use · Closed source · © <a href="https://bmox.io">Bmox</a>
</p>
