class ProjectTaskModel {
  int id;
  String taskName;
  String description;
  String status; // e.g., pending, completed
  String dueDate;

  ProjectTaskModel(
    this.id,
    this.taskName,
    this.description,
    this.status,
    this.dueDate,
  );
}

List<ProjectTaskModel> getProjectTasks() {
  List<ProjectTaskModel> list = List.empty(growable: true);
  list.add(ProjectTaskModel(
    0,
    "Initial Planning",
    "Define project scope and resources.",
    "Completed",
    "2024-08-01",
  ));
  list.add(ProjectTaskModel(
    1,
    "Development",
    "Begin coding and development tasks.",
    "In Progress",
    "2024-08-15",
  ));
  list.add(ProjectTaskModel(
    2,
    "Testing",
    "Conduct testing and quality assurance.",
    "Pending",
    "2024-09-01",
  ));
  list.add(ProjectTaskModel(
    3,
    "Deployment",
    "Deploy the project to production environment.",
    "Pending",
    "2024-09-10",
  ));
  return list;
}
