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
      3.times do |count|
        first_name = Faker::Name.first_name
        last_name = Faker::Name.last_name
        addresses = [
          {
            line1: "39476 Oceanview Ave",
            line2: nil,
            city: "Prairieville",
            state: "La",
            postal_code: "70769",
            country: "US"
          },
          {
            line1: "5 Valadon Pl",
            line2: nil,
            city: "Baulkham Hills",
            state: "NSW",
            postal_code: "2153",
            country: "AU"
          },
          {
            line1: "19202 Highland Rd",
            line2: nil,
            city: "Baton Rouge",
            state: "La",
            postal_code: "70809",
            country: "US"
          }
        ]
        user_attributes = {
          account_type:       1,
          prefix:            Faker::Name.prefix,
          first_name:        first_name,
          middle_name:       ('a'..'z').to_a.shuffle[0,1].join,
          last_name:         last_name,
          suffix:            Faker::Name.suffix,
          username:          "#{first_name}#{last_name}".downcase,
          age:               [20,18,21,22,30,32,29,26,34,28,26,32,47].sample,
          gender:            ["male", "female"].sample,
          email:             "user#{count+1}@email.com",
          password:          "password",
          # ssn_last_4:        rand(1000..9999),
          dob_month:         (1..12).to_a.sample,
          dob_day:           (1..28).to_a.sample,
          dob_year:          (1900..1997).to_a.sample,
          user_line1:        addresses[count][:line1],
          user_line2:        addresses[count][:line2],
          user_city:         addresses[count][:city],
          user_state:        addresses[count][:state],
          user_postal_code:  addresses[count][:postal_code],
          user_country:      addresses[count][:country]
        }

        if count == 2
          user_attributes = user_attributes.merge(
            account_type:            2,
            business_name:          Faker::Company.name,
            business_url:           Faker::Internet.url,
            business_tax_id:        Faker::Company.ein,
            business_vat_id:        Faker::Company.ein,
            business_line1:         addresses[count][:line1],
            business_line2:         addresses[count][:line2],
            business_city:          addresses[count][:city],
            business_state:         addresses[count][:state],
            business_postal_code:   addresses[count][:postal_code],
            business_country:       addresses[count][:country]
          )
        end

        user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36"
        remote_ip = "64.237.80.53"

        user = User.new(user_attributes)
        user.stripe_currency = user.payout_currency
        user.skip_confirmation!
        user.save!
        user.create_stripe_customer(remote_ip)
        user.create_stripe_account(user_agent, remote_ip)

        customer = Stripe::Customer.retrieve(user.stripe_customer_id)
        card = customer.sources.create(
          source: {
            object: "card",
            number: [4242424242424242,5555555555554444].sample,
            exp_month: 03,
            exp_year: 18,
            cvc: [234,857,239],
            name: "#{user.first_name} #{user.last_name}",
            address_line1: user.user_line1,
            address_line2: user.user_line2,
            address_city: user.user_city,
            address_state: user.user_state,
            address_zip: user.user_postal_code,
            address_country: user.user_country
          }
        )
        user.update(stripe_default_source: card.id)
        print "."; STDOUT.flush
      end

      5.times do |count|
        first_name = Faker::Name.first_name
        last_name = Faker::Name.last_name
        user_attributes = {
          account_type:       0,
          prefix:            Faker::Name.prefix,
          first_name:        first_name,
          middle_name:       ('a'..'z').to_a.shuffle[0,1].join,
          last_name:         last_name,
          suffix:            Faker::Name.suffix,
          username:          "#{first_name}#{last_name}".downcase,
          age:               [20,18,21,22,30,32,29,26,34,28,26,32,47].sample,
          gender:            ["male", "female"].sample,
          email:             "donor#{count+1}@email.com",
          password:          "password"
        }

        user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36"
        remote_ip = "64.237.80.53"

        user = User.new(user_attributes)
        user.skip_confirmation!
        user.save!
        user.create_stripe_customer(remote_ip)
        customer = Stripe::Customer.retrieve(user.stripe_customer_id)
        card = customer.sources.create(
          source: {
            object: "card",
            number: [4242424242424242,5555555555554444].sample,
            exp_month: 03,
            exp_year: 18,
            cvc: [234,857,239],
            name: "#{user.first_name} #{user.last_name}"
          }
        )
        user.update(stripe_default_source: card.id)
        print "."; STDOUT.flush
      end

      print " (#{User.count})"; STDOUT.flush
    end


    task funds: :environment do
      Fund.delete_all
      puts "\nPopulating Funds:"
      User.non_donors.each do |user|
        2.times do
          name = Faker::Company.name

          fund = user.funds.create!(
            name:                         name,
            category:                     [0,1,2,3,4].sample,
            description:                  Faker::Lorem.sentence([10,8,4].sample),
            ends_at:                      Date.today + 30.days,
            url:                          name.parameterize,
            custom_statement_descriptor:  name.parameterize,
            goal:                         10000000
          )
        end

        # Create a group fund and it's members.
        group_fund_name = Faker::Company.name
        group_fund = user.funds.create!(
          group_fund:                   true,
          name:                         group_fund_name,
          category:                     [0,1,2,3,4].sample,
          description:                  Faker::Lorem.sentence([10,8,4].sample),
          ends_at:                      Date.today + 30.days,
          url:                          group_fund_name.parameterize,
          custom_statement_descriptor:  group_fund_name.parameterize,
          goal:                         10000000
        )
        # Group fund members
        User.where.not(id: group_fund.owner.id).where.not(account_type: 0).first(2).each do |member|
          group_fund.members << member
        end

        print "."; STDOUT.flush
      end
      print " (#{Fund.count})"; STDOUT.flush
    end

    task donations: :environment do
      Donation.delete_all
      puts "\nPopulating Donations:"
      Fund.personal.each do |fund|
        owner     = fund.owner
        donors    = User.where.not(id: owner.id)

        20.times do
          donor     = donors.sample
          currency  = owner.stripe_currency
          amount    = [100, 5, 200, 500, 1000, 10, 100, 100, 20, 15, 10, 5, 5].sample
          if currency == "USD"
            # Convert amount to cents
            amount_in_cents = amount * 100
            amount_in_cents_usd = amount_in_cents
            # find application fee in cents usd
            stripe_fee_in_cents_usd       = Money.new((amount_in_cents_usd * 0.029) + 30, "USD").cents
            od_fee_in_cents_usd           = Money.new(amount_in_cents_usd * 0.05, "USD").cents
            application_fee_in_cents_usd  = Money.new(stripe_fee_in_cents_usd + od_fee_in_cents_usd, "USD").cents
            received_in_cents_usd         = Money.new(amount_in_cents_usd - application_fee_in_cents_usd, "USD").cents

            # convert back to starting currency
            stripe_fee_in_cents       = stripe_fee_in_cents_usd
            od_fee_in_cents           = od_fee_in_cents_usd
            application_fee_in_cents  = application_fee_in_cents_usd
            received_in_cents         = received_in_cents_usd

            puts "charge is #{Money.new(amount_in_cents, "USD").format} in #{currency} (#{Money.new(amount_in_cents_usd, "USD").format} USD)"
            puts "application fee: #{Money.new(application_fee_in_cents, "USD").format} USD"
          else
            # Non US currency apply exchange rates to determine fees.
            # Convert amount to cents
            amount_in_cents = amount * 100
            # convert cents to cents in USD
            amount_in_cents_usd = Money.new(amount_in_cents, currency).exchange_to("USD").cents
            # find application fee in cents usd
            stripe_fee_in_cents_usd       = Money.new((amount_in_cents_usd * 0.029) + 30, "USD").cents
            od_fee_in_cents_usd           = Money.new(amount_in_cents_usd * 0.05, "USD").cents
            application_fee_in_cents_usd  = Money.new(stripe_fee_in_cents_usd + od_fee_in_cents_usd, "USD").cents
            received_in_cents_usd         = Money.new(amount_in_cents_usd - application_fee_in_cents_usd, "USD").cents

            # convert back to starting currency
            stripe_fee_in_cents       = Money.new(stripe_fee_in_cents_usd, "USD").exchange_to(currency).cents
            od_fee_in_cents           = Money.new(od_fee_in_cents_usd, "USD").exchange_to(currency).cents
            application_fee_in_cents  = Money.new(application_fee_in_cents_usd, "USD").exchange_to(currency).cents
            received_in_cents         = Money.new(received_in_cents_usd, "USD").exchange_to(currency).cents

            puts "charge is #{Money.new(amount_in_cents, currency).format} in #{currency} (#{Money.new(amount_in_cents_usd, "USD").format} USD)"
            puts "application fee: #{Money.new(application_fee_in_cents, currency).format} in #{currency} (#{Money.new(application_fee_in_cents_usd, "USD").format} USD)"
          end
          stripe_donation = Stripe::Charge.create(
            amount:           amount_in_cents,
            currency:         currency,
            customer:         donor.stripe_customer_id,
            source:           donor.stripe_default_source,
            description:      "Donation to #{owner.name("human")}",
            application_fee:  application_fee_in_cents,
            destination:      owner.stripe_account_id,
            expand:           ['balance_transaction']
          )
          donation = fund.donations.create!(
            recipient_id:                 owner.id,
            donor_id:                     donor.id,
            amount_in_cents:              amount_in_cents,
            stripe_fee_in_cents:          stripe_fee_in_cents,
            onedonation_fee_in_cents:     od_fee_in_cents,
            aggregated_fee_in_cents:      application_fee_in_cents,
            received_in_cents:            received_in_cents,
            amount_in_cents_usd:          amount_in_cents_usd,
            stripe_fee_in_cents_usd:      stripe_fee_in_cents_usd,
            onedonation_fee_in_cents_usd: od_fee_in_cents_usd,
            aggregated_fee_in_cents_usd:  application_fee_in_cents_usd,
            received_in_cents_usd:        received_in_cents_usd,
            stripe_customer_id:           stripe_donation.customer,
            stripe_charge_id:             stripe_donation.id,
            stripe_source_id:             stripe_donation.source.id,
            stripe_destination:           stripe_donation.destination,
            stripe_amount_refunded:       stripe_donation.amount_refunded,
            stripe_application_fee_id:    stripe_donation.application_fee,
            stripe_balance_transaction:   stripe_donation.balance_transaction.to_json,
            stripe_captured:              stripe_donation.captured,
            stripe_created:               stripe_donation.created,
            stripe_currency:              stripe_donation.currency,
            stripe_description:           stripe_donation.description,
            stripe_dispute:               stripe_donation.dispute.to_json,
            stripe_failure_code:          stripe_donation.failure_code,
            stripe_failure_message:       stripe_donation.failure_message,
            stripe_fraud_details:         stripe_donation.fraud_details.to_json,
            stripe_metadata:              stripe_donation.metadata.to_json,
            stripe_paid:                  stripe_donation.paid,
            stripe_receipt_number:        stripe_donation.receipt_number,
            stripe_refunded:              stripe_donation.refunded,
            stripe_refunds:               stripe_donation.refunds.to_json,
            stripe_source:                stripe_donation.source.to_json,
            stripe_statement_descriptor:  stripe_donation.statement_descriptor,
            stripe_status:                stripe_donation.status
          )
          print "."; STDOUT.flush
        end
      end
      Fund.group_fund.each do |fund|
        owner     = fund.owner
        donors    = User.where.not(id: owner.id).where.not(id: fund.members.pluck(:id))

        10.times do
          donor     = donors.sample
          currency  = owner.stripe_currency
          amount    = [100, 5, 200, 500, 1000, 10, 100, 100, 20, 15, 10, 5, 5].sample
          if currency == "USD"
            # Convert amount to cents
            amount_in_cents = amount * 100
            amount_in_cents_usd = amount_in_cents
            # find application fee in cents usd
            stripe_fee_in_cents_usd       = Money.new((amount_in_cents_usd * 0.029) + 30, "USD").cents
            od_fee_in_cents_usd           = Money.new(amount_in_cents_usd * 0.05, "USD").cents
            application_fee_in_cents_usd  = Money.new(stripe_fee_in_cents_usd + od_fee_in_cents_usd, "USD").cents
            received_in_cents             = Money.new(amount_in_cents_usd - application_fee_in_cents_usd, "USD").cents

            # convert back to starting currency
            stripe_fee_in_cents       = stripe_fee_in_cents_usd
            od_fee_in_cents           = od_fee_in_cents_usd
            application_fee_in_cents  = application_fee_in_cents_usd
            received_in_cents_usd     = received_in_cents_usd

            puts "charge is #{Money.new(amount_in_cents, "USD").format} in #{currency} (#{Money.new(amount_in_cents_usd, "USD").format} USD)"
            puts "application fee: #{Money.new(application_fee_in_cents, "USD").format} USD"
          else
            # Non US currency apply exchange rates to determine fees.
            # Convert amount to cents
            amount_in_cents = amount * 100
            # convert cents to cents in USD
            amount_in_cents_usd = Money.new(amount_in_cents, currency).exchange_to("USD").cents
            # find application fee in cents usd
            stripe_fee_in_cents_usd       = Money.new((amount_in_cents_usd * 0.029) + 30, "USD").cents
            od_fee_in_cents_usd           = Money.new(amount_in_cents_usd * 0.05, "USD").cents
            application_fee_in_cents_usd  = Money.new(stripe_fee_in_cents_usd + od_fee_in_cents_usd, "USD").cents
            received_in_cents_usd         = Money.new(amount_in_cents_usd - application_fee_in_cents_usd, "USD").cents

            # convert back to starting currency
            stripe_fee_in_cents       = Money.new(stripe_fee_in_cents_usd, "USD").exchange_to(currency).cents
            od_fee_in_cents           = Money.new(od_fee_in_cents_usd, "USD").exchange_to(currency).cents
            application_fee_in_cents  = Money.new(application_fee_in_cents_usd, "USD").exchange_to(currency).cents
            received_in_cents         = Money.new(received_in_cents_usd, "USD").exchange_to(currency).cents

            puts "charge is #{Money.new(amount_in_cents, currency).format} in #{currency} (#{Money.new(amount_in_cents_usd, "USD").format} USD)"
            puts "application fee: #{Money.new(application_fee_in_cents, currency).format} in #{currency} (#{Money.new(application_fee_in_cents_usd, "USD").format} USD)"
          end
          stripe_donation = Stripe::Charge.create(
            amount:           amount_in_cents,
            currency:         currency,
            customer:         donor.stripe_customer_id,
            source:           donor.stripe_default_source,
            description:      "Donation to #{owner.name("human")}",
            application_fee:  application_fee_in_cents,
            destination:      owner.stripe_account_id,
            expand:           ['balance_transaction']
          )
          donation = fund.donations.create!(
            recipient_id:                 owner.id,
            donor_id:                     donor.id,
            amount_in_cents:              amount_in_cents,
            stripe_fee_in_cents:          stripe_fee_in_cents,
            onedonation_fee_in_cents:     od_fee_in_cents,
            aggregated_fee_in_cents:      application_fee_in_cents,
            received_in_cents:            received_in_cents,
            amount_in_cents_usd:          amount_in_cents_usd,
            stripe_fee_in_cents_usd:      stripe_fee_in_cents_usd,
            onedonation_fee_in_cents_usd: od_fee_in_cents_usd,
            aggregated_fee_in_cents_usd:  application_fee_in_cents_usd,
            received_in_cents_usd:        received_in_cents_usd,
            stripe_customer_id:           stripe_donation.customer,
            stripe_charge_id:             stripe_donation.id,
            stripe_source_id:             stripe_donation.source.id,
            stripe_destination:           stripe_donation.destination,
            stripe_amount_refunded:       stripe_donation.amount_refunded,
            stripe_application_fee_id:    stripe_donation.application_fee,
            stripe_balance_transaction:   stripe_donation.balance_transaction.to_json,
            stripe_captured:              stripe_donation.captured,
            stripe_created:               stripe_donation.created,
            stripe_currency:              stripe_donation.currency,
            stripe_description:           stripe_donation.description,
            stripe_dispute:               stripe_donation.dispute.to_json,
            stripe_failure_code:          stripe_donation.failure_code,
            stripe_failure_message:       stripe_donation.failure_message,
            stripe_fraud_details:         stripe_donation.fraud_details.to_json,
            stripe_metadata:              stripe_donation.metadata.to_json,
            stripe_paid:                  stripe_donation.paid,
            stripe_receipt_number:        stripe_donation.receipt_number,
            stripe_refunded:              stripe_donation.refunded,
            stripe_refunds:               stripe_donation.refunds.to_json,
            stripe_source:                stripe_donation.source.to_json,
            stripe_statement_descriptor:  stripe_donation.statement_descriptor,
            stripe_status:                stripe_donation.status
          )
          print "."; STDOUT.flush
        end
      end
      print " (#{Donation.count})"; STDOUT.flush
      puts "\n"
    end

  end
end
