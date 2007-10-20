# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def link_to_event(event)
    link_to(h(event.name), :action => :show, :id => event.id)
  end
end
