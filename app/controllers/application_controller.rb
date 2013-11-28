class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  def handke_unverified_request
    sign_out
    super
  end
end
