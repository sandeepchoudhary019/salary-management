# Salary Management

Salary management tool for an organization with 10,000 employees.

## Tech Stack

- Backend: Ruby on Rails
- Frontend: React + Vite
- Database: PostgreSQL

## Local Setup

### Backend (Rails)

```bash
bundle install
bin/rails db:prepare
bin/rails server
```

Runs at `http://localhost:3000`.

### Frontend (React)

```bash
cd frontend
npm install
npm run dev
```

Runs at `http://localhost:5173`.

## Current Status

- Rails app scaffolded in repository root.
- React app scaffolded in `frontend/`.

## Documentation

See `docs/` for detailed project artifacts:

- `docs/architecture.md` — system design and key decisions
- `docs/tradeoffs.md` — skipped items and tradeoff reasoning
- `docs/performance-notes.md` — seed strategy and query choices
