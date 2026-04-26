import { Routes, Route, Link } from 'react-router-dom'
import './App.css'
import EmployeesList from './components/EmployeesList'
import SalaryInsights from './components/SalaryInsights'

function App() {
  return (
    <>
      <nav className="navbar">
        <div className="nav-container">
          <Link to="/" className="nav-brand">
            Salary Management
          </Link>
          <ul className="nav-menu">
            <li>
              <Link to="/" className="nav-link">
                Employees
              </Link>
            </li>
            <li>
              <Link to="/insights" className="nav-link">
                Insights
              </Link>
            </li>
          </ul>
        </div>
      </nav>

      <Routes>
        <Route path="/" element={<EmployeesList />} />
        <Route path="/insights" element={<SalaryInsights />} />
      </Routes>
    </>
  )
}

export default App
