require 'forwardable'

module Astrid
  module Commands
    class Base
      extend Forwardable

      attr_reader :error, :output, :app
      def_delegators :app, :display, :puts, :progress

      def initialize(app)
        @error = app.info
        @output = app.output
        @app = app
      end
    end
  end
end
