# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# For now, don't show field with error
# TODO remove to allow inline error displays
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html_tag.html_safe
end
