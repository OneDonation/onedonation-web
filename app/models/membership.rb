class Membership < ActiveRecord::Base

  #                                Attributes
  # -----------------------------------------------------------------------------
  # |           Name          |       Type        |         Description         |
  # | ----------------------- | ----------------- | --------------------------- |
  # | :user_id                |     :integer      |                             |
  # | :account_id             |     :integer      |                             |
  # -----------------------------------------------------------------------------

  # Enums
  #########################
  enum permission: {
    admin: 0,
    member: 1
  }

  # Relationships
  #########################
  belongs_to :account
  belongs_to :user

  # Scopes
  #########################

  # Validations
  #########################

  # Class Methods
  #########################

end
