module Astrid
  class CLI
    TOKEN_FILE = './.astrid_token'

    attr_reader :client

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
      case command
      when 'delete', 'rm'

        info.puts "Removing #{ARGV.size} tasks"

        ARGV.each_with_index do |id, i|
          info.print "\r" +  "." * (i+1)
          tasks.delete id
        end
        info.puts
        info.puts "#{ARGV.size} tasks removed"

      when 'edit'

        id    = ARGV.shift.dup
        title = ARGV.shift.dup
        task  = Task.new(id: id, title: title)

        if tasks.update task
          info.puts "Task updated"
        end

      when 'add', 'new'

        tasks_list = ARGV.empty? ? ARGF.lines.to_a : ARGV

        info.puts "Creating #{tasks_list.size} tasks"

        tasks_list.each do |title|
          task = Task.new(title: title.strip)
          tasks.add task
        end

        info.puts "#{tasks_list.size} tasks created"

      when 'all', 'tasks'

        tasks.all.each_with_index do |task, i|
          output.printf "%20s - %s\n", task.id, task.title
        end

      when 'lists', 'tags'

        lists.all.each_with_index do |list, i|
          output.printf "%2d - %s (%d)\n", i+1, list.name, list.tasks_count
        end

      when 'list', 'tag'

        list_name = ARGV.shift.to_s.strip
        list = lists.all.find { |l| l.name.downcase == list_name }
        if list
          tasks.where(tag_id: list.id).all.each do |task|
            output.printf "%20s - %s\n", task.id, task.title
          end
        else
          info.puts "No such list"
        end

      else
        info.puts "Unknown command '#{command}'"
        exit 1
      end

    end
  end
end
