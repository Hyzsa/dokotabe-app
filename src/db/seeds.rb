User.create(
  email: "user1@example.com",
  password: "password",
  confirmed_at: Time.now
)

30.times do |n|
  DisplayedShop.create(
    user_id: 1,
    shop_id: "J001283890",
    shop_name: "尺山寸水 SEKIZAN 有楽町店",
    shop_photo: "https://imgfp.hotp.jp/IMGH/50/61/P033835061/P033835061_168.jpg",
    displayed_date: Time.now.next_day(n)
  )
end
