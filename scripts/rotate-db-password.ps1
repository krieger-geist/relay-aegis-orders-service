# Rotates the orders database password, as an operator would after a credential leak.
# The running service still holds the old, hard-coded password, so after its restart the database rejects it.
#   ./scripts/rotate-db-password.ps1                 (generates a new password)
#   ./scripts/rotate-db-password.ps1 -Rotated x  (uses the given one)
param([string]$Rotated = "orders-rotated-" + (Get-Date -Format "yyyyMMddHHmm"))
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot

docker exec orders-postgres psql -U orders -d orders -c "ALTER USER orders WITH PASSWORD '$Rotated';" | Out-Null
if (-not $?) { throw "Could not change the password in orders-postgres." }

# Keep the new password for the next deployment (the .env file is git-ignored).
Set-Content -Path (Join-Path $root ".env") -Value "ORDERS_DB_PASSWORD=$Rotated" -Encoding ascii

# The service reconnects with the credential compiled into it.
docker restart orders-service | Out-Null
Write-Host "Password rotated. orders-service restarted with its hard-coded password; the database will now reject it."
Write-Host "The new password is stored in .env for the redeploy after the code fix."
