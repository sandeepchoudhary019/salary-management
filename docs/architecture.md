# Architecture

## System Design

Salary Management is built as a two-tier application:

- **Backend:** Ruby on Rails API
- **Frontend:** React application served via Vite
- **Database:** PostgreSQL for structured employee data

The Rails backend exposes JSON endpoints for employee CRUD and salary insights. The React frontend consumes those APIs and renders:

- Employee add/edit form
- Employee index with pagination and search
- Salary insights by country and job title

### Data Flow

1. User interacts with React UI
2. React sends requests to Rails API
3. Rails uses ActiveRecord to query PostgreSQL
4. Responses are serialized and returned as JSON
5. React updates state and renders UI

## Key Decisions

### Rails API Backend

- **Why:** Strong productivity, built-in ORM, conventions, and easy JSON rendering.
- **Benefit:** Quick implementation of REST endpoints and model validation.
- **Cost:** Moderate memory usage and request throughput compared to low-level runtimes.

### React + Vite Frontend

- **Why:** Fast developer experience and modern client-side routing.
- **Benefit:** Instant hot reload with Vite, clean component composition.
- **Cost:** Added build dependency and SPA routing complexity.

### PostgreSQL Database

- **Why:** Reliable relational storage for employee records.
- **Benefit:** ACID compliance, indexing support, aggregation functions.
- **Cost:** Single-node scaling limits at very large volumes.

### Serializer Layer

- `EmployeeSerializer` centralizes JSON formatting for the employee model.
- This keeps controller code clean and makes serialization reusable.

### Service Layer for Insights

- `SalaryInsightsService` performs aggregated metrics queries.
- This isolates analytics logic from controller actions.

## Current Architecture Snapshot

- `app/controllers/employees_controller.rb` — RESTful CRUD operations
- `app/controllers/insights_controller.rb` — salary insights endpoints
- `app/serializers/employee_serializer.rb` — employee JSON serialization
- `app/services/salary_insights_service.rb` — aggregated insight queries
- `frontend/src/components/EmployeesList.jsx` — employees page with form, pagination, and search
- `frontend/src/components/SalaryInsights.jsx` — insights page
- `frontend/src/utils/currency.js` — currency formatting helpers

## Future Architectural Notes

- Current UI loads all employees once and paginates in the browser.
- For larger datasets, server-side pagination and search should replace this approach.
- A future architecture can introduce:
  - backend pagination endpoints
  - search endpoints with indexed filters
  - caching layer for frequently requested insight queries
  - authentication/authorization
