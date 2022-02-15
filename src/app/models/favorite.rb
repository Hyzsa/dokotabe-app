class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :search_history

  validates :shop_id, presence: true
  validate :same_shop_cannot_be_a_favorite

  private

  # 同じお店のお気に入り追加を防止する
  def same_shop_cannot_be_a_favorite
    if shop_id.present? && Favorite.where(user_id: user_id ,shop_id: shop_id).exists?
      errors.add(:shop_id, ": 同じ店舗はお気に入りできません。")
    end
  end
end
