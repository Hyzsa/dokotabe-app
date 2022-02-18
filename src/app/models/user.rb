class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :search_histories, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_shops, through: :favorites, source: :search_history

  # ゲストユーザーのレコードを返す。
  # └ 見つからなければ作成して返す。
  def self.guest
    find_or_create_by!(email: "guest@example.com") do |user|
      user.password = SecureRandom.urlsafe_base64
      user.confirmed_at = Time.current
    end
  end

  # 検索結果をユーザーの検索履歴として保存する。
  def save_search_result(shop_info)
    search_histories.create(
      shop_id: shop_info[:id],
      shop_name: shop_info[:name],
      shop_photo: shop_info[:photo][:pc][:m],
      shop_url: shop_info[:urls][:pc],
      displayed_date: Time.current
    )
  end

  # ユーザーが店舗をお気に入りにしてたらtrueを返す。
  def favorite_shop?(shop_id)
    favorites.exists?(shop_id: shop_id)
  end
end
