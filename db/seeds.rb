# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.find_or_initialize_by(username: 'Admin', email: 'james.bond@ideacrew.com')
user.confirm
user.update_attributes! admin: true, password: 'P@ssw0rd', password_confirmation: 'P@ssw0rd'
