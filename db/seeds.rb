# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#ユーザー
User.create!(name:  "レシピマン@アドミン",
             email: "example@wildrecipe.com",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true)

User.create!(name: "サンプルさん",
             email: "sample@sample.com",
             password: "password",
             password_confirmation: "password")
             
Recipe.create!(name: "スベリヒユのおひたし",
               user_id: "1",
               comment: "一番最初に作った野草料理です。",
               release: true)
               
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

Procedure.create!(number: "1",
                  content: "スベリヒユをよく洗って泥を落とします",
                  recipe_id: "1")

Procedure.create!(number: "2",
                  content: "しばらく湯がいてザルにあげます",
                  recipe_id: "1")

Procedure.create!(number: "3",
                  content: "ボウルに入れて調味料と混ぜます",
                  recipe_id: "1")
                  
Procedure.create!(number: "4",
                  content: "お皿に盛って召し上がれ",
                  recipe_id: "1")

Impression.create!(user_id: "1",
                   recipe_id: "1",
                   comment: "実際に作ってみましたがおいしかったです！")