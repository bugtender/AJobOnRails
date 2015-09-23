class AddPublishedToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :published, :boolean, :default => true
  end
end
