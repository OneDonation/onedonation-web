module Admin::UsersHelper
  def entity_name(user)
    case user.account_type
    when 'donor', 'individual'
      user.name('human')
    when 'company'
      user.business_name
    end
  end

  def entity_address(user)
    case user.account_type
    when 'individual'
      "#{user.user_line1}<br>#{user.user_line2.present? ? "#{user.user_line2}<br>" : nil}#{user.user_city}, #{user.user_state} #{user.user_postal_code} #{user.user_country}".html_safe
    when 'company'
      "#{user.business_line1}<br>#{user.business_line2.present? ? "#{user.business_line2}<br>" : nil}#{user.business_city}, #{user.business_state} #{user.business_postal_code} #{user.business_country}".html_safe
    end
  end
end
