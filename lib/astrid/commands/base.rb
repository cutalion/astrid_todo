module Astrid
  module Commands
    class Base
      attr_reader :error, :output, :app

      def initialize(app)
        @error = app.info
        @output = app.output
        @app = app
      end

      def puts(*args)
        app.puts *args
      end

      def display(*args)
        app.display *args
      end
    end
  end
end
