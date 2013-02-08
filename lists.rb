class Lists
  attr_reader :client

  def initialize(client)
    @client = client
  end


  def all
    client.list_list['list'].map do |attributes|
      List.new(attributes)
    end
  end
end
