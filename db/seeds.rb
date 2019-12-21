# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#ユーザー
User.create!(name:  "Example User",
             email: "example@wildrecipe.com",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true)

Recipe.create!(name: "スベリヒユのおひたし",
               user_id: "1",
               comment: "一番最初に作った野草料理です。")
               
Ingredient.create!(name: "スベリヒユ",
                   amount: "100ｇ",
                   number: "1",
                   recipe_id: "1")

Ingredient.create!(name: "しょうゆ",
                   amount: "大さじ3",
                   number: "2",
                   recipe_id: "1")

Ingredient.create!(name: "さとう",
                   amount: "大さじ2",
                   number: "3",
                   recipe_id: "1")