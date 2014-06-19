class CreateMetadata < ActiveRecord::Migration
  def change
    create_table :metadata do |t|
    	t.string 	:uid
    	t.string  :user_uid
    	t.string 	:name
    	t.integer :meta_type
    	t.integer :meta_sub_type
    	t.string  :custom
    	t.date		:date
    	t.string	:street
    	t.string	:apt_suite
    	t.string	:city
    	t.string	:state
    	t.string	:postal_code
    	t.string	:country
    	t.string	:email_address
    	t.string  :number
    	t.string  :username
    	t.string  :value

      t.timestamps
    end

    add_index :metadata, :uid,                unique: true
    add_index :metadata, :meta_type
    add_index :metadata, :meta_sub_type
    add_index :metadata, :email_address
    add_index :metadata, :number
    add_index :metadata, :username
  end
end
