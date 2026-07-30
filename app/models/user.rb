# frozen_string_literal: true

class User < ApplicationRecord
  acts_as_paranoid
  validates :name, presence: true
  validates :email, uniqueness: true
  validates_format_of :email, with: /\A(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})\Z/i, message: ' is invalid'
  # validates :phone, presence: true
  validates_format_of :phone, with: /\A\d{10}\Z/, message: ' is invalid: Must have 10 digits', allow_blank: true
  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles

  has_one :image, as: :imageable, dependent: :destroy

  has_many :addresses, dependent: :destroy
  accepts_nested_attributes_for :addresses, allow_destroy: true
  has_many :orders

  has_many :shopping_carts, dependent: :destroy
  has_many :products, through: :shopping_carts
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    # Uncomment the section below if you want users to be created if they don't exist
    user ||= User.create(name: data['name'],
                         email: data['email'],
                         password: Devise.friendly_token[0, 20])
    user
  end

  def admin?
    @user_roles ||= roles.pluck(:name)
    @user_roles.include? 'admin'
  end

  def customer?
    @user_roles ||= roles.pluck(:name)
    @user_roles.include? 'customer'
  end
end
