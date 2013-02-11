require './lib/astrid/commands/base'

module Astrid
  module Commands
    class Add < Base
      def run
        tasks_list = ARGV.empty? ? ARGF.lines.to_a : ARGV

        puts "Creating #{tasks_list.size} tasks"

        tasks_list.each_with_index do |title, i|
          task = Task.new(title: title.strip)
          progress i+1
          app.tasks.add task
        end

        puts
        puts "#{tasks_list.size} tasks created"
      end
    end
  end
end
