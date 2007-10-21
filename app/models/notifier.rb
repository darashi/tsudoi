class Notifier < ActionMailer::Base
  include ActionController::UrlWriter
  default_url_options[:host] = ApplicationConfig::HOST

  def entry_confirmation(entry)
    setup_mail_to entry.email, "イベント #{entry.event.name} への参加確認"
    @body[:url]  = url_for(:controller => "/event", :action => :confirmation,
                           :id => entry.id, :token => entry.token)
  end

  def entry_activation(entry)
    setup_mail_to entry.email, "イベント #{entry.event.name} への参加登録が完了しました"
    @body[:url] = url_for(:controller => "/event", :action => :cancel,
                          :id => entry.id, :token => entry.token)
    @body[:event] = entry.event
  end

  def signup_confirmation(user)
    setup_mail_to user.email, 'ユーザー登録確認'
    @body[:url]  = url_for(:controller => :account, :action => :activate, :id=> user.activation_code)
    @body[:user] = user
  end

  def user_activation(user)
    setup_mail_to user.email, 'ユーザー登録完了'
    @body[:url]  = url_for :controller=>'/'
    @body[:user] = user
  end

  private
  def setup_mail_to(to, subject)
    @recipients  = "#{to}"
    @from        = ApplicationConfig::ADMIN_MAIL_ADDR
    @subject     = "[#{ApplicationConfig::SITE_NAME}] #{subject}"
    @sent_on     = Time.now
  end
end
