# frozen_string_literal: true

class SessionsService
  def self.load_resource(email, password)
    @user = User.find_by_email(email)
    if @user
      if @user.valid_password?(password)
        OpenStruct.new(success?: true, user: @user, errors: nil)
      else
        OpenStruct.new(success?: false, user: @user, errors: 'Invalid password')
      end
    else
      OpenStruct.new(success?: false, user: @user, errors: 'Invalid email')
    end
  end

  def self.create_session(user)
    Session.create(user_id: user.id, token: SecureRandom.hex(10))
  end
end
