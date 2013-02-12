require 'lib/astrid/commands/base'

module Astrid
  module Commands
    class Edit < Base
      def run
        id    = ARGV.shift.dup
        title = ARGV.shift.dup
        task  = Task.new(id: id, title: title)

        if app.tasks.update task
          puts "Task updated"
        end
      end
    end
  end
end
