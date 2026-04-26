require "rails_helper"

RSpec.describe "Insights API", type: :request do
  describe "GET /insights/country/:country" do
    it "returns country salary metrics" do
      Employee.create!(
        full_name: "A One",
        job_title: "Engineer",
        country: "India",
        salary_cents: 1_000_000,
        currency: "INR"
      )
      Employee.create!(
        full_name: "B Two",
        job_title: "Engineer",
        country: "India",
        salary_cents: 2_000_000,
        currency: "INR"
      )

      get "/insights/country/India"

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body).to eq(
        {
          "country" => "India",
          "employee_count" => 2,
          "min_salary_cents" => 1_000_000,
          "max_salary_cents" => 2_000_000,
          "avg_salary_cents" => 1_500_000
        }
      )
    end
  end

  describe "GET /insights/country/:country/job_title/:job_title" do
    it "returns title average metrics in country" do
      Employee.create!(
        full_name: "A One",
        job_title: "Engineer",
        country: "India",
        salary_cents: 1_000_000,
        currency: "INR"
      )
      Employee.create!(
        full_name: "B Two",
        job_title: "Engineer",
        country: "India",
        salary_cents: 2_000_000,
        currency: "INR"
      )
      Employee.create!(
        full_name: "C Three",
        job_title: "Designer",
        country: "India",
        salary_cents: 5_000_000,
        currency: "INR"
      )

      get "/insights/country/India/job_title/Engineer"

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body).to eq(
        {
          "country" => "India",
          "job_title" => "Engineer",
          "employee_count" => 2,
          "avg_salary_cents" => 1_500_000
        }
      )
    end
  end
end
