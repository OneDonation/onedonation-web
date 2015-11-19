after "development:funds" do
  task donations: :environment do
    Donation.delete_all
    puts "\nPopulating Donations:"
    Fund.personal.each do |fund|
      owner     = fund.owner
      donors    = User.where.not(id: owner.id)
      captured  = [true, false].sample
      paid      = captured
      refunded  = !captured

      [100, 125, 50, 75].sample.times do
        donation = fund.donations.create!(
          amount:        [1000, 50000, 100000, 1000, 10000, 100000].sample,
          recipient_id:  owner.id,
          donor_id:      donors.sample.id,
          charge_id:     Faker::Lorem.characters(10)
        )
      end
      print "."; STDOUT.flush
    end
    Fund.group_fund.each do |fund|
      donors    = User.where.not(id: fund.owner.id)
      captured  = [true, false].sample
      paid      = captured
      refunded  = !captured

      [100, 125, 50, 75].sample.times do
        donation = fund.donations.create!(
          designated_to:  fund.members.sample.id,
          amount:         [1000, 50000, 100000, 1000, 10000, 100000].sample,
          donor_id:       donors.sample.id,
          charge_id:      Faker::Lorem.characters(10)
        )
      end
      print "."; STDOUT.flush
    end
    Donation.all.collect { |d| d.update(created_at: Date.today-rand(90)) }
    print " (#{Donation.count})"; STDOUT.flush
    puts "\n"
  end
end
