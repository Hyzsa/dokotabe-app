class SearchHistory < ApplicationRecord
  belongs_to :user
  has_one :favorite
end
