class Tasks
  attr_reader :client

  def initialize(client)
    @client = client
  end


  def all
    client.task_list['list'].map do |attributes|
      Task.new(attributes)
    end
  end


  def add(task)
    client.task_save({title: task.title, tags: task.tags})
  end


  def update(task)
    client.task_save({id: task.id, title: task.title, tags: task.tags})
  end


  def delete(id)
    client.task_save({id: id, deleted_at: Time.now.to_i})
  end
end
