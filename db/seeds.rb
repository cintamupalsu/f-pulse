# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# Create Features
FeatureMaster.create!(content: "Role Menu", abrev: "00100", master: true)
FeatureMaster.create!(content: "ユーザーﾏｽﾀｰ", abrev: "00200", master: true)
FeatureMaster.create!(content: "作業内容ﾏｽﾀｰ", abrev: "00300", master: true)
FeatureMaster.create!(content: "農作物ﾏｽﾀｰ", abrev: "00400", master: true)
FeatureMaster.create!(content: "ボランティア機能", abrev: "00500", master: false)



