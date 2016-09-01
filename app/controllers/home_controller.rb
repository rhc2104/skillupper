class HomeController < ApplicationController

  def sign_up
    @user = User.create(user_params)
    if @user.valid?
      @user.remember_me = true
      sign_in(@user, scope: :user)
      flash[:notice] = 'The sign up was successful.'
    else
      flash[:alert] = @user.errors.full_messages
    end

    next_path = stored_location_for(:user) || request.referer || root_path
    redirect_to next_path
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :programming_language, :country_code, :interested_in_jobs, :years_of_experience)
  end
end

