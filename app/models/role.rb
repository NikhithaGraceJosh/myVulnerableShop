# frozen_string_literal: true

class Role < ApplicationRecord
  has_many :user_roles
  has_many :user, through: :user_roles
end
