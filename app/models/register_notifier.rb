class RegisterNotifier < ActionMailer::Base
  include ActionController::UrlWriter

  def confirmation(entry)
    @recipients  = "#{entry.email}"
    @from        = ApplicationConfig::ADMIN_MAIL_ADDR
    @subject     = "[#{ApplicationConfig::SITE_NAME}] "
    @sent_on     = Time.now
    @body[:url]  = "#{ApplicationConfig::SITE_URL}event/confirmation/#{entry.id}?token=#{entry.token}"
  end
end
