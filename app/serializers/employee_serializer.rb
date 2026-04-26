class EmployeeSerializer
  def self.as_json(employee)
    {
      id: employee.id,
      full_name: employee.full_name,
      job_title: employee.job_title,
      country: employee.country,
      salary_cents: employee.salary_cents,
      currency: employee.currency,
      department: employee.department,
      employment_type: employee.employment_type
    }
  end

  def self.as_json_collection(employees)
    employees.map { |employee| as_json(employee) }
  end
end
