class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def deletion_email(user)
    @user = user
    mail(to: @user.email, subject: 'You got deleted')
  end

end
