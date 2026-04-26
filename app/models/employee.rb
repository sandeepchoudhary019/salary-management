class Employee < ApplicationRecord
  validates :full_name, :job_title, :country, :salary_cents, presence: true
  validates :salary_cents, numericality: { greater_than: 0 }
end
