class AddSponsorshipToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sponsorship, :string
  end
end
