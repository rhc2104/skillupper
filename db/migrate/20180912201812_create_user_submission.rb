class CreateUserSubmission < ActiveRecord::Migration[5.2]
  def change
    create_table :user_submissions do |t|
      t.references :user, index: true, on_delete: :cascade

      t.string :content_name
      t.string :language_name

      t.text :submitted_code

      t.boolean :succeeded

      t.timestamps
    end
  end
end
