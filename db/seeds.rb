User.create!(name: "Example User",
             email: "example@railstutorial.org",
             password: "foobar",
             password_confirmation: "foobar",
             admin: true,
             gender: 0,
             birthday: "1990-01-01")

50.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  gender = [0, 1, 2].sample
  birthday = Faker::Date.birthday(min_age: 18, max_age: 60)
  User.create!(name: name,
               email: email,
               password:              password,
               password_confirmation: password,
               gender: gender,
               birthday: birthday)
end
