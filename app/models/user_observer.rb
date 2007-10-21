class UserObserver < ActiveRecord::Observer
  def after_create(user)
    Notifier.deliver_signup_confirmation(user)
  end

  def after_save(user)
    Notifier.deliver_user_activation(user) if user.recently_activated?
  end
end
