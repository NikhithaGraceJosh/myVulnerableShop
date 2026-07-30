# frozen_string_literal: true

class ApplicationController < ActionController::Base
  private

  def after_sign_out_path_for(_resource_or_scope)
    root_path
  end

  def assign_default_role
    @u_r = UserRole.create(user_id: resource.id, role_id: 2)
  end
end
