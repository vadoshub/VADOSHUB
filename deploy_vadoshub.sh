#!/bin/bash

# ---------- Variables ----------
PROJECT_DIR=~/VadosHub_Project
GITHUB_USER="vadoshub"
REPO_NAME="VADOSHUB"
BRANCH="main"
RENDER_SERVICE_ID="srv-d339bmadbo4c73b14dhg"
RENDER_API_KEY="YOUR_RENDER_API_KEY"  # Replace with your actual Render API key
RENDER_URL="https://vadoshub.onrender.com"  # Your live app URL

# ---------- Go to project directory ----------
cd $PROJECT_DIR || { echo "Project directory not found"; exit 1; }

# ---------- Git: Add, Commit, Push ----------
git add .
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
git commit -m "Update VadosHub app - $TIMESTAMP" 2>/dev/null
git push https://github.com/$GITHUB_USER/$REPO_NAME.git $BRANCH
echo "✅ Git pushed successfully at $TIMESTAMP"

# ---------- Check Render API ----------
ping -c 1 api.render.com &>/dev/null
if [ $? -eq 0 ]; then
    # ---------- Trigger Render Deploy ----------
    curl -X POST "https://api.render.com/v1/services/$RENDER_SERVICE_ID/deploys" \
    -H "Accept: application/json" \
    -H "Authorization: Bearer $RENDER_API_KEY" \
    -H "Content-Type: application/json" \
    -d '{"clearCache": false}'
    echo "✅ Render deploy triggered successfully!"

    # ---------- Open live URL ----------
    termux-open-url $RENDER_URL
else
    echo "⚠️ Render API is not reachable. Skipping deploy. Check your network or DNS."
fi
