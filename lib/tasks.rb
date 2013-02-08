class Tasks
  attr_reader :client
  attr_accessor :params

  def initialize(client)
    @client = client
    @params = {}
  end

  def where(conditions)
    tasks = dup
    tasks.params = conditions
    tasks
  end


  def all
    client.task_list(params)['list'].map do |attributes|
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
