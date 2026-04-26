class EmployeesController < ActionController::API
  def index
    employees = Employee.order(:id)

    render json: { employees: EmployeeSerializer.as_json_collection(employees) }, status: :ok
  end

  def create
    employee = Employee.new(employee_params)

    if employee.save
      render json: { employee: EmployeeSerializer.as_json(employee) }, status: :created
    else
      render json: { errors: employee.errors.full_messages }, status: :unprocessable_content
    end
  end

  def update
    employee = Employee.find(params[:id])

    if employee.update(employee_params)
      render json: { employee: EmployeeSerializer.as_json(employee) }, status: :ok
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
end
