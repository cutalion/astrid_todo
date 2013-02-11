require './lib/astrid/commands/base'

module Astrid
  module Commands
    class List < Base
      def run
        list_name = ARGV.shift.to_s.strip
        list = app.lists.all.find { |l| l.name.downcase == list_name }
        if list
          app.tasks.where(tag_id: list.id).all.each do |task|
            display sprintf("%20s - %s\n", task.id, task.title)
          end
        else
          puts "No such list"
        end
      end
    end
  end
end
