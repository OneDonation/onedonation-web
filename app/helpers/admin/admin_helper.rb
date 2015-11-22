module Admin::AdminHelper

  def sort_direction
    params[:direction] == "desc" ? "asc" : "desc"
  end

  def sort_icon
    params[:direction] == "desc" ? icon("sort-desc") : icon("sort-asc")
  end

  def th_sort(name, sort, default_sort)
    if params[:sort] == sort || default_sort == sort && params[:sort].nil?
      content_tag :span, "#{name} #{sort_icon}".html_safe
    else
      content_tag :span, "#{name} #{icon("sort")}".html_safe
    end
  end

  def nav_active_classes(method)
    "active" if method
  end

  def admin_dashboard_page?
    controller_name == "admins" &&
    action_name == "dashboard"
  end

  def user_page?
    controller_name == "users"
  end
end
