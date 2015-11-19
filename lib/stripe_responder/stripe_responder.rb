module StripeResponder
  class BillingEventLogger
    def initialize(logger = nil)
      @logger = logger || begin
        require 'logger'
        Logger.new($stdout)
      end
    end

    def call(event)
      @logger.info "STRIPE-EVENT: #{event.type} - #{event.id}"
    end
  end

  class StripeAccount
    def call(event)
      case event.type
      when "account.created"
        update_account
      when "account.updated"
        update_account
      end
    end
  end

  class StripeCustomer
    def call(event)
      "Stripe Event: #{event.type}\nEvent Data: #{event.data.inspect}"
      set_stripe_objects(event)
      case event.type
      when "customer.created"
        update_user
      when "customer.updated"
        update_user
      end
    end

    def set_stripe_objects(event)
      @customer_data = event.data.object
    end

    def update_user
      begin
        user = User.find_by(email: @customer_data.email)
        user.update_customer_details_from_webhook(@customer_data)
      rescue ActiveRecord::RecordNotFound => e
        puts "no matching record found"
        # TODO: DO something when we don't have a match.
      end
    end
  end

end
