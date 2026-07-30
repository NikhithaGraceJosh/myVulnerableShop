# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    transient do
      # admin is not an attribute of the car
      admin { false }
    end

    name { 'John' }
    email  { 'john@gmail.com' }
    password { 'password' }
    after(:create) do |user, evaluator|
      user.roles = if evaluator.admin
                     [Role.find_by(name: 'admin')]
                   else
                     [Role.find_by(name: 'user')]
                  end
    end
  end
end
