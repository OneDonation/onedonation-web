task admins: :environment do
  Admin.delete_all
  puts "\nPopulating admins:"
  admin = Admin.new(
    name: "Admin User",
    email: "admin@email.com",
    password: "password"
  )
  admin.skip_confirmation!
  admin.save
  print "."; STDOUT.flush
  print "(#{Admin.count})"; STDOUT.flush
end
