# orders-service

A small Spring Boot orders API with its own PostgreSQL database, used as a **RELAY AEGIS demonstration target**.

It contains one deliberate defect: the database password is hard-coded in
`src/main/java/com/example/orders/config/DatabaseConfig.java`. While the password never changes, nothing is wrong.
When the password is rotated, the running service keeps using the stale value and the database rejects it.

## Run

```powershell
docker compose up -d --build
curl http://localhost:8082/orders
curl http://localhost:8082/actuator/health
```

## The demonstration

1. **Break it.** `./scripts/rotate-db-password.ps1` rotates the database password and restarts the service.
   `/actuator/health` now returns 503 and the logs show `password authentication failed for user "orders"`.
2. **RELAY Runtime** detects the incident, diagnoses rejected credentials, and links the failure to the hard-coded
   credential found in this repository. Restarting would not help, so no runtime action is taken.
3. **RELAY Code** replaces the literal with `System.getenv("DB_PASSWORD")`, validates the change in a sandbox and
   opens a pull request after approval.
4. **A human merges** the pull request, then `./scripts/redeploy.ps1` rebuilds the service with the new password.
5. **RELAY Runtime** sees the service healthy again and records the incident as fixed by that pull request.

`./scripts/reset-demo.ps1` restores the original password. Only use these scripts against this local demo.
