FactoryBot.define do
  factory :favorite do
    user_id { 1 }
    search_history_id { 1 }
    shop_id { "MyString" }
  end
end
