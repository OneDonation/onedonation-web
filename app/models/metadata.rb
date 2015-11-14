class Metadata < ActiveRecord::Base

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
  include Tokenable

  # Enums
  #########################
  enum meta_type: {
    address: 0,
    email: 1,
    phone: 2,
    website: 3,
    social_account: 4,
    date: 5
  }
  enum meta_sub_type: {
    custom: 0,
    home: 1,
    work: 2,
    birthday: 3,
    anniversary: 4,
    facebook: 5,
    twitter: 6,
    linkedin: 7
  }

  # Relationships
  #########################
  belongs_to :user

  # Scopes
  #########################

  # Validations
  #########################

  # Class Methods
  #########################

end
