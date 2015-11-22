module Stripeable
  extend ActiveSupport::Concern

  included do

    # Customer Actions
    #######################################

    def create_stripe_customer(remote_ip)
      begin
        stripe_customer = Stripe::Customer.create(
                                            email: email,
                                            metadata: {
                                              signup_ip: remote_ip
                                            }
                                          )
        self.update_column(:stripe_customer_id, stripe_customer.id)
      rescue Stripe::APIError => e
        Rails.logger.debug e.inspect
      end
    end

    def create_stripe_account(user_agent, remote_ip)
      begin
        account_details = {
          managed: true,
          debit_negative_balances: true,
          decline_charge_on: {
            avs_failure: true,
            cvc_failure: true
          },
          default_currency: payout_currency,
          email: email,
          country: entity_type == "company" ? business_country : user_country,
          transfer_schedule: {
            delay_days: 7,
            interval: "daily"
          },
          tos_acceptance: {
            date: DateTime.now.to_i,
            ip: remote_ip,
            user_agent: user_agent
          },
          legal_entity: {
            type: "individual",
            ssn_last_4: ssn_last_4,
            first_name: first_name,
            last_name:  last_name,
            dob: {
              month:  dob_month,
              day:    dob_day,
              year:   dob_year
            },
            address: {
              line1: user_line1,
              line2: user_line2,
              city: user_city,
              state: user_state,
              postal_code: user_postal_code,
              country: user_country
            },
            personal_address: {
              line1: user_line1,
              line2: user_line2,
              city: user_city,
              state: user_state,
              postal_code: user_postal_code,
              country: user_country
            }
          }
        }

        if entity_type == "company"
          account_details.merge(
            legal_entity: {
              type: "company",
              business_name: business_name,
              business_url: business_url,
              business_tax_id: business_tax_id,
              business_vat_id: business_vat_id,
              address: {
                line1: business_line1,
                line2: business_line2,
                city: business_city,
                state: business_state,
                postal_code: business_postal_code,
                country: business_country
              }
            }
          )
        end

        stripe_account = Stripe::Account.create(account_details)
        self.update(
          stripe_account_id: stripe_account.id,
          stripe_secret_key: stripe_account.keys.secret,
          stripe_publishable_key: stripe_account.keys.publishable,
          stripe_legal_entity: stripe_account.legal_entity.to_json,
          stripe_verification: stripe_account.verification.to_json,
          stripe_verification_status: stripe_account.legal_entity.verification.status,
          stripe_tos_acceptance: stripe_account.tos_acceptance.to_json
        )
      rescue Stripe::APIError => e
        Rails.logger.debug e.inspect
      end
    end

    def update_stripe_account(request)
      begin
        stripe_account = Stripe::Account.retrieve(stripe_account_id)
        stripe_account[:legal_entity][:ssn_last_4]                      = ssn_last_4
        stripe_account[:legal_entity][:first_name]                      = first_name
        stripe_account[:legal_entity][:last_name]                       = last_name
        stripe_account[:legal_entity][:dob][:month]                     = dob_month
        stripe_account[:legal_entity][:dob][:day]                       = dob_day
        stripe_account[:legal_entity][:dob][:year]                      = dob_year
        stripe_account[:legal_entity][:address][:line1]                 = user_line1
        stripe_account[:legal_entity][:address][:line2]                 = nil
        stripe_account[:legal_entity][:address][:city]                  = user_city
        stripe_account[:legal_entity][:address][:state]                 = user_state
        stripe_account[:legal_entity][:address][:postal_code]           = user_postal_code
        stripe_account[:legal_entity][:address][:country]               = user_country
        stripe_account[:legal_entity][:personal_address][:line1]        = user_line1
        stripe_account[:legal_entity][:personal_address][:line2]        = nil
        stripe_account[:legal_entity][:personal_address][:city]         = user_city
        stripe_account[:legal_entity][:personal_address][:state]        = user_state
        stripe_account[:legal_entity][:personal_address][:postal_code]  = user_postal_code
        stripe_account[:legal_entity][:personal_address][:country]      = user_country
        stripe_account[:tos_acceptance][:date]                          = DateTime.now.to_i
        stripe_account[:tos_acceptance][:ip]                            = request.remote_ip
        if entity_type == "company"
          stripe_account[:legal_entity][:business_name]                   = business_name
          stripe_account[:legal_entity][:business_url]                    = business_url
          stripe_account[:legal_entity][:business_tax_id]                 = business_tax_id
          stripe_account[:legal_entity][:business_vat_id]                 = business_vat_id
          stripe_account[:legal_entity][:address][:line1]                 = business_line1
          stripe_account[:legal_entity][:address][:line2]                 = nil
          stripe_account[:legal_entity][:address][:city]                  = business_city
          stripe_account[:legal_entity][:address][:state]                 = business_state
          stripe_account[:legal_entity][:address][:postal_code]           = business_postal_code
          stripe_account[:legal_entity][:address][:country]               = business_country
        end
        stripe_account.save
      rescue Stripe::APIError => e
        Rails.logger.debug e.inspect
      end
    end

    def update_customer_details_from_webhook(webhook_data)
      self.update_columns(
        stripe_customer_id: webhook_data.id,
        stripe_default_source: webhook_data.default_source
      )
    end


    def payout_currency
      base_country = entity_type == "company" ? business_country : user_country
      case base_country
      when "US"
        "USD"
      when "CA"
        "CAD"
      when "AU"
        "AUD"
      when "DK"
        "DKK"
      when "NO"
        "DKK"
      when "SE"
        "DKK"
      when "FI"
        "DKK"
      when "CH"
        "CHF"
      when "BR"
        "BRL"
      when "MX"
        "MXN"
      when "JP"
        "JPY"
      when "SG"
        "SGD"
      when "AT"
        "EUR"
      when "BE"
        "EUR"
      when "DE"
        "EUR"
      when "ES"
        "EUR"
      when "FR"
        "EUR"
      when "GB"
        "EUR"
      when "IE"
        "EUR"
      when "IT"
        "EUR"
      when "LU"
        "EUR"
      when "NL"
        "EUR"
      when "PT"
        "EUR"
      end
    end

    def has_stripe_account?
      stripe_account_id.present?
    end
  end
end
