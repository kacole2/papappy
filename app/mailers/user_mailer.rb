class UserMailer < ActionMailer::Base
  default from: "kendrickcoleman@gmail.com"

  def pappy()
    mail(:subject => "Pappy")
  end
end
