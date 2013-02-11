require './lib/astrid/commands/base'

module Astrid
  module Commands
    class All < Base
      def run
        app.tasks.all.each_with_index do |task, i|
          display sprintf("%20s - %s", task.id, task.title)
        end
      end
    end
  end
end
