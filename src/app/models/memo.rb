class Memo < ApplicationRecord
  belongs_to :favorite

  validates :content, {presence: true, length: {maximum: 140}}
end
