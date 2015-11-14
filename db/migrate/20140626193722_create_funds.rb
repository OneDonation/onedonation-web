class CreateFunds < ActiveRecord::Migration
  def change
    create_table :funds do |t|
      t.string  :uid
      t.integer :owner_id
      t.boolean :group_fund, default: false
      t.string  :name
      t.string  :url
      t.integer :category
      t.integer :status
      t.date    :ends_at
      t.integer :goal
      t.string  :statement_descriptor
      t.text    :description
      t.string  :website
      t.text    :receipt_message
      t.string  :thank_you_reply_to
      t.string  :thank_you_subject
      t.text    :thank_you_body
      t.string  :thumbnail
      t.string  :header
      t.string  :primary_color

      t.timestamps
    end

    add_index :funds, :uid, unique: true
    add_index :funds, :url
    add_index :funds, :owner_id
    add_index :funds, :status

  end
end
