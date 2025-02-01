
import json
import re

def extract_tasks_from_readme(readme_file):
    tasks = []
    with open(readme_file, "r", encoding="utf-8") as file:
        lines = file.readlines()
        for line in lines:
            match = re.match(r"- \[(.*?)\] (.*)", line.strip())
            if match:
                status = "To Do" if match.group(1) == " " else "Done"
                tasks.append({"task": match.group(2), "description": "", "task_type": "Feature", "status": status})
    return tasks

tasks = extract_tasks_from_readme("README.md")

with open("tasks.json", "w", encoding="utf-8") as file:
    json.dump(tasks, file, indent=4)

print("✅ Task list successfully generated from README.md!")
