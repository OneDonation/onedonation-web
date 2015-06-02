class CreateFunds < ActiveRecord::Migration
  def change
    create_table :funds do |t|
      t.string :uid
      t.integer :user_id
      t.integer :account_id
      t.string :name
      t.integer :category
      t.text :description
      t.date :ends_at
      t.integer :goal
      t.string :slug
      t.string :statement_descriptor
      t.integer :state
      t.boolean :org_contributions
      t.string :website
      t.string :street
      t.string :apt_suite
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country
      t.text :reciept_message
      t.string :thank_you_reply_to
      t.string :thank_you_subject
      t.text :thank_you_body
      t.string :avatar
      t.string :header
      t.string :primary_color

      t.timestamps
    end

    add_index :funds, :uid, unique: true
    add_index :funds, :slug
    add_index :funds, :user_id
    add_index :funds, :account_id
    add_index :funds, :state

  end
end
