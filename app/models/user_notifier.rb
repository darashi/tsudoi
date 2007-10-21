class UserNotifier < ActionMailer::Base
  include ActionController::UrlWriter
  default_url_options[:host] = ApplicationConfig::HOST

  def signup_notification(user)
    setup_email(user)
    @subject    += 'ユーザー登録確認'
    @body[:url]  = url_for(:controller => :account, :action => :activate, :id=> user.activation_code)
  end

  def activation(user)
    setup_email(user)
    @subject    += 'ユーザー登録完了'
    @body[:url]  = url_for :controller=>'/'
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
