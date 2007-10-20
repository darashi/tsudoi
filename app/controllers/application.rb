# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'gettext/rails'

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  before_filter :login_from_cookie

  #GetTextの設定
  GetText.locale = "ja" # 強制的に ja for mail
  init_gettext "tsudoi"

  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_tsudoi_session_id'
end
