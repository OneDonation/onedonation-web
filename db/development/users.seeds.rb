task users: :environment do
  User.delete_all
  puts "\nPopulating users:"
  user.skip_confirmation!
  user.save!
  10.times do |count|
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    user_attributes = {
      prefix:            Faker::Name.prefix,
      first_name:        first_name,
      middle_name:       ('a'..'z').to_a.shuffle[0,1].join,
      last_name:         last_name,
      suffix:            Faker::Name.suffix,
      username:          "#{first_name}#{last_name}",
      age:               [20,18,21,22,30,32,29,26,34,28,26,32,47].sample,
      gender:            ["male", "female"].sample,
      email:             "user#{count+1}@email.com",
      password:          "password",
      ssn_last_4:        rand(10000),
      dob_month:         (1..12).to_a.sample,
      dob_day:           (1..28).to_a.sample,
      dob_year:          (1990..Time.now.year).to_a.sample,
      user_line1:        Faker::Address.street_addres,
      user_line2:        [Faker::Address.secondary_address, nil. nil].sample,
      user_city:         "#{Faker::Address.city_prefix} #{Faker::Address.city_suffix}",
      user_state:        Faker::Address.state,
      user_postal_code:  Faker::Address.postcode,
      user_country:      [Faker::Address.country, "US", "US", "US"].sample,
      if [false, false, false, true, true]
        business_name:          Faker::Company.name
        business_url:           Faker::Internet.url
        business_tax_id:        Faker::Company.ein
        business_vat_id:        Faker::Company.ein
        business_line1:         Faker::Address.street_addres,
        business_line2:         [Faker::Address.secondary_address, nil. nil].sample,
        business_city:          "#{Faker::Address.city_prefix} #{Faker::Address.city_suffix}",
        business_state:         Faker::Address.state,
        business_postal_code:   Faker::Address.postcode,
        business_country:       [Faker::Address.country, "US", "US", "US"].sample
      end
    }
    request = {
      user_agent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36"
      remote_ip: "64.237.80.53"
    }
    user = User.create!(user_attributes)
    user.create_stripe_customer(request)
    user.create_stripe_account(request)
    print "."; STDOUT.flush
  end

  print " (#{User.count})"; STDOUT.flush
end
