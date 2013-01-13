require './client'

API_SECRET = "xxxxxxxxxxxxx"
APP_ID     = "xxxxxxxxxxxxx"

USER    = "xxxxxxx@xxxxxxx.xxx"
PASSWORD = "xxxxxxxxx"

astrid = AstridClient.new(APP_ID, API_SECRET)
astrid.user_signin(USER, PASSWORD)

puts "Lists:"
lists = astrid.task_list['list'].each do |task|
  puts "* #{task['title']}"
end
