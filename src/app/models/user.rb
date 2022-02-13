class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :search_histories, dependent: :destroy
  has_many :favorites, dependent: :destroy

  # 店舗をお気に入りにしているかを判定
  def favorite?(shop_id)
    favorites.where(shop_id: shop_id).exists?
  end
end
