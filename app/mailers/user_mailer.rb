class UserMailer < ActionMailer::Base
  default from: "PA Pappy"

  def pappy()
    mail(:subject => "PA Pappy")
  end
end
