class User < ApplicationRecord
  attr_accessor :remember_token
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  #devise :database_authenticatable, :registerable,
  #       :recoverable, :rememberable, :validatable
  devise :omniauthable, omniauth_providers: [:google_oauth2]
  has_many :mujins, dependent: :destroy
  has_many :role_users, dependent: :destroy
  has_many :sub_feature_users, dependent: :destroy
  has_secure_password

  def self.from_google(email:, full_name:, uid:, avatar_url:)
    #return nil unless email =~ /@sbs-infosys.co.jp\z/
    create_with(uid: uid, full_name: full_name, avatar_url: avatar_url).find_or_create_by!(email: email)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember(new_token)
    self.remember_token = new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
end
