namespace :db do
  namespace :populate do

    task all: [:admins, :users, :funds, :donations]

    task admins: :environment do
      Admin.delete_all
      puts "\nPopulating admins:"
      admin = Admin.new(
        name: "Jonathan Simmons",
        email: "jon@jsdev.co",
        password: "access123"
      )
      admin.skip_confirmation!
      admin.save
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

    task funds: :environment do
      Fund.delete_all
      puts "\nPopulating Funds:"
      User.all.each do |user|
        2.times do
          name =    Faker::Company.name

          fund = user.funds.create!(
            name:                  name,
            category:              [0,1,2,3,4].sample,
            description:           Faker::Lorem.sentence([10,8,4].sample),
            ends_at:               Date.today + 30.days,
            url:                   name.parameterize,
            statement_descriptor:  name.parameterize,
            goal:                  10000000
          )
        end
        group_fund_name = Faker::Company.name
        user.funds.create!(
          group_fund:            true,
          name:                  group_fund_name,
          category:              [0,1,2,3,4].sample,
          description:           Faker::Lorem.sentence([10,8,4].sample),
          ends_at:               Date.today + 30.days,
          url:                   group_fund_name.parameterize,
          statement_descriptor:  group_fund_name.parameterize,
          goal:                  10000000
        )
        print "."; STDOUT.flush
      end
      print " (#{Fund.count})"; STDOUT.flush
    end

    task donations: :environment do
      Donation.delete_all
      puts "\nPopulating Donations:"
      Fund.personal.each do |fund|
        owner = fund.owner

        donors =              User.where.not(id: owner.id)
        captured =            [true, false].sample
        paid =                captured
        refunded =            !captured

        [100, 125, 50, 75].sample.times do
          donation = fund.donations.create!(
            recipient_id:     owner.id,
            donor_id:         donors.sample.id,
            charge_id:        Faker::Lorem.characters(10)
          )
        end
        print "."; STDOUT.flush
      end
      Fund.group_fund.each do |fund|
        donors =              User.where.not(id: fund.owner.id)
        captured =            [true, false].sample
        paid =                captured
        refunded =            !captured

        [100, 125, 50, 75].sample.times do
          donation = fund.donations.create!(
            donor_id:         donors.sample.id,
            charge_id:        Faker::Lorem.characters(10)
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
