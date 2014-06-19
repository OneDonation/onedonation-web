class User < ActiveRecord::Base
  include Tokenable
  # Gem Dependencies 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable
  enum gender: [:male, :female]

  # Associations
  has_many :addresses, -> { where meta_type: 0 }, class_name: "Metadata", foreign_key: :owner_id
  has_many :emails, -> { where meta_type: 1 }, class_name: "Metadata", foreign_key: :owner_id
  has_many :phones, -> { where meta_type: 2 }, class_name: "Metadata", foreign_key: :owner_id
  has_many :websites, -> { where meta_type: 3 }, class_name: "Metadata", foreign_key: :owner_id
  has_many :social_accounts, -> { where meta_type: 4 }, class_name: "Metadata", foreign_key: :owner_id
  has_many :dates, -> { where meta_type: 5 }, class_name: "Metadata", foreign_key: :owner_id
  has_many :metadata, class_name: "Metadata"

  has_many :teams, through: :memberships
  has_many :memberships

  # Virtual Attributes
  def name(size)
  	case size
  	when "formal"
  		"#{prefix} #{first_name} #{middle_name} #{last_name} #{suffix}"
  	when "semi-formal"
  		"#{first_name} #{middle_name.present? ? middle_name[0].capitalize+"." : nil} #{last_name}"
  	when "human"
  		"#{first_name} #{last_name}"
  	end
  end
end
