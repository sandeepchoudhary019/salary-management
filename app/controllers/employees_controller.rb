class EmployeesController < ActionController::API
  def index
    employees = Employee.order(:id)

    render json: { employees: employees.map { |employee| serialize_employee(employee) } }, status: :ok
  end

  def create
    employee = Employee.new(employee_params)

    if employee.save
      render json: { employee: serialize_employee(employee) }, status: :created
    else
      render json: { errors: employee.errors.full_messages }, status: :unprocessable_content
    end
  end

  def update
    employee = Employee.find(params[:id])

    if employee.update(employee_params)
      render json: { employee: serialize_employee(employee) }, status: :ok
    else
      render json: { errors: employee.errors.full_messages }, status: :unprocessable_content
    end
  end

  def destroy
    employee = Employee.find(params[:id])
    employee.destroy!

    head :no_content
  end

  private

  def employee_params
    params.require(:employee).permit(
      :full_name,
      :job_title,
      :country,
      :salary_cents,
      :currency,
      :department,
      :employment_type
    )
  end

  def serialize_employee(employee)
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
end
