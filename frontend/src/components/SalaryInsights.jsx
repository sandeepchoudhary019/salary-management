import { useState } from 'react'

function SalaryInsights() {
  const [insightsCountry, setInsightsCountry] = useState('India')
  const [insightsJobTitle, setInsightsJobTitle] = useState('Engineer')
  const [countryMetrics, setCountryMetrics] = useState(null)
  const [titleMetrics, setTitleMetrics] = useState(null)
  const [error, setError] = useState('')

  const fetchInsights = async () => {
    setError('')

    try {
      const countryResponse = await fetch(`/insights/country/${encodeURIComponent(insightsCountry)}`)
      if (!countryResponse.ok) throw new Error('Unable to load country insights')
      const countryData = await countryResponse.json()

      const titleResponse = await fetch(
        `/insights/country/${encodeURIComponent(insightsCountry)}/job_title/${encodeURIComponent(insightsJobTitle)}`,
      )
      if (!titleResponse.ok) throw new Error('Unable to load title insights')
      const titleData = await titleResponse.json()

      setCountryMetrics(countryData)
      setTitleMetrics(titleData)
    } catch (requestError) {
      setError(requestError.message)
    }
  }

  return (
    <main className="container">
      <header className="header">
        <h1>Salary Insights</h1>
        <p>Analyze salary data by country and job title.</p>
      </header>

      {error && <p className="message error">{error}</p>}

      <section className="panel">
        <h2>Salary Insights</h2>
        <div className="insights-controls">
          <label>
            Country
            <input value={insightsCountry} onChange={(event) => setInsightsCountry(event.target.value)} />
          </label>
          <label>
            Job title
            <input value={insightsJobTitle} onChange={(event) => setInsightsJobTitle(event.target.value)} />
          </label>
          <button type="button" onClick={fetchInsights}>
            Load insights
          </button>
        </div>

        <div className="insights-grid">
          <article className="insight-card">
            <h3>Country Metrics</h3>
            {countryMetrics ? (
              <ul>
                <li>Employees: {countryMetrics.employee_count}</li>
                <li>Min salary: {countryMetrics.min_salary_cents ?? '-'}</li>
                <li>Max salary: {countryMetrics.max_salary_cents ?? '-'}</li>
                <li>Avg salary: {countryMetrics.avg_salary_cents ?? '-'}</li>
              </ul>
            ) : (
              <p>Load insights to view country metrics.</p>
            )}
          </article>

          <article className="insight-card">
            <h3>Job Title in Country</h3>
            {titleMetrics ? (
              <ul>
                <li>Job title: {titleMetrics.job_title}</li>
                <li>Employees: {titleMetrics.employee_count}</li>
                <li>Avg salary: {titleMetrics.avg_salary_cents ?? '-'}</li>
              </ul>
            ) : (
              <p>Load insights to view title metrics.</p>
            )}
          </article>
        </div>
      </section>
    </main>
  )
}

export default SalaryInsights
