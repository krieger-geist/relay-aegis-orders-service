# Pulls the merged fix and redeploys the service with the password from .env.
#   ./scripts/redeploy.ps1
$root = Split-Path -Parent $PSScriptRoot
Push-Location $root
try {
    # Git writes progress to stderr; judge it by its exit code, not by that output.
    git pull --ff-only 2>&1 | Out-Host
    if ($LASTEXITCODE -ne 0) { throw "git pull failed." }
    docker compose up -d --build orders-service 2>&1 | Out-Host
    if ($LASTEXITCODE -ne 0) { throw "docker compose failed." }
    Write-Host "orders-service rebuilt from the current commit and started with DB_PASSWORD from .env."
} finally {
    Pop-Location
}
