
import requests
import json
import os

GITHUB_TOKEN = os.getenv("GITHUB_TOKEN")
REPO_OWNER = "ADAS-Engineering-Lab"
REPO_NAME = "Cruise_Control_Repo"

with open("tasks.json", "r") as file:
    tasks = json.load(file)

GITHUB_API_URL = f"https://api.github.com/repos/{REPO_OWNER}/{REPO_NAME}/issues"

HEADERS = {
    "Authorization": f"token {GITHUB_TOKEN}",
    "Accept": "application/vnd.github.v3+json"
}

for task in tasks:
    issue_data = {
        "title": task["task"],
        "body": f"**Description:** {task['description']}\n\n**Task Type:** {task['task_type']}\n\n**Status:** {task['status']}",
        "labels": [task["task_type"], "To Do"]
    }

    response = requests.post(GITHUB_API_URL, headers=HEADERS, json=issue_data)

    if response.status_code == 201:
        print(f"Issue created: {task['task']}")
    else:
        print(f"Error creating issue: {task['task']} - {response.json()}")
