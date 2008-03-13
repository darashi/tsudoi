# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def link_to_event(event)
    link_to(h(event.title), :controller => :events, :action => :show, :id => event.id)
  end

  def format_numeric(value)
    if value.nil?
      "-"
    else
      value.to_s
    end
  end
end
