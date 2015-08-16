class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string  :title
      t.text  :description
      t.text  :requirement
      t.string  :job_type
      t.string  :location
      t.integer  :salary_high
      t.integer  :salary_low
      t.string  :company_name
      t.string  :company_url
      t.text  :apply_info
      t.boolean :begginer
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
