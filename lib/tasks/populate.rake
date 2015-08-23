namespace :db do
  namespace :populate do

    task all: [:admins, :users, :accounts, :funds, :donations]

    task admins: :environment do
      Admin.delete_all
      puts "\nPopulating admins:"
      Admin.create(
        name: "Jonathan Simmons",
        email: "jon@jsdev.co",
        password: "access123"
      )
      print "."; STDOUT.flush
      print " (#{Admin.count})"; STDOUT.flush
    end

    task users: :environment do
      User.delete_all
      puts "\nPopulating users:"
      user = User.new(
        prefix: "Mr.",
        first_name: "Jonathan",
        middle_name: "David",
        last_name: "Simmons",
        suffix: nil,
        email: "jono@jsdev.co",
        password: "access123"
      )
      user.skip_confirmation!
      user.save!
      5.times do
        user_attributes = {
          prefix:                 Faker::Name.prefix,
          first_name:             Faker::Name.first_name,
          middle_name:            Faker::Name.first_name,
          last_name:              Faker::Name.last_name,
          suffix:                 Faker::Name.suffix,
          age:                    [26,34,28,26,32,47].sample,
          gender:                 ["male", "female"].sample,
          email:                  Faker::Internet.email,
          password:               "password",
        }
        user = User.create!(user_attributes)
        print "."; STDOUT.flush
      end

      print " (#{User.count})"; STDOUT.flush
    end


    task accounts: :environment do
      Account.delete_all
      puts "\nPopulating Accounts:"
      User.all.each do |user|
        account_attributes = {
          business_name: "#{user.first_name} #{user.last_name}",
          owner_id:      user.id,
          current:       true
        }
        account = Account.create!(account_attributes)
        print "."; STDOUT.flush
      end

      print " (#{Account.count})"; STDOUT.flush
    end

    task funds: :environment do
      Fund.delete_all
      puts "\nPopulating Funds:"
      User.all.each do |user|
        2.times do
          account = user.current_account
          name =    Faker::Company.name

          fund = account.funds.create!(
            user_id:               user.id,
            name:                  name,
            category:              [0,1,2,3,4].sample,
            description:           Faker::Lorem.sentence([10,8,4].sample),
            ends_at:               Date.today + 30.days,
            slug:                  name.parameterize,
            statement_descriptor:  name.parameterize,
            street:                Faker::Address.street_address,
            apt_suite:             Faker::Address.secondary_address,
            city:                  Faker::Address.city,
            state:                 Faker::Address.state,
            postal_code:           Faker::Address.zip,
            country:               Faker::Address.country_code,
            goal:                  10000000
          )
        end
        print "."; STDOUT.flush
      end
      print " (#{Fund.count})"; STDOUT.flush
    end

    task donations: :environment do
      Donation.delete_all
      puts "\nPopulating Donations:"
      Fund.all.each do |fund|
        user = fund.user

        donors =              User.where.not(id: user.id)
        captured =            [true, false].sample
        paid =                captured
        refunded =            !captured

        [100, 125, 50, 75].sample.times do
          donation = fund.donations.create!(
            user_id:    user.id,
            donor_id:   donors.sample.id,
            stripe_id:  Faker::Lorem.characters(10)
          )
        end
        print "."; STDOUT.flush
      end
      Donation.all.collect { |d| d.update(created_at: Date.today-rand(90)) }
      print " (#{Donation.count})"; STDOUT.flush
      puts "\n"
    end

  end
end
