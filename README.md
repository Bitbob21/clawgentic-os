# Clawgentic OS Website

Business card and landing page for Clawgentic Founder OS — the autonomous AI platform for NZ solopreneurs.

## Stack
- **Pure HTML/CSS** — no build step, no framework, no friction
- **Fonts:** Inter + JetBrains Mono via Google Fonts
- **Theme:** Blueprint Dark (marine blue, cyan accents, coral highlights)
- **Hosted at:** `/var/www/clawgentic-web/` on `204.168.190.201`

## Quick Start (local dev)
```bash
cd website
python3 -m http.server 8080
open http://localhost:8080
```

## Deployment
Push to `main` → GitHub Actions deploys automatically.

```bash
# Manual deploy
rsync -av website/ root@204.168.190.201:/var/www/clawgentic-web/
nginx -s reload
```

## Sections
- **Hero** — one-command terminal demo
- **Features** — 6 cards: Max, Dashboard, Lightning, Integrations, NZ-First, Privacy
- **What You Get** — OpenClaw stack overview + code preview
- **How it Works** — 4-step installation guide
- **CTA** — GitHub link

## CI/CD
GitHub Actions workflow: `.github/workflows/deploy.yml`
- Triggers on push to `main` when `website/**` changes
- SSH deploys to server via `rsync`

## Secrets Required
```
SERVER_HOST      → 204.168.190.201
SERVER_USER      → root
SERVER_SSH_KEY   → SSH private key with server access
```

## Related
- **Dashboard:** http://204.168.190.201:18901/ (Clawgentic Dashboard)
- **OpenClaw:** https://github.com/openclaw/openclaw
- **Community:** https://discord.gg/clawd
