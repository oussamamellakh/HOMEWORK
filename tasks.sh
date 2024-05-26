#!/bin/bash

TODO_FILE="$(dirname "$0")/tasks.txt"

touch "$TODO_FILE"

usage() {
  echo "esage: $0 {add|update|delete|show|list|search} [arguments...]" >&2
  exit 1
}

validate_date() {
  date -d "$1" "+%Y-%m-%d" &>/dev/null
}

validate_time() {
  date -d "$1" "+%H:%M" &>/dev/null
}

add_task() {
  echo "enter title (required):"
  read -r title
  if [ -z "$title" ]; then
    echo "Title is required" >&2
    exit 1
  fi

  echo "enter due date (YYYY-MM-DD, required):"
  read -r due_date
  if ! validate_date "$due_date"; then
    echo "Invalid date format" >&2
    exit 1
  fi

  echo "enter due time (HH:MM, optional):"
  read -r due_time
  if [ -n "$due_time" ] && ! validate_time "$due_time"; then
    echo "Invalid time format" >&2
    exit 1
  fi

  echo "enter description (optional):"
  read -r description
  echo "enter location (optional):"
  read -r location

  id=$(date +%s)
  echo "$id|$title|$description|$location|$due_date|$due_time|0" >> "$TODO_FILE"
  echo "task added with id: $id"
}

update_task() {
  echo "enter task id to update:"
  read -r id
  if ! grep -q "^$id|" "$TODO_FILE"; then
    echo "Task ID not found" >&2
    exit 1
  fi

  echo "enter new title (leave blank to keep current):"
  read -r title
  echo "enter new due date (YYYY-MM-DD, leave blank to keep current):"
  read -r due_date
  echo "enter new due time (HH:MM, leave blank to keep current):"
  read -r due_time
  echo "enter new description (leave blank to keep current):"
  read -r description
  echo "enter new location (leave blank to keep current):"
  read -r location
  echo "enter new completion status (0 for incomplete,1 for complete,leave blank to keep current):"
  read -r completion

  if [ -n "$due_date" ] && ! validate_date "$due_date"; then
    echo "invalid date format" >&2
    exit 1
  fi
  if [ -n "$due_time" ] && ! validate_time "$due_time"; then
    echo "invalid time format" >&2
    exit 1
  fi

  current_task=$(grep "^$id|" "$TODO_FILE")
  IFS='|' read -r old_id old_title old_description old_location old_due_date old_due_time old_completion <<< "$current_task"

  new_title=${title:-$old_title}
  new_description=${description:-$old_description}
  new_location=${location:-$old_location}
  new_due_date=${due_date:-$old_due_date}
  new_due_time=${due_time:-$old_due_time}
  new_completion=${completion:-$old_completion}

  sed -i "s/^$id|.*/$id|$new_title|$new_description|$new_location|$new_due_date|$new_due_time|$new_completion/" "$TODO_FILE"
  echo "Task updated"
}

delete_task() {
  echo "enter task id to delete:"
  read -r id
  if ! grep -q "^$id|" "$TODO_FILE"; then
    echo "task ID not found" >&2
    exit 1
  fi
  sed -i "/^$id|/d" "$TODO_FILE"
  echo "task deleted"
}

show_task() {
  echo "enter task id to show:"
  read -r id
  if ! grep -q "^$id|" "$TODO_FILE"; then
    echo "task id not found" >&2
    exit 1
  fi
  grep "^$id|" "$TODO_FILE" | while IFS='|' read -r id title description location due_date due_time completion; do
    echo "id: $id"
    echo "title: $title"
    echo "description: $description"
    echo "location: $location"
    echo "due date: $due_date"
    echo "due time: $due_time"
    echo "completed: $completion"
  done
}

list_tasks() {
  date=${1:-$(date +%Y-%m-%d)}
  echo "tasks for $date:"
  echo "completed:"
  grep "|$date|" "$TODO_FILE" | grep "|1$" | while IFS='|' read -r id title description location due_date due_time completion; do
    echo "  id: $id, title: $title"
  done
  echo "Uncompleted:"
  grep "|$date|" "$TODO_FILE" | grep "|0$" | while IFS='|' read -r id title description location due_date due_time completion; do
    echo "  id: $id, title: $title"
  done
}

search_task() {
  echo "Enter title to search: "
  read -r title
  grep "|$title|" "$TODO_FILE" | while IFS='|' read -r id title description location due_date due_time completion; do
    echo "id: $id"
    echo "title: $title"
    echo "description: $description"
    echo "location: $location"
    echo "due date: $due_date"
    echo "due time: $due_time"
    echo "completed: $completion"
    echo "------"
  done
}

case "$1" in
  add)
    add_task
    ;;
  update)
    update_task
    ;;
  delete)
    delete_task
    ;;
  show)
    show_task
    ;;
  list)
    list_tasks "$2"
    ;;
  search)
    search_task
    ;;
  *)
    list_tasks
    ;;
esac
