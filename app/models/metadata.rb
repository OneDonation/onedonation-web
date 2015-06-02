class Metadata < ActiveRecord::Base
  include Tokenable

  #                                Attributes
  # -----------------------------------------------------------------------------
  # |           Name          |       Type        |         Description         |
  # | ----------------------- | ----------------- | --------------------------- |
  # | : uid                   |     :string       |                             |
  # | : owner_id              |     :integer      |                             |
  # | : name                  |     :string       |                             |
  # | : meta_type             |     :integer      |                             |
  # | : meta_sub_type         |     :integer      |                             |
  # | : custom                |     :string       |                             |
  # | : date                  |     :date         |                             |
  # | : street                |     :string       |                             |
  # | : apt_suite             |     :string       |                             |
  # | : city                  |     :string       |                             |
  # | : state                 |     :string       |                             |
  # | : postal_co             |     :string       |                             |
  # | : country               |     :string       |                             |
  # | : email_address         |     :string       |                             |
  # | : number                |     :string       |                             |
  # | : username              |     :string       |                             |
  # | : value                 |     :string       |                             |
  # -----------------------------------------------------------------------------

  # Enums
  #########################
  enum meta_type: [
    :address,
    :email,
    :phone,
    :website,
    :social_account,
    :date
  ]
  enum meta_sub_type: [
    :custom,
    :home,
    :work,
    :birthday,
    :anniversary,
    :facebook,
    :twitter,
    :linkedin
  ]

  # Relationships
  #########################
  belongs_to :user
  belongs_to :account

  # Scopes
  #########################

  # Validations
  #########################

  # Class Methods
  #########################

end
