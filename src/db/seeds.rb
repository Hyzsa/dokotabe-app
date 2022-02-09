25.times do |n|
  User.create(
    email: "user#{n+1}@example.com",
    password: "password",
    confirmed_at: Time.current
  )
end

User.all.each_with_index do |user, i|
  (i+1).times do |n|
    user.search_histories.create(
      user_id: 1,
      shop_id: "#{n}",
      shop_name: "XXXXXXXXXXX店",
      shop_photo: "https://images.unsplash.com/photo-1559339352-11d035aa65de?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1074&q=80",
      shop_url: "https://unsplash.com/photos/YYZU0Lo1uXE",
      displayed_date: Time.current.next_day(n)
    )
  end
end
