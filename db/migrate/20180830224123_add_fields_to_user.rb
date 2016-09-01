class AddFieldsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :country_code, :string
    add_column :users, :interested_in_jobs, :boolean
    add_column :users, :years_of_experience, :string
    add_column :users, :programming_language, :string
  end
end
