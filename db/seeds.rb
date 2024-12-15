MemberLevel.create([
                     { level: 1, required_members: 0, coins: 10 },
                     { level: 2, required_members: 5, coins: 25 },
                     { level: 3, required_members: 10, coins: 50 },
                     { level: 4, required_members: 20, coins: 100 },
                     { level: 5, required_members: 30, coins: 200 },
                     { level: 6, required_members: 40, coins: 500 },
                     { level: 7, required_members: 50, coins: 1000 }
                   ])

3.times do |i|
  User.create!(
    email: Faker::Internet.email,
    password: "password#{i}", # Devise will encrypt this
    username: Faker::Internet.username,
    phone_number: "09326184829",
    coins: rand(0..1000),
    total_deposit: Faker::Number.decimal(l_digits: 8, r_digits: 2),
    children_members: rand(0..5),
    remember_created_at: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now),
    role: rand(0..1),
    member_level_id: 1
  )
end

User.create([{ email: 'jerome@koda.com',
               password: "qwerty", # Devise will encrypt this
               username: Faker::Internet.username,
               phone_number: "09326184829",
               coins: rand(0..1000),
               total_deposit: Faker::Number.decimal(l_digits: 8, r_digits: 2),
               children_members: rand(0..5),
               remember_created_at: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now),
               role: 1 },
             { email: 'jer@koda.com',
               password: "qwerty", # Devise will encrypt this
               username: Faker::Internet.username,
               phone_number: "09326184829",
               coins: rand(0..1000),
               total_deposit: Faker::Number.decimal(l_digits: 8, r_digits: 2),
               children_members: rand(0..5),
               remember_created_at: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now),
               role: 0,
               member_level_id: 1
             }])
