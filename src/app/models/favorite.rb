class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :search_history

  validates :shop_id, presence: true
  validate :same_shop_exist

  private

  # 同店舗の存在チェック
  def same_shop_exist
    if shop_id.present? && Favorite.where(user_id: user_id ,shop_id: shop_id).exists?
      errors.add(:shop_id, ": 同じ店舗は追加できません。")
    end
  end
end
