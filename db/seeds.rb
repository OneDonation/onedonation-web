# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

u = User.create(prefix: "",first_name: "Jonathan",middle_name: "David",last_name: "Simmons",suffix: "",email: "jonathan.simmons@mac.com",password: "access123",age: 27,gender: 0)
t = Team.create(name: "Simmons", owner_id: User.first.id)
t.memberships.create(user_id: u.id, team_id: t.id, permission:0)

Staff.create(name: "Jonathan Simmons",email: "jon@jsdev.co",password: "access123",permission: 0)