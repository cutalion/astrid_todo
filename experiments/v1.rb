require './client'
require './config'

astrid = AstridClient.new(APP_ID, API_SECRET)
astrid.user_signin(USER, PASSWORD)

puts "Lists:"
lists = astrid.task_list['list'].each do |task|
  puts "* #{task['title']}"
end
