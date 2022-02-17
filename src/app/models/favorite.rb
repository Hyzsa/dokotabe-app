class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :search_history
  has_many :memos, dependent: :destroy

  validates :shop_id, presence: true
  validate :same_shop_cannot_be_a_favorite

  private

  # 同じお店のお気に入り追加を防止する
  def same_shop_cannot_be_a_favorite
    if shop_id.present? && Favorite.exists?(user_id: user_id, shop_id: shop_id)
      errors.add(:shop_id, ": 同じ店舗はお気に入りできません。")
    end
  end
end
