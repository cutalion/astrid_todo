astrid_todo
===========

Console client for [Astrid](http://www.astrid.com/) todo service

## Usage

### List all tasks

* `./bin/todo`
* `./bin/todo all`
* `./bin/todo tasks`

### Add new task

* `./bin/todo add` - reads tasks from stdin
* `./bin/todo new` - reads tasks from stdin
* `./bin/todo add "buy a car #win"`

### Delete task

* `./bin/todo rm <task_id1> <task_id2>`
* `./bin/todo delete <task_id>`

### Edit task

* `./bin/todo edit <task_id> "edit task"`

### List tags (lists)

* `./bin/todo tags`
* `./bin/todo lists`

### List tasks by tag

* `./bin/todo tag <name>`
* `./bin/todo list <name>`

## Roadmap

* add 'complete' command
* write tests
* release gem
* install binary after the gem installed
* extract client into separate gem
* think about more features
