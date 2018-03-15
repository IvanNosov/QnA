class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :set_auth
  def facebook
    @user = User.find_for_oauth(@auth)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    end
  end

  def twitter
    @user = User.find_for_oauth(@auth)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
    end
  end


  private

  def set_auth
    @auth = request.env['omniauth.auth']
    auth = Authorization.where(provider: @auth&.provider, uid: @auth&.uid).first
    render :confirmation unless @auth&.info&.email || auth
  end
end