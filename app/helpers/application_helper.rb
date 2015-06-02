module ApplicationHelper
	def title(page_title)
	  content_for(:title) { page_title }
	end

	def sortable_header(name, url, options = {})

		content_tag :th, colspan: options[:colspan], class: options[:classes] do
			link_to url do
				if !params[:sort].present? && name == "Date"
					content_tag(:span, name, class: "") + content_tag(:span, nil, class: "fa fa-text fa-sort-asc")
				elsif params[:sort] == name
					case params[:direction]
					when "asc"
						 content_tag(:span, name, class: "") + content_tag(:span, nil, class: "fa fa-text fa-sort-asc")
					when "desc"
						content_tag(:span, name, class: "") + content_tag(:span, nil, class: "fa fa-text fa-sort-desc")
					else
						content_tag(:span, name, class: "") + content_tag(:span, nil, class: "fa fa-text fa-sort")
					end
				else
					content_tag(:span, name, class: "") + content_tag(:span, nil, class: "fa fa-text fa-sort")
				end
			end
		end
	end

	def sidebar_link(title, url, options = {})
    options.reverse_merge! ({:icon => title.downcase.dasherize})
    if current_page?(url) || controller_name == options[:controller] && action_name == options[:action]
    	css_class = "active #{options[:class]}"
    else
    	css_class = "#{options[:class]}"
   	end
    count =  if options[:count].present? then content_tag(:span, options[:count], class: "badge") else nil end
    content_tag(:li, class: css_class) do
      link_to(content_tag(:span, "", class: options[:icon]) + title + count, url, data: {title: title})
    end
	end

	def tab_class(option, params, default)
		if params[:option].present? && params[:option] == option
			"active"
		elsif !params[:option].present? && option == default
			"active"
		end
	end

	def tab_content_class(option, params, default)
		if params[:option].present? && params[:option] == option
			"active in"
		elsif !params[:option].present? && option == default
			"active in"
		end
	end

  def active_classes(path)
    current_page?(path) ? "active" : nil
  end
end
