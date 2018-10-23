# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'
include Faker
$link = "https://streamable.com/bfivc"
10000.times do
  User.create(
    id_permalink: Faker::Number.number(5),
    email: Faker::Internet.email,
    usertype: 'Standard',
    creations: $link,
    credit_subscription: Faker::Number.number(3),
    creation_date: Time.now
  )
end
10000.times do
  User.create(
    id_permalink: Faker::Number.number(5),
    email: Faker::Internet.email,
    usertype: 'Pro',
    creations: $link,
    credit_subscription: Faker::Number.number(3),
    creation_date: Time.now
  )
end
10000.times do
  User.create(
    id_permalink: Faker::Number.number(5),
    email: Faker::Internet.email,
    usertype: 'Custom',
    creations: $link,
    credit_subscription: Faker::Number.number(3),
    creation_date: Time.now
  )
end
