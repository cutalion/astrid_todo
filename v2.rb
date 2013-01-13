#!/usr/bin/env ruby
require 'curses'
require File.expand_path('../client', __FILE__)


def config(key)
  ENV.fetch(key) { raise "Set the #{key} env variable" }
end

API_SECRET = config('ASTRID_API_SECRET')
APP_ID     = config('ASTRID_APP_ID')

USER       = config('ASTRID_USER')
PASSWORD   = config('ASTRID_PASSWORD')

def init_screen
  Curses.noecho # do not show typed keys
  Curses.init_screen
  Curses.stdscr.keypad(true) # enable arrow keys
  begin
    yield
  ensure
    Curses.close_screen
  end
end

def clear_screen
  Curses.clear
  Curses.refresh
end

def write(line, column, text)
  Curses.setpos(line, column)
  Curses.addstr(text);
end

def render(todo)
  write 0, 0, "Tasks:"
  todo.tasks.each_with_index do |task, i|
    mark = todo.current == i ? "*" : "-"
    write i+1, 0, "#{mark} #{task['title']}"
  end
end

def input(message)
  Curses.echo
  win = Curses::Window.new( 2, Curses.cols, (Curses.lines - 2), 0)
  win.addstr(message)
  win.setpos(1,0)
  win.refresh
  task_title = win.getstr
  win.close
  Curses.noecho
  task_title
end

class Astrid
  attr_reader :client, :current

  def initialize(client)
    @client = client
    @current = 0
  end

  def tasks
    @tasks ||= client.task_list['list']
    @current = @tasks.size - 1 if @current >= @tasks.size
    @tasks
  end

  def current_task
    tasks[@current]
  end

  def update(id, title)
    return if title.to_s.strip.empty?
    client.task_save({'id' => id, 'title' => title})
    reload
  end

  def create(title)
    return if title.to_s.strip.empty?
    client.task_save({'title' => title})
    reload
  end

  def delete(id)
    client.task_save({id: id, deleted_at: Time.now.to_i})
    reload
  end

  def complete(id)
    client.task_save({id: id, completed_at: Time.now.to_i})
    reload
  end

  def reload
    @tasks = nil
  end

  def prev
    @current = @current < 1 ? 0 : @current - 1
  end

  def next
    number_of_tasks = tasks.size
    @current = @current < number_of_tasks - 1 ? @current + 1 : number_of_tasks - 1
  end
end


init_screen do
  client = AstridClient.new(APP_ID, API_SECRET)
  client.user_signin(USER, PASSWORD)
  todo = Astrid.new(client)


  loop do
    clear_screen
    render todo


    case Curses.getch
    when Curses::Key::UP then todo.prev
    when Curses::Key::DOWN then todo.next
    when ?e then todo.update( todo.current_task['id'],
                              input("Edit #{todo.current_task['title']}:") )
    when ?a,?n then todo.create( input("New task:") )
    when ?d then todo.delete( todo.current_task['id'] )
    when ?c then todo.complete( todo.current_task['id'] )
    when ?q then break
    when ?r then todo.reload
    end
  end
end
