class CreateEmployees < ActiveRecord::Migration[8.1]
  def change
    create_table :employees do |t|
      t.string :full_name, null: false
      t.string :job_title, null: false
      t.string :country, null: false
      t.integer :salary_cents, null: false
      t.string :currency, null: false, default: "USD"
      t.string :department
      t.string :employment_type

      t.timestamps
    end

    add_check_constraint :employees, "salary_cents > 0", name: "employees_salary_cents_positive"
    add_index :employees, :country
    add_index :employees, :job_title
    add_index :employees, :salary_cents
    add_index :employees, [ :country, :job_title ]
  end
end
