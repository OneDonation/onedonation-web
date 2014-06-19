class UserMeta < ActiveRecord::Base
	enum meta_type: [:address, :email, :phone, :website, :social_account, :date]
	enum meta_sub_type: [:custom, :home, :work, :birthday, :anniversary, :facebook, :twitter, :linkedin]

	belongs_to :user
end
