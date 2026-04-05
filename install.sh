#!/bin/bash
# ─────────────────────────────────────────────────────────
# Clawgentic Founder OS Installer v1.0
# Location: Wellington, NZ | Engine: OpenClaw 2.x
# ─────────────────────────────────────────────────────────

set -e

echo ""
echo "  ╔═══════════════════════════════════════╗"
echo "  ║   Clawgentic OS — Founder Installer    ║"
echo "  ╚═══════════════════════════════════════╝"
echo ""

# Check for required tools
command -v curl >/dev/null 2>&1 || { echo "curl required. Install: sudo apt install curl"; exit 1; }
command -v git >/dev/null 2>&1 || { echo "git required. Install: sudo apt install git"; exit 1; }

# Detect OS
if [ -f /etc/debian_version ]; then
  PKG_MANAGER="apt-get install -y"
elif [ -f /etc/redhat-release ]; then
  PKG_MANAGER="yum install -y"
else
  echo "⚠️  Unsupported OS. Debian/Ubuntu or RHEL recommended."
  exit 1
fi

# ── Docker check ──────────────────────────────────────────
if ! command -v docker >/dev/null 2>&1; then
  echo "📦 Installing Docker..."
  curl -fsSL https://get.docker.com | sh
  echo "✅ Docker installed"
else
  echo "✅ Docker already present"
fi

# ── Working directory ──────────────────────────────────────
TARGET_DIR="$HOME/clawgentic-os"

if [ -d "$TARGET_DIR" ]; then
  echo ""
  read -p "⚠️  $TARGET_DIR already exists. Pull latest? [Y/n]: " -n 1 -r; echo
  if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    cd "$TARGET_DIR" && git pull
    echo "✅ Updated."
  fi
else
  echo "📁 Creating $TARGET_DIR..."
  mkdir -p "$TARGET_DIR"
  cd "$TARGET_DIR"

  echo "📥 Cloning Clawgentic Core..."
  git clone https://github.com/Bitbob21/clawgentic-os.git . 2>/dev/null || {
    echo "⚠️  Repo not found. Creating from template..."
    mkdir -p "$TARGET_DIR"
  }
fi

cd "$TARGET_DIR"

# ── Configuration ─────────────────────────────────────────
echo ""
echo "  ╔═══════════════════════════════════════╗"
echo "  ║   ⚙️  Configuration                   ║"
echo "  ╚═══════════════════════════════════════╝"
echo ""

# Telegram
TELEGRAM_TOKEN=""
read -p "📱 Telegram Bot Token (from @BotFather): " TELEGRAM_TOKEN

CHAT_ID=""
read -p "📱 Your Telegram Chat ID (from @userinfobot): " CHAT_ID

# API Key
API_KEY=""
echo ""
echo "🔑 LLM Provider:"
select LLM in "Anthropic (Claude)" "OpenAI (GPT-4)" "Google (Gemini)" "Ollama (Local)"; do
  case $LLL in
    "Anthropic (Claude)") API_PROVIDER="anthropic"; break;;
    "OpenAI (GPT-4)") API_PROVIDER="openai"; break;;
    "Google (Gemini)") API_PROVIDER="google"; break;;
    "Ollama (Local)") API_PROVIDER="ollama"; break;;
  esac
done
read -p "🔑 API Key: " API_KEY

# ── Write .env ────────────────────────────────────────────
echo ""
echo "⚙️  Writing configuration..."
cat > "$TARGET_DIR/.env" <<EOF
TELEGRAM_TOKEN=$TELEGRAM_TOKEN
ALLOWED_CHAT_ID=$CHAT_ID
OPENAI_API_KEY=$API_KEY
ANTHROPIC_API_KEY=$API_KEY
API_PROVIDER=$API_PROVIDER
TZ=Pacific/Auckland
BASE_DIR=$TARGET_DIR
EOF

# ── Docker Compose ────────────────────────────────────────
if [ -f docker-compose.yml ]; then
  echo "🚢 Starting containers..."
  docker-compose up -d
elif [ -f Dockerfile ]; then
  echo "🐳 Building and starting..."
  docker build -t clawgentic-os .
  docker run -d --name clawgentic-os \
    --env-file .env \
    -p 18789:18789 \
    -v "$TARGET_DIR:/workspace" \
    clawgentic-os
fi

# ── Done ──────────────────────────────────────────────────
echo ""
echo "  ╔═══════════════════════════════════════╗"
echo "  ║   ✅ SUCCESS — Clawgentic OS Live     ║"
echo "  ╚═══════════════════════════════════════╝"
echo ""
echo "  🌐 Dashboard: http://localhost:18789"
echo "  📱 Telegram: Message your bot with /start"
echo ""
echo "  📋 Logs: docker logs clawgentic-os"
echo "  🛑 Stop:   docker stop clawgentic-os"
echo ""
