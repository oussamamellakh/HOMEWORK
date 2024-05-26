# Todo Script
## Overview
This script manages your todo tasks with the following features:
- Add, update, delete, show, list, and search tasks.
- Each task has an ID, title, description, location, due date and time, and completion status.

## Design Choices
- Tasks are stored in a text file (`tasks.txt`) for simplicity and ease of use.
- The script is written in bash for portability across different Unix-like systems.
- User input is validated for date and time formats to ensure data integrity.

## Data
- Tasks are stored in `tasks.txt`, with each task represented by a line with fields separated by `|`.
- Example of a task line:
  ```plaintext
  1622563200|Finish project|Complete the final project for the course|Home|2024-05-26|17:00|0
