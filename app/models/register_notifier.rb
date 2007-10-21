class RegisterNotifier < ActionMailer::Base
  include ActionController::UrlWriter
  default_url_options[:host] = ApplicationConfig::HOST

  def confirmation(entry)
    @recipients  = "#{entry.email}"
    @from        = ApplicationConfig::ADMIN_MAIL_ADDR
    @subject     = "[#{ApplicationConfig::SITE_NAME}] "
    @sent_on     = Time.now
    @body[:url]  = url_for(:controller => "/event", :action => :confirmation,
                           :id => entry.id, :token => entry.token)
  end
end
