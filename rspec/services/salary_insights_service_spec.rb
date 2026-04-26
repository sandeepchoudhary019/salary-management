require "rails_helper"

RSpec.describe SalaryInsightsService do
  describe ".country_metrics" do
    it "returns min, max, avg and employee count for a country" do
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
        salary_cents: 3_000_000,
        currency: "INR"
      )
      Employee.create!(
        full_name: "D Four",
        job_title: "Engineer",
        country: "USA",
        salary_cents: 7_000_000,
        currency: "USD"
      )

      metrics = described_class.country_metrics("India")

      expect(metrics).to eq(
        {
          country: "India",
          employee_count: 3,
          min_salary_cents: 1_000_000,
          max_salary_cents: 3_000_000,
          avg_salary_cents: 2_000_000
        }
      )
    end

    it "returns zeroed metrics when country has no employees" do
      metrics = described_class.country_metrics("Japan")

      expect(metrics).to eq(
        {
          country: "Japan",
          employee_count: 0,
          min_salary_cents: nil,
          max_salary_cents: nil,
          avg_salary_cents: nil
        }
      )
    end
  end

  describe ".job_title_average_in_country" do
    it "returns average salary for a title in country" do
      Employee.create!(
        full_name: "Alpha",
        job_title: "Engineer",
        country: "India",
        salary_cents: 1_000_000,
        currency: "INR"
      )
      Employee.create!(
        full_name: "Beta",
        job_title: "Engineer",
        country: "India",
        salary_cents: 2_000_000,
        currency: "INR"
      )
      Employee.create!(
        full_name: "Gamma",
        job_title: "Designer",
        country: "India",
        salary_cents: 9_000_000,
        currency: "INR"
      )

      metrics = described_class.job_title_average_in_country(country: "India", job_title: "Engineer")

      expect(metrics).to eq(
        {
          country: "India",
          job_title: "Engineer",
          employee_count: 2,
          avg_salary_cents: 1_500_000
        }
      )
    end

    it "returns nil average when no matching title exists" do
      metrics = described_class.job_title_average_in_country(country: "India", job_title: "Data Scientist")

      expect(metrics).to eq(
        {
          country: "India",
          job_title: "Data Scientist",
          employee_count: 0,
          avg_salary_cents: nil
        }
      )
    end
  end
end
