# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def title
    ApplicationConfig::SITE_NAME
  end
  
  def link_to_event(event)
    link_to(h(event.title), :controller => :events, :action => :show, :id => event.id)
  end

  def link_to_event_detail(event)
    unless (event.url.nil? || event.url.empty?)
      link_to(h(event.url), event.url)
    else
      "-"
    end
  end

  def link_to_position_paper_url(event)
    unless (event.position_paper_url.nil? || event.position_paper_url.empty?)
      link_to(h(event.position_paper_url), event.position_paper_url)
    else
      "-"
    end
  end
  def link_to_user_website(user)
    unless (user.url.nil? || user.url.empty?)
      link_to(h(user.login), user.url)
    else
      h(user.login)
    end
  end

  def format_numeric(value)
    if value.nil?
      "-"
    else
      value.to_s
    end
  end
end
