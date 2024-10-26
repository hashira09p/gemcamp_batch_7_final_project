3.times do |i|
  begin
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
    puts "Created user ##{i + 1}"
  rescue => e
    puts "Error creating user ##{i + 1}: #{e.message}"
  end
end

