class Task
  attr_accessor :id, :title, :tags

  def initialize(attributes = {})
    attributes.each do |key, value|
      if self.respond_to? "#{key}="
        send "#{key}=", value
      end
    end
  end

  def title=(title)
    tags = title.to_s.scan(/\B#(\p{Word}+)/)

    if tags.any?
      title.gsub!(/\s?\B#\p{Word}+/, '')
      @tags = tags.flatten
    end

    @title = title
  end
end
