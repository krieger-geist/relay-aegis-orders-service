# Pulls the merged fix and redeploys the service with the password from .env.
#   ./scripts/redeploy.ps1
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
Push-Location $root
try {
    git pull --ff-only
    docker compose up -d --build orders-service
    Write-Host "orders-service rebuilt from the current commit and started with DB_PASSWORD from .env."
} finally {
    Pop-Location
}
