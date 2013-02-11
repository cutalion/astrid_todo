require './lib/astrid/commands/base'

module Astrid
  module Commands
    class Lists < Base
      def run
        app.lists.all.each_with_index do |list, i|
          display sprintf("%2d - %s (%d)\n", i+1, list.name, list.tasks_count)
        end
      end
    end
  end
end
