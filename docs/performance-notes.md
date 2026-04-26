# Performance Notes

This note covers seed strategy, query choices, and current performance considerations.

## Seed Strategy

- Seed data should cover realistic employee distribution across countries, titles, and departments.
- Use `db/seeds.rb` or a custom rake task to generate several thousand records.
- Aim for:
  - multiple countries with mapped currencies
  - a variety of job titles
  - salary ranges that reflect actual business data

### Recommended Seed Approach

- Generate names from the existing `db/seeds/first_names.txt` and `last_names.txt` files.
- Assign country and currency using the same mapping in `Employee` and `SalaryInsightsService`.
- Randomize salary ranges by department or title to produce realistic insights.

## Query Choices

### Employee Listing

- Current query uses `Employee.order(:id)` for deterministic ordering.
- This is easy to implement but not ideal for large datasets.
- Future improvement: order by a stable indexed column and paginate at the database level.

### Insights Queries

- `SalaryInsightsService.country_metrics(country)` uses:
  - `count`
  - `minimum(:salary_cents)`
  - `maximum(:salary_cents)`
  - `average(:salary_cents)`
- `SalaryInsightsService.job_title_average_in_country(...)` uses similar aggregation.
- Aggregations are efficient with proper indexes on `country`, `job_title`, and `salary_cents`.

## Index Strategy

Current schema indexes:

- `country`
- `job_title`
- `country, job_title`
- `salary_cents`

These indexes support insight queries and can aid filter performance.

## Current Performance Tradeoffs

### Client-Side Pagination

- All employees are loaded once and paginated in the browser.
- Good for up to ~10,000 records, but not for 100,000+.
- Payload size and memory usage grow with the dataset.

### Search

- Search is performed client-side on loaded records.
- Fine for the current scale, but database search is required for larger volumes.

### Recommended Improvements

- Add server-side pagination with parameters such as `page` and `per_page`.
- Add server-side search filters for fields like name, title, country, and department.
- Use response compression for API payloads in production.
- Add a caching layer (Redis or similar) for frequently requested insight queries.
