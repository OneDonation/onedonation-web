module TableHelper

  def sortable_header(sort_column, link_text, link_url, options = {})
    content_tag :th, options do
      link_to link_url do
        if !params[:sort].present? && sort_column == default_sort
          content_tag(:span, link_text, class: "") + content_tag(:span, nil, class: "fa fa-text fa-sort-asc")
        elsif params[:sort] == sort_column
          case params[:direction]
          when "asc"
             content_tag(:span, link_text, class: "") + content_tag(:span, nil, class: "fa fa-text fa-sort-asc")
          when "desc"
            content_tag(:span, link_text, class: "") + content_tag(:span, nil, class: "fa fa-text fa-sort-desc")
          end
        else
          content_tag(:span, link_text, class: "") + content_tag(:span, nil, class: "fa fa-text fa-sort")
        end
      end
    end
  end

  def get_sort_direction(direction = "desc")
    direction == "desc" ? "asc" : "desc"
  end

end
