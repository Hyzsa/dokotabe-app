class Favorite < ApplicationRecord
  belongs_to :user
  has_one :search_history
end
