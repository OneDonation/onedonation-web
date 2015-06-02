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
      set_stripe_objects(event)
      case event.type
      when "customer.created"
        update_user
      when "customer.updated"
        update_user
      end
    end

    def set_stripe_objects(event)
      @customer = event.data.object
      @subscription = @customer.subscriptions.first if @customer.subscriptions.total_count > 0
    end

    def update_user
      user = User.find_by(email: @customer.email)
      if user.present?
        user.stripe_subscription_id = @subscription.id if @subscription.present?
        user.stripe_default_source = @customer.default_source
        user.save
      end
    end
  end

  class StripeSubscription
    def call(event)
      get_subscription(event)
      case event.type
      when "customer.subscription.created"
        update_account
      when "customer.subscription.updated"
        update_account
      when "customer.subscription.deleted"
        # TODO: do Something when subscription is deleted.
      end
    end

    def get_subscription(event)
      @subscription = event.data.object
      @customer = Stripe::Customer.retrieve(@subscription.customer)
    end

    def update_account
      Account.find(@customer.metadata.account_id).update(
        stripe_plan_id: @subscription.plan.id,
        stripe_billing_email: @customer.email,
        stripe_status: @subscription.status
      )
    end
  end
end
