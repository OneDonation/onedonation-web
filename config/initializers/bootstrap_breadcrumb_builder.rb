class BootstrapBreadcrumbsBuilder < BreadcrumbsOnRails::Breadcrumbs::Builder
  NoBreadcrumbsPassed = Class.new(StandardError)

  def render
    regular_elements = @elements.dup
    active_element = regular_elements.pop || raise(NoBreadcrumbsPassed)
    if regular_elements.present?
      @context.content_tag(:div, class: 'breadcrumb') do
        links = []
        regular_elements.each_with_index do |element, index|
          if index == 0
            Rails.logger.debug "here"
            links << render_first_element(element)
          else
            links << render_regular_element(element)
          end
        end
        links.join.html_safe + render_active_element(active_element).html_safe
      end
    else
      @context.content_tag(:div, class: 'breadcrumb') do
        render_first_element(active_element).html_safe
      end
    end
  end

  def render_single_element(element)
    # @context.content_tag :li, class: "first" do
      @context.content_tag(:span, nil, class: "fa fa-home")+ compute_name(element)
    # end
  end

  def render_first_element(element)
    # @context.content_tag :li, class: "first" do
      @context.link_to(compute_path(element)) do
        @context.content_tag(:span, nil, class: "fa fa-home #{compute_name(element)}")
      end +  @context.link_to(compute_name(element), compute_path(element), element.options)
    # end
  end

  def render_regular_element(element)
    # @context.content_tag :li do
      @context.link_to(compute_name(element), compute_path(element), element.options)
    # end
  end

  def render_active_element(element)
    @context.content_tag :a, class: 'active' do
      compute_name(element)
    end
  end
end
