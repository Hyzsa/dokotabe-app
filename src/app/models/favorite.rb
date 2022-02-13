class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :search_history
end
