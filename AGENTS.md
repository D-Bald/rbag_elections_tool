# RBAG Elections - AI Coding Instructions

## Project Overview
Phoenix 1.7 LiveView application for managing elections and voting (Wahlen/Abstimmungen). Built with Elixir 1.14+, PostgreSQL, and deployed via Fly.io. Uses German domain terminology throughout.

## Architecture

### Domain Model (German)
- **Wahl** (Election): Top-level election event with slug-based routing
- **Position** (Position): Votable position within a Wahl (e.g., "Vorstand", "Kassenwart")
- **Option** (Option): Candidate/choice for a Position
- **Abstimmung** (Voting Session): Active voting period for a Position
- **Token**: Voter authentication token (password-like, bcrypt-hashed)
- **Abgabe** (Vote Submission): Individual vote cast during an Abstimmung
- **WahlFreigabe** (Election Authorization): Token approval for participating in specific Wahl
- **Admin**: Election administrators with email/password auth

### Context Organization (Phoenix Contexts)
- `RbagElections.Wahlen`: Election structure (Wahl, Position, Option)
- `RbagElections.Abstimmungen`: Active voting sessions, real-time vote submission
- `RbagElections.Freigabe`: Token authorization workflow (:offen → :erteilt/:abgelehnt)
- `RbagElections.Management`: Admin authentication/management
- Web layer: `RbagElectionsWeb.*` with auth plugs (`AdminAuth`, `TokenAuth`)

### Real-Time Architecture
PubSub topics drive LiveView updates:
- `"abstimmung:#{wahl_slug}"` - Voting session start/end events
- `"abgabe:#{abstimmung_id}"` - Live vote submissions for result aggregation
- `"freigabe:#{wahl_slug}"` - Token approval status changes

Subscribe in LiveView: `RbagElections.Abstimmungen.subscribe(wahl_slug)`

## Dev Container Environment

**Critical**: Running in Docker Compose with separate containers:
- App: `rbag_elections_dev` container (port 4000)
- Database: `postgres-db` container (port 5432)

**Database Connection**: Must use hostname `"postgres-db"` in [config/dev.exs](config/dev.exs), NOT `"localhost"`. The dev container setup requires inter-container networking.

## Development Workflows

### Setup & Running
```bash
mix setup              # Full setup: deps + DB + assets
mix phx.server         # Start server on 0.0.0.0:4000
mix ecto.reset         # Drop + recreate DB
```

### Common Tasks
- **New Migration**: `mix ecto.gen.migration name` → edit → `mix ecto.migrate`
- **Add Context Function**: Follow existing patterns in context modules (e.g., `get_*`, `list_*`, `create_*`)
- **LiveView CRUD**: See `live/token_live/index.ex` for table-based admin interfaces
- **Real-time Features**: Use PubSub subscribe/broadcast pattern from `Abstimmungen` context

### Testing
```bash
mix test               # Runs with auto-created test DB
```

## Development Tools

Always use Tidewave's tools for evaluating code, querying the database, etc.

Use `get_docs` to access documentation and the `get_source_location` tool to find module/function definitions.

## Code Conventions

### Phoenix 1.7 Patterns
- **Function Components**: Use `def` components in `.ex` files (see `CoreComponents`)
- **Verified Routes**: Use `~p"/path"` sigil, not string paths
- **Layouts**: `use Phoenix.Component` in reusable components, `use RbagElectionsWeb, :html` for full helpers

### Context Guidelines
- Contexts are the **only** database access layer - controllers/LiveViews never call `Repo` directly
- Public functions include moduledoc with examples
- Private helpers start with `defp`
- Changesets live in schema modules (e.g., `Wahl.changeset/2`)

### Authentication Patterns
Two separate auth systems (study [admin_auth.ex](lib/rbag_elections_web/admin_auth.ex) and [token_auth.ex](lib/rbag_elections_web/token_auth.ex)):
- **AdminAuth**: BCrypt password, session-based, `/admins/*` routes
- **TokenAuth**: Token value (BCrypt), session-based, voter-facing routes
- Both use `on_mount` hooks for LiveView protection

### Routing Patterns
- Slug-based election routing: `/:wahl_slug/*` for voter-facing paths
- Nested resources: `wahlen/:slug/positionen/:id/optionen/:id`
- LiveView sessions enforce auth via `on_mount` (e.g., `:require_authenticated_admin`)

## Database Schema Notes

### Key Relationships
```
Wahl 1→N Position 1→N Option
Wahl 1→N Abstimmung N→1 Position
Abstimmung 1→N Abgabe N→1 Option
Wahl 1→N WahlFreigabe N→1 Token
```

### Migration Patterns
- Use `timestamp_type: :utc_datetime` (configured in [config.exs](config/config.exs))
- Foreign keys: `references(:table, on_delete: :delete_all)` for cascading deletes
- Indexes on slug fields and foreign keys

## Common Gotchas

1. **Language Mixing**: Domain models use German; avoid translating in schema names
2. **Slug Uniqueness**: Wahl slugs must be unique and URL-safe (validated in schema)
3. **PubSub Broadcasting**: Always broadcast after DB commits to avoid race conditions
4. **LiveView Mount**: Use `connected?(socket)` to avoid expensive queries on initial static render
5. **Token Hashing**: Tokens are hashed like passwords - use `Token.valid_token?/2` for verification

## File Locations
- Contexts: [lib/rbag_elections/](lib/rbag_elections/)
- LiveViews: [lib/rbag_elections_web/live/](lib/rbag_elections_web/live/)
- Controllers: [lib/rbag_elections_web/controllers/](lib/rbag_elections_web/controllers/)
- Migrations: [priv/repo/migrations/](priv/repo/migrations/)
- Components: [lib/rbag_elections_web/components/](lib/rbag_elections_web/components/)

## External Dependencies
- **Bandit**: HTTP server (replaces Cowboy in Phoenix 1.7)
- **Tailwind + ESBuild**: Asset pipeline (installed via Mix tasks)
- **Heroicons**: Icon library (v2.1.1, sparse checkout from GitHub)
