class List
  attr_accessor :id, :name, :tasks

  def initialize(attributes = {})
    attributes.each do |key, value|
      if self.respond_to? "#{key}="
        send "#{key}=", value
      end
    end
  end

  alias_method :tasks_count, :tasks
end
