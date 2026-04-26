require "rails_helper"

RSpec.describe "Employees API", type: :request do
  let(:valid_attributes) do
    {
      full_name: "John Smith",
      job_title: "Engineering Manager",
      country: "India",
      salary_cents: 2_500_000,
      currency: "INR",
      department: "Engineering",
      employment_type: "full_time"
    }
  end

  describe "GET /employees" do
    it "returns all employees" do
      first_name = "Alice Johnson #{SecureRandom.hex(4)}"
      second_name = "Bob Lee #{SecureRandom.hex(4)}"
      Employee.create!(valid_attributes.merge(full_name: first_name))
      Employee.create!(valid_attributes.merge(full_name: second_name))

      get "/employees"

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      returned_names = body["employees"].map { |employee| employee["full_name"] }
      expect(returned_names).to include(first_name, second_name)
    end
  end

  describe "POST /employees" do
    it "creates an employee with valid params" do
      expect do
        post "/employees", params: { employee: valid_attributes }, as: :json
      end.to change(Employee, :count).by(1)

      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body["employee"]["full_name"]).to eq("John Smith")
    end

    it "returns unprocessable entity for invalid params" do
      invalid = valid_attributes.merge(full_name: nil)

      expect do
        post "/employees", params: { employee: invalid }, as: :json
      end.not_to change(Employee, :count)

      expect(response).to have_http_status(:unprocessable_content)
      body = JSON.parse(response.body)
      expect(body["errors"]).to include("Full name can't be blank")
    end
  end

  describe "PATCH /employees/:id" do
    it "updates an employee" do
      employee = Employee.create!(valid_attributes)

      patch "/employees/#{employee.id}", params: { employee: { job_title: "Director" } }, as: :json

      expect(response).to have_http_status(:ok)
      expect(employee.reload.job_title).to eq("Director")
    end
  end

  describe "DELETE /employees/:id" do
    it "deletes an employee" do
      employee = Employee.create!(valid_attributes)

      expect do
        delete "/employees/#{employee.id}"
      end.to change(Employee, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
