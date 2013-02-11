require './lib/astrid/commands/base'

module Astrid
  module Commands
    class Add < Base
      def run
        tasks_list = ARGV.empty? ? ARGF.lines.to_a : ARGV

        puts "Creating #{tasks_list.size} tasks"

        tasks_list.each do |title|
          task = Task.new(title: title.strip)
          app.tasks.add task
        end

        puts "#{tasks_list.size} tasks created"
      end
    end
  end
end
