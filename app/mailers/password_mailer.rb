class PasswordMailer < ActionMailer::Base
  def reset_password(to_email, password)
    @password = password
    mail :subject => "Bunjy - Password Reset",
         :to      => to_email,
         :from    => "noreply@bunjy.me"
  end
end
