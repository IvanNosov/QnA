
class ConfirmationMailer < ApplicationMailer
  def send_confirmation(email, link)
    @link = link
    mail(to: email, subject: 'Confirm your email')
  end
end
