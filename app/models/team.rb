class Team < ActiveRecord::Base
	has_many :addresses, -> { where meta_type: 0 }, class_name: "Metadata", foreign_key: "user_uid"
  has_many :emails, -> { where meta_type: 1 }, class_name: "Metadata", foreign_key: "user_uid"
  has_many :phones, -> { where meta_type: 2 }, class_name: "Metadata", foreign_key: "user_uid"
  has_many :websites, -> { where meta_type: 3 }, class_name: "Metadata", foreign_key: "user_uid"
  has_many :social_accounts, -> { where meta_type: 4 }, class_name: "Metadata", foreign_key: "user_uid"
  has_many :metadata, class_name: "Metadata", foreign_key: "user_uid"
  
	include Tokenable
end
