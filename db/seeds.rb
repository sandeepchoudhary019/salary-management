SEED_COUNT = 10_000
BATCH_SIZE = 1_000

first_names_path = Rails.root.join("db/seeds/first_names.txt")
last_names_path = Rails.root.join("db/seeds/last_names.txt")

unless File.exist?(first_names_path) && File.exist?(last_names_path)
  raise "Missing first_names.txt or last_names.txt in db/seeds/"
end

first_names = File.readlines(first_names_path, chomp: true).map(&:strip).reject(&:empty?)
last_names = File.readlines(last_names_path, chomp: true).map(&:strip).reject(&:empty?)

if first_names.empty? || last_names.empty?
  raise "first_names.txt and last_names.txt must contain at least one name each"
end

seed = ENV.fetch("SEED_RANDOM", "42").to_i
srand(seed)

countries = [
  "India", "USA", "Germany", "Brazil", "Canada",
  "Singapore", "Australia", "UK", "Japan", "UAE"
]

country_to_currency = {
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
}

job_titles = [
  "Software Engineer", "Senior Software Engineer", "Engineering Manager",
  "Product Manager", "Data Analyst", "Data Scientist", "QA Engineer",
  "UX Designer", "DevOps Engineer", "HR Manager", "Finance Manager"
]

departments = [
  "Engineering", "Product", "Data", "Design", "People Operations", "Finance"
]

employment_types = ["full_time", "contract", "part_time"]

started_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)
timestamp = Time.current

puts "Seeding #{SEED_COUNT} employees (seed=#{seed}, batch_size=#{BATCH_SIZE})..."

Employee.transaction do
  Employee.delete_all

  generated_count = 0
  while generated_count < SEED_COUNT
    rows_in_batch = [BATCH_SIZE, SEED_COUNT - generated_count].min
    rows = Array.new(rows_in_batch) do
      country = countries.sample
      {
        full_name: "#{first_names.sample} #{last_names.sample}",
        job_title: job_titles.sample,
        country: country,
        salary_cents: rand(300_000..3_000_000),
        currency: country_to_currency.fetch(country),
        department: departments.sample,
        employment_type: employment_types.sample,
        created_at: timestamp,
        updated_at: timestamp
      }
    end

    Employee.insert_all(rows)
    generated_count += rows_in_batch
  end
end

elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - started_at
puts "Seeded #{Employee.count} employees in #{elapsed.round(2)}s"
