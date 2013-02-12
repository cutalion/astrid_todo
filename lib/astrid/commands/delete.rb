require 'lib/astrid/commands/base'

module Astrid
  module Commands
    class Delete < Base
      def run
        puts "Removing #{ARGV.size} tasks"

        ARGV.each_with_index do |id, i|
          progress i+1
          app.tasks.delete id
        end

        puts
        puts "#{ARGV.size} tasks removed"
      end
    end
  end
end
