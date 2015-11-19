after "development:users" do
  task funds: :environment do
    Fund.delete_all
    puts "\nPopulating Funds:"
    User.all.each do |user|
      2.times do
        name = Faker::Company.name

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

      # Create a group fund and it's members.
      group_fund_name = Faker::Company.name
      group_fund = user.funds.create!(
        group_fund:            true,
        name:                  group_fund_name,
        category:              [0,1,2,3,4].sample,
        description:           Faker::Lorem.sentence([10,8,4].sample),
        ends_at:               Date.today + 30.days,
        url:                   group_fund_name.parameterize,
        statement_descriptor:  group_fund_name.parameterize,
        goal:                  10000000
      )
      # Group fund members
      User.where.not(id: group_fund.owner.id).first(2).each do |member|
        group_fund.members << member
      end

      print "."; STDOUT.flush
    end
    print " (#{Fund.count})"; STDOUT.flush
  end
end
