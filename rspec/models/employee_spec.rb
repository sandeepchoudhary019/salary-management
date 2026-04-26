require "rails_helper"

RSpec.describe Employee, type: :model do
  subject(:employee) do
    described_class.new(
      full_name: "Jane Doe",
      job_title: "Software Engineer",
      country: "India",
      salary_cents: 1_500_000,
      currency: "INR",
      department: "Engineering",
      employment_type: "full_time"
    )
  end

  it "is valid with required attributes" do
    expect(employee).to be_valid
  end

  it "is invalid without full_name" do
    employee.full_name = nil

    expect(employee).not_to be_valid
    expect(employee.errors[:full_name]).to include("can't be blank")
  end

  it "is invalid without job_title" do
    employee.job_title = nil

    expect(employee).not_to be_valid
    expect(employee.errors[:job_title]).to include("can't be blank")
  end

  it "is invalid without country" do
    employee.country = nil

    expect(employee).not_to be_valid
    expect(employee.errors[:country]).to include("can't be blank")
  end

  it "is invalid without salary_cents" do
    employee.salary_cents = nil

    expect(employee).not_to be_valid
    expect(employee.errors[:salary_cents]).to include("can't be blank")
  end

  it "is invalid when salary_cents is not positive" do
    employee.salary_cents = 0

    expect(employee).not_to be_valid
    expect(employee.errors[:salary_cents]).to include("must be greater than 0")
  end
end
