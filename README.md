# Todo Script
## Overview
This script manages your todo tasks with the following features:
- add, update, delete, show, list, and search tasks.
- each task has an id, title, description, location, due date and time, and completion status.

## Design Choices
- tasks are stored in a text file (`tasks.txt`) for simplicity and ease of use.
- the script is written in bash for portability across different Unix-like systems.
- user input is validated for date and time formats to ensure data integrity.

## Data
- tasks are stored in `tasks.txt`, with each task represented by a line with fields separated by `|`.
- example of a task line:
  ```plaintext
  1622563200|Finish project|Complete the final project for the course|Home|2024-05-26|17:00|0
