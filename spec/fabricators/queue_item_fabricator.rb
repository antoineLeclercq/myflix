Fabricator(:queue_item) do
  position { Faker::Number.number(1).to_i + 1 }
end
