require 'rest-client'
require 'json'
require './client'

API_SECRET = "xxxxxxxxxxxxx"
APP_ID     = "xxxxxxxxxxxxx"

USER    = "xxxxxxx@xxxxxxx.xxx"
PASSWORD = "xxxxxxxxx"

astrid = AstridClient.new(APP_ID, API_SECRET)
astrid.user_signin(USER, PASSWORD)

puts "Lists:"
lists = astrid.list_list['list'].each do |list|
  puts "* #{list['name']} (#{list['tasks']})"
end
