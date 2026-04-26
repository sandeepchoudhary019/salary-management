class Employee < ApplicationRecord
  COUNTRY_TO_CURRENCY = {
    "India" => "INR",
    "USA" => "USD",
    "Germany" => "EUR",
    "Brazil" => "BRL",
    "Canada" => "CAD",
    "Singapore" => "SGD",
    "Australia" => "AUD",
    "UK" => "GBP",
    "Japan" => "JPY",
    "UAE" => "AED"
  }.freeze

  before_validation :set_default_currency

  validates :full_name, :job_title, :country, :salary_cents, :currency, presence: true
  validates :salary_cents, numericality: { greater_than: 0 }

  private

  def set_default_currency
    return if currency.present?

    self.currency = COUNTRY_TO_CURRENCY.fetch(country, "USD")
  end
end
