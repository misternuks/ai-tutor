class AuthenticationsController < ApplicationController
  before_action :ensure_instructor_or_admin!
end
