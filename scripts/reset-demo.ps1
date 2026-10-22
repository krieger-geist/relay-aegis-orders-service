# Puts the demo back to its starting point: the original password in the database and in .env.
# It does not touch the Git history; to replay the code fix, check out the commit before the fix first.
#   ./scripts/reset-demo.ps1
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$original = "orders-demo-2026"
docker exec orders-postgres psql -U orders -d orders -c "ALTER USER orders WITH PASSWORD '$original';" | Out-Null
Set-Content -Path (Join-Path $root ".env") -Value "ORDERS_DB_PASSWORD=$original" -Encoding ascii
docker restart orders-service | Out-Null
Write-Host "Database password reset; orders-service restarted."
