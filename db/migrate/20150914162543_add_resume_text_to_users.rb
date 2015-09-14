class AddResumeTextToUsers < ActiveRecord::Migration
  def change
    add_column :users, :resume_text, :text
  end
end
