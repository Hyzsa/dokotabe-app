class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :search_histories, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_shops, through: :favorites, source: :search_history

  # ゲストユーザーを探す。
  # ：見つからなければ生成する。
  def self.guest
    find_or_create_by!(email: "guest@example.com") do |user|
      user.password = SecureRandom.urlsafe_base64
      user.confirmed_at = Time.current
    end
  end

  # 店舗をお気に入りにしているかを判定する。
  def favorite_shop?(shop_id)
    favorites.exists?(shop_id: shop_id)
  end
end
