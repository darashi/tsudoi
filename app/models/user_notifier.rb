class UserNotifier < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'ユーザー登録確認'
    @body[:url]  = "#{ApplicationConfig::SITE_URL}account/activate/#{user.activation_code}"
  end

  def activation(user)
    setup_email(user)
    @subject    += 'ユーザー登録完了'
    @body[:url]  = "#{ApplicationConfig::SITE_URL}"
  end

  protected
  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = ApplicationConfig::ADMIN_MAIL_ADDR
    @subject     = "[#{ApplicationConfig::SITE_NAME}] "
    @sent_on     = Time.now
    @body[:user] = user
  end
end
