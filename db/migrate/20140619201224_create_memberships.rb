class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.integer :user_id
      t.integer :account_id
      t.integer :permission, default: 1

      t.timestamps
    end

    add_index :memberships, :user_id
    add_index :memberships, :account_id
    add_index :memberships, :permission
  end
end
