# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

types = []
3.times do |i|
  types << Type.create(name: "Type#{i}")
end

users = []
2.times do |i|
  user = User.new(nickname: "User#{i}", email: "user#{i}@example.com",
                  password: "foobar12", password_confirmation: "foobar12")
  user.skip_confirmation!
  user.save
  users << user
end

admin = User.new(nickname: "admin", email: "admin@example.com",
                 password: "foobar12", password_confirmation: "foobar12")
admin.role = :admin
admin.skip_confirmation!
admin.save

ads = []
ads << Advertisement.create(content: "Bla-bla-bla", type_id: types.first.id, user_id: users.first.id)
ads << Advertisement.create(content: "Other bla", type_id: types.second.id, user_id: users.first.id)

ads.first.pictures.create([{ url: "http://fc05.deviantart.net/fs71/i/2011/265/f/1/limbo__or_smth_like_that_by_shine_blue-d4akqph.jpg" },
                           { url: "http://www.scificool.com/images/2012/01/Will-Smth-and-Tommy-Lee-Jones-in-Men-in-Black-3-2012-Movie-Image.jpg" }])
ads.second.pictures.create(:url => "http://thumbs.dreamstime.com/thumblarge_579/1296559102qK8o4n.jpg")
