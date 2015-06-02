class MarketingController < ApplicationController
	skip_before_action :authenticate_model, :default_breadcrumb
  layout "devise"

	def get_started
	end
end
