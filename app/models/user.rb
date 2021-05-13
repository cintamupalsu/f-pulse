class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  #devise :database_authenticatable, :registerable,
  #       :recoverable, :rememberable, :validatable
  devise :omniauthable, omniauth_providers: [:google_oauth2]
  has_many :mujins, dependent: :destroy
  has_many :role_users, dependent: :destroy

  def self.from_google(email:, full_name:, uid:, avatar_url:)
    #return nil unless email =~ /@sbs-infosys.co.jp\z/
    create_with(uid: uid, full_name: full_name, avatar_url: avatar_url).find_or_create_by!(email: email)
  end
end
