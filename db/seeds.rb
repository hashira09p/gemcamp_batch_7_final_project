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

User.create(
  email: 'jerome@koda.com',
  password: "qwerty", # Devise will encrypt this
  username: Faker::Internet.username,
  phone_number: "09326184829",
  coins: rand(0..1000),
  total_deposit: Faker::Number.decimal(l_digits: 8, r_digits: 2),
  children_members: rand(0..5),
  remember_created_at: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now),
  role: 1
)