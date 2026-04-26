# Tradeoffs

This document explains what was intentionally skipped, why, and what tradeoffs were made.

## Skipped Features

### 1. Full Server-Side Pagination

- **Skipped because:** The current assignment and dataset size make client-side pagination acceptable.
- **Why:** Simpler implementation and faster initial development.
- **Tradeoff:** Higher memory usage in the browser and larger payloads on `/employees`.

### 2. Full-Text Search Engine

- **Skipped because:** Current search requirements are moderate and can be handled with simple field filtering.
- **Why:** Avoids adding Elasticsearch / OpenSearch complexity.
- **Tradeoff:** Search performance may degrade with very large datasets.

### 3. Authentication and Authorization

- **Skipped because:** The app focuses on core CRUD and analytics functionality.
- **Why:** Authentication adds significant scope and integration effort.
- **Tradeoff:** No access control is currently enforced, so the app is not production-ready for sensitive salary data.

### 4. Real-Time Updates

- **Skipped because:** The current user flow is simple enough without WebSockets.
- **Why:** Real-time infrastructure is overkill for this assignment.
- **Tradeoff:** UI does not reflect changes from other users immediately.

### 5. Mobile-First UI Optimization

- **Skipped because:** Initial focus was on functionality and desktop/tablet usability.
- **Why:** Responsive improvements can be added later.
- **Tradeoff:** The table layout can be hard to use on narrow screens.

## Tradeoff Summary

- **Development speed over maximum performance** — Rails + React was chosen to move quickly and keep code maintainable.
- **Simplicity over extensibility** — Client-side search and pagination are easy now but not ideal long-term.
- **Minimal infrastructure over completeness** — No auth, caching, or deployment automation has been added yet.

## What Was Prioritized

- Clear separation between frontend and backend.
- Maintainable and testable code structure.
- Practical performance for the expected workload.
- Documentation of architecture, tradeoffs, and AI usage.
