# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

seed = true # Toggle false if seed not required

if seed
  puts '----------------'
  puts 'Starting DB Seed'
  puts '----------------'

  pass = 'password'
  users = ['sample', 'john', 'sue']
  count_users = 0
  count_projects = 0
  count_tickets = 0
  count_entries = 0

  users.each do |user|
    puts "\nCreating user: #{user}"
    user = User.create!(email: "#{user}@sample.com", username: user, password_digest: User.digest(pass))
    count_users += 1

    3.times do |i|
      puts "Creating project: #{i + 1} for #{user}"
      project = Project.create!(user_id: user.id)
      project_details = ProjectDetail.create!(
        project_id: project.id,
        project_name: "#{Faker::Hacker.ingverb} #{Faker::Hacker.noun}",
        description: Faker::Hacker.say_something_smart
      )
      count_projects += 1

      puts "Creating ticket for #{project_details.project_name}"
      ticket = Ticket.create!(project_id: project.id, user_id: user.id)
      count_tickets += 1

      rand(2..10).times do |i|
        puts "Creating entry: #{i + 1} for #{ticket.id}"
        entry = Entry.create!(
          ticket_id: ticket.id,
          user_id: user.id,
          subject: Faker::Company.bs,
          body: Faker::Lorem.paragraph(sentence_count: rand(5..30), supplemental: true)
        )
        count_entries += 1
      end
    end
  end

  puts '-----------------'
  puts 'Done Seeding'
  puts 'There are a total of:'
  puts "Users: #{count_users}"
  puts "Projects: #{count_projects}"
  puts "Tickets: #{count_tickets}"
  puts "Entries: #{count_entries}"
  puts '-----------------'
end