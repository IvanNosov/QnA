class UsersController < ApplicationController
  def send_confirmation
    email = params[:email]
    uid = params[:uid]
    provider = params[:provider]

    link = Base64.encode64("#{email}:#{uid}:#{provider}")
    ConfirmationMailer.send_confirmation(email, link).deliver_now
    redirect_to root_path, notice: 'We have sent a mail, please check your email'
  end

  def confirm
    email, uid, provider = Base64.decode64(params[:link]).split(':')
    auth = OmniAuth::AuthHash.new(provider: provider, uid: uid, info: { email: email })
    User.find_for_oauth(auth)
    redirect_to root_path, notice: "You successfully confirmed your mail and #{provider} account"
  end
end
