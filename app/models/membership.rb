class Membership < ActiveRecord::Base

  #                                Attributes
  # -----------------------------------------------------------------------------
  # |           Name          |       Type        |         Description         |
  # | ----------------------- | ----------------- | --------------------------- |
  # | :user_id                |     :integer      |                             |
  # | :fund_id                |     :integer      |                             |
  # -----------------------------------------------------------------------------

  # Enums
  #########################
  enum permission: {
    admin: 0,
    member: 1
  }

  # Relationships
  #########################
  belongs_to :fund
  belongs_to :user

  # Scopes
  #########################

  # Validations
  #########################
  validates_uniqueness_of :user_id, scope: :fund_id

  # Class Methods
  #########################

end
