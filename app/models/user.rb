class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable
  enum gender: [:male, :female]

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
