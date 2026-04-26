class SalaryInsightsService
  def self.country_metrics(country)
    relation = Employee.where(country: country)

    {
      country: country,
      employee_count: relation.count,
      min_salary_cents: relation.minimum(:salary_cents),
      max_salary_cents: relation.maximum(:salary_cents),
      avg_salary_cents: relation.average(:salary_cents)&.to_i
    }
  end

  def self.job_title_average_in_country(country:, job_title:)
    relation = Employee.where(country: country, job_title: job_title)

    {
      country: country,
      job_title: job_title,
      employee_count: relation.count,
      avg_salary_cents: relation.average(:salary_cents)&.to_i
    }
  end
end
