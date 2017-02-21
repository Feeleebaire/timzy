class UserMailer < ApplicationMailer
 def welcome(user)
    @user = user  # Instance variable => available in view

    mail(to: @user.email, subject: 'Welcome to Timzy !')
    # This will render a view in `app/views/user_mailer`!
  end
  #
  def invitation(teammate)
    @teammate = teammate
    @team = teammate.team
    email = teammate.email

    mail to: email, subject: "#{@team.admin.first_name} vous invite à rejoindre la team #{@team.name}"
  end
end
