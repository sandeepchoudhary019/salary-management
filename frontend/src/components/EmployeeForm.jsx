import { useEffect, useMemo, useState } from 'react'

const INITIAL_FORM = {
  full_name: '',
  job_title: '',
  country: '',
  salary_cents: '',
  currency: 'INR',
  department: '',
  employment_type: 'full_time',
}

function EmployeeForm() {
  const [form, setForm] = useState(INITIAL_FORM)
  const [editingId, setEditingId] = useState(null)
  const [error, setError] = useState('')
  const [successMessage, setSuccessMessage] = useState('')

  const title = useMemo(() => (editingId ? 'Update employee' : 'Add employee'), [editingId])

  const handleChange = (event) => {
    const { name, value } = event.target
    setForm((current) => ({ ...current, [name]: value }))
  }

  const clearForm = () => {
    setForm(INITIAL_FORM)
    setEditingId(null)
  }

  const handleSubmit = async (event) => {
    event.preventDefault()
    setError('')
    setSuccessMessage('')

    const payload = { ...form, salary_cents: Number(form.salary_cents) }
    const isEditing = Boolean(editingId)
    const endpoint = isEditing ? `/employees/${editingId}` : '/employees'
    const method = isEditing ? 'PATCH' : 'POST'

    const response = await fetch(endpoint, {
      method,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ employee: payload }),
    })

    const data = await response.json().catch(() => ({}))
    if (!response.ok) {
      setError((data.errors || ['Unable to save employee']).join(', '))
      return
    }

    setSuccessMessage(isEditing ? 'Employee updated.' : 'Employee created.')
    clearForm()
  }

  return (
    <main className="container">
      <header className="header">
        <h1>Add/Edit Employee</h1>
        <p>Create or update employee information.</p>
      </header>

      {error && <p className="message error">{error}</p>}
      {successMessage && <p className="message success">{successMessage}</p>}

      <section className="panel">
        <h2>{title}</h2>
        <form onSubmit={handleSubmit} className="employee-form">
          <label>
            Full name
            <input name="full_name" value={form.full_name} onChange={handleChange} required />
          </label>
          <label>
            Job title
            <input name="job_title" value={form.job_title} onChange={handleChange} required />
          </label>
          <label>
            Country
            <input name="country" value={form.country} onChange={handleChange} required />
          </label>
          <label>
            Salary (cents)
            <input
              name="salary_cents"
              type="number"
              min="1"
              value={form.salary_cents}
              onChange={handleChange}
              required
            />
          </label>
          <label>
            Currency
            <input name="currency" value={form.currency} onChange={handleChange} />
          </label>
          <label>
            Department
            <input name="department" value={form.department} onChange={handleChange} />
          </label>
          <label>
            Employment type
            <select name="employment_type" value={form.employment_type} onChange={handleChange}>
              <option value="full_time">Full-time</option>
              <option value="contract">Contract</option>
              <option value="part_time">Part-time</option>
            </select>
          </label>

          <div className="actions">
            <button type="submit">{editingId ? 'Update' : 'Create'}</button>
            {editingId && (
              <button type="button" className="secondary" onClick={clearForm}>
                Cancel
              </button>
            )}
          </div>
        </form>
      </section>
    </main>
  )
}

export default EmployeeForm
