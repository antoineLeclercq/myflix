Fabricator(:review) do
  body { Faker::Lorem.paragraph(2) }
  rating { Faker::Number.between(1, 5) }
end
