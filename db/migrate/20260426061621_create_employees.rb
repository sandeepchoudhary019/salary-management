class CreateEmployees < ActiveRecord::Migration[8.1]
  def change
    create_table :employees do |t|
      t.string :full_name
      t.string :job_title
      t.string :country
      t.integer :salary_cents
      t.string :currency
      t.string :department
      t.string :employment_type

      t.timestamps
    end
  end
end
