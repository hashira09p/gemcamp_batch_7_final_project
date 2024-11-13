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
    role: rand(0..1)
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
               role: 0
             }])

3.times do
  Item.create!(
    image: Faker::Avatar.image,
    name: Faker::Commerce.product_name,
    quantity: Faker::Number.between(from: 1, to: 100),
    minimum_tickets: Faker::Number.between(from: 1, to: 10),
    state: '', # Randomly pick one of the AASM states
    batch_count: Faker::Number.between(from: 1, to: 20),
    online_at: Faker::Time.between(from: 1.year.ago, to: Time.now, format: :default),
    offline_at: Faker::Time.between(from: Time.now, to: 1.year.from_now, format: :default),
    start_at: Faker::Time.between(from: Time.now, to: 1.month.from_now, format: :default),
    status: ['active', 'inactive'].sample
  )
end

3.times do
  Item.create!(
    image: Faker::Avatar.image,
    name: Faker::Commerce.product_name,
    quantity: Faker::Number.between(from: 1, to: 100),
    minimum_tickets: Faker::Number.between(from: 1, to: 10),
    state: '', # Randomly pick one of the AASM states
    batch_count: Faker::Number.between(from: 1, to: 20),
    online_at: Faker::Time.between(from: 1.year.ago, to: Time.now, format: :default),
    offline_at: Faker::Time.between(from: Time.now, to: 1.year.from_now, format: :default),
    start_at: Faker::Time.between(from: Time.now, to: 1.month.from_now, format: :default),
    status: ['active', 'inactive'].sample
  )
end