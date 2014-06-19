class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string  :uid
      t.string  :name
      t.string	:slug
      t.integer  :owner_id

      t.timestamps
    end

    add_index :teams, :owner_id
    add_index :teams, :slug, unique: true
  end
end
