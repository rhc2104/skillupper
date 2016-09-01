class ChangeUserSubmissionsIndex < ActiveRecord::Migration[5.2]
  def change
    add_index :user_submissions, [:user_id, :content_name]
    remove_index :user_submissions, :user_id
  end
end
