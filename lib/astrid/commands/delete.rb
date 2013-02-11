require './lib/astrid/commands/base'

module Astrid
  module Commands
    class Delete < Base
      def run
        error.puts "Removing #{ARGV.size} tasks"

        ARGV.each_with_index do |id, i|
          error.print "\r" +  "." * (i+1)
          app.tasks.delete id
        end

        error.puts
        error.puts "#{ARGV.size} tasks removed"
      end
    end
  end
end
