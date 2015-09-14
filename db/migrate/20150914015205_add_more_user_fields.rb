class AddMoreUserFields < ActiveRecord::Migration
  def change
    remove_column :users, :name
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :phone_number, :string
    add_column :users, :sex, :string
    add_column :users, :school, :string
    add_column :users, :major, :string
    add_column :users, :year, :string
    add_column :users, :first_hackathon, :boolean
    add_column :users, :hardware, :boolean
    add_column :users, :what_are_you_building, :text
    add_column :users, :what_have_you_build, :text
    add_column :users, :github_username, :string
    add_column :users, :linkedin_url, :string
    add_column :users, :personal_website, :string
    add_column :users, :dietary_restrictions, :string
    add_column :users, :size, :string
    add_column :users, :additional_info, :text
  end
end
