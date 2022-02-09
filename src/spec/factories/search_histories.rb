FactoryBot.define do
  factory :search_history do
    user_id { 1 }
    shop_name { "XXXXXXXXXXX店" }
    shop_photo do
      "https://images.unsplash.com/photo-1559339352-11d035aa65de?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1074&q=80"
    end
    shop_url { "https://unsplash.com/photos/YYZU0Lo1uXE" }
    displayed_date { Time.current }
  end
end
