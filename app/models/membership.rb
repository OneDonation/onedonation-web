class Membership < ActiveRecord::Base
	enum permission: [:admin, :member]

  belongs_to :team
  belongs_to :user
end
