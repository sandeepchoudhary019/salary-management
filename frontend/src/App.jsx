import { useEffect, useMemo, useState } from 'react'
import './App.css'

const INITIAL_FORM = {
  full_name: '',
  job_title: '',
  country: '',
  salary_cents: '',
  currency: 'INR',
  department: '',
  employment_type: 'full_time',
}

function App() {
  const [employees, setEmployees] = useState([])
  const [form, setForm] = useState(INITIAL_FORM)
  const [editingId, setEditingId] = useState(null)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const [successMessage, setSuccessMessage] = useState('')

  const title = useMemo(() => (editingId ? 'Update employee' : 'Add employee'), [editingId])

  const loadEmployees = async () => {
    setLoading(true)
    setError('')
    try {
      const response = await fetch('/employees')
      if (!response.ok) throw new Error('Failed to load employees')
      const data = await response.json()
      setEmployees(data.employees || [])
    } catch (requestError) {
      setError(requestError.message)
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    loadEmployees()
  }, [])

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
    loadEmployees()
  }

  const handleEdit = (employee) => {
    setEditingId(employee.id)
    setForm({
      full_name: employee.full_name || '',
      job_title: employee.job_title || '',
      country: employee.country || '',
      salary_cents: String(employee.salary_cents ?? ''),
      currency: employee.currency || 'INR',
      department: employee.department || '',
      employment_type: employee.employment_type || 'full_time',
    })
  }

  const handleDelete = async (employeeId) => {
    setError('')
    setSuccessMessage('')
    const response = await fetch(`/employees/${employeeId}`, { method: 'DELETE' })
    if (!response.ok) {
      setError('Unable to delete employee')
      return
    }

    setSuccessMessage('Employee deleted.')
    loadEmployees()
  }

  return (
    <main className="container">
      <header className="header">
        <h1>Salary Management</h1>
        <p>Manage employees and salary data.</p>
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

      <section className="panel">
        <h2>Employees</h2>
        {loading ? (
          <p>Loading employees...</p>
        ) : (
          <table className="employees-table">
            <thead>
              <tr>
                <th>Name</th>
                <th>Title</th>
                <th>Country</th>
                <th>Salary (cents)</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {employees.map((employee) => (
                <tr key={employee.id}>
                  <td>{employee.full_name}</td>
                  <td>{employee.job_title}</td>
                  <td>{employee.country}</td>
                  <td>{employee.salary_cents}</td>
                  <td className="row-actions">
                    <button type="button" className="secondary" onClick={() => handleEdit(employee)}>
                      Edit
                    </button>
                    <button type="button" className="danger" onClick={() => handleDelete(employee.id)}>
                      Delete
                    </button>
                  </td>
                </tr>
              ))}
              {employees.length === 0 && (
                <tr>
                  <td colSpan={5}>No employees yet.</td>
                </tr>
              )}
            </tbody>
          </table>
        )}
      </section>

      <section className="panel">
        <h2>Salary Insights</h2>
        <p>Insights dashboard will be added in the next commit.</p>
      </section>
    </main>
  )
}

export default App
