class ApplicationController < ActionController::Base
  helper ApplicationHelper

  before_action :redirect_subdomain
  before_action :redirect_to_https

  before_action :store_user_location!, if: :storable_location?
  before_action :load_user_data

  def redirect_subdomain
    if request.host == 'www.skillupper.com'
      redirect_to 'https://skillupper.com' + request.fullpath, status: 301
    end
  end

  def redirect_to_https
    redirect_to protocol: 'https://' unless (request.ssl? || request.local?)
  end

  protected  

  def load_user_data
    @programming_language = user_signed_in? ? current_user.programming_language : nil
    content_name = UrlToName.content_name(request)
    @content_data = ContentData.get_instance(UrlToName.content_name(request))

    @base64_last_code = nil
    @base64_previous_step_code = nil
    if user_signed_in? && content_name
      last_submission = current_user.user_submissions.where(content_name: content_name).last
      if last_submission
        @base64_last_code = Base64.strict_encode64(last_submission.submitted_code)
      end
      if @content_data.previous_code_to_show
        last_submission_for_previous_step = current_user.user_submissions.where(content_name: @content_data.previous_code_to_show).last
        if last_submission_for_previous_step
          @base64_previous_step_code = Base64.strict_encode64(last_submission_for_previous_step.submitted_code)
        end
      end
    end
  end

  def after_sign_in_path_for(resource)
    sign_in_url = new_user_session_url
    if request.referer == sign_in_url
      super
    else
      stored_location_for(resource) || request.referer || root_path
    end
  end

  private

  # It's important that the location is NOT stored if:
  # - The request method is not GET (non idempotent)
  # - The request is handled by a Devise controller such as Devise::SessionsController as that could cause an 
  #    infinite redirect loop.
  # - The request is an Ajax request as this can lead to very unexpected behaviour.
  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr? 
  end

  def store_user_location!
    # :user is the scope we are authenticating
    store_location_for(:user, request.fullpath)
  end

end
