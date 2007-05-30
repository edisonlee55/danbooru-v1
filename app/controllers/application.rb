require_dependency 'login_system'

class ApplicationController < ActionController::Base
	include LoginSystem
	include ExceptionNotifiable
	local_addresses.clear

	before_filter :set_title
	before_filter :current_user

	protected
	def api_request?
		@is_api_request == true
	end

	def render_error(record)
		@record = record
		render :status => 500, :layout => "bare", :inline => "<%= error_messages_for('record') %>"
	end

	def set_title(title = CONFIG["app_name"])
		@page_title = title
	end

	def save_tags_to_cookie
		tags = params["tags"] || params["post"]["tags"]
		prev_tags = cookies["recent_tags"].to_s.gsub(/(?:character|char|ch|copyright|copy|artist):/, "").scan(/\S+/)[0..20].join(" ")
		cookies["recent_tags"] = {:value => (tags + " " + prev_tags), :expires => 1.year.from_now}
	end

	public
	def local_request?
		false
	end
end
