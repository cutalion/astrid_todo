require './lib/astrid/client'
require './lib/astrid/tasks'
require './lib/astrid/task'
require './lib/astrid/lists'
require './lib/astrid/list'
require './lib/astrid/commands'

module Astrid
  class CLI
    TOKEN_FILE = './.astrid_token'

    attr_reader :client

    def self.command(command, options = {})
      aliases = [command.to_s.split('::').last.downcase, options[:aliases]].flatten.uniq
      @@commands ||= {}
      aliases.each do |a|
        @@commands[a] = command
      end
    end

    command Commands::Delete, aliases: 'rm'
    command Commands::Edit
    command Commands::Add,    aliases: 'new'
    command Commands::All,    aliases: 'tasks'
    command Commands::Lists,  aliases: 'tags'
    command Commands::List,   aliases: 'tag'

    def initialize
      @client = AstridClient.new(APP_ID, API_SECRET)

      unless File.exists?(TOKEN_FILE)
        client.user_signin(USER, PASSWORD)
        File.open(TOKEN_FILE, 'w').write(client.token)
      else
        client.token = File.open(TOKEN_FILE).read
      end
    end

    def info
      $stderr
    end

    def output
      $stdout
    end

    def puts(*args)
      info.puts *args
    end

    def progress(num, symbol='.')
      info.printf "\r" + symbol * num
    end

    def display(*args)
      output.puts *args
    end

    def tasks
      @tasks ||= Tasks.new(client)
    end

    def lists
      @lists ||= Lists.new(client)
    end

    def command
      @command ||= (ARGV.shift || 'all')
    end

    def run
      if @@commands[command]
        @@commands[command].new(self).run
      else
        puts "Unknown command '#{command}'"
        exit 1
      end
    end
  end
end
