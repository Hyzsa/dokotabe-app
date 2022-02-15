class SearchHistory < ApplicationRecord
  belongs_to :user
  has_one :favorite, dependent: :destroy

  validates :shop_id, presence: true
  validates :shop_name, presence: true
  validates :shop_photo, presence: true, format: /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/
  validates :displayed_date, presence: true
  validates :shop_url, presence: true, format: /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/
end
