class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string  :uid
      t.string  :name
      t.string	:slug
      t.string  :owner_uid

      t.timestamps
    end

    add_index :teams, :owner_uid
    add_index :teams, :slug, unique: true
  end
end
