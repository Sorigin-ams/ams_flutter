// import 'package:project/models/project_tasks_model.dart';
// import 'package:project/Fragments/utils/images.dart';
//
// List<ProjectModel> likedProjects = getLikedProjects();
//
// class ProjectModel {
//   int id;
//   String name;
//   String projectImage;
//   String status; // pending, in progress, completed
//   String starRating;
//   String detailDescription;
//   String tasksCompleted;
//   String budget;
//   bool isLiked;
//   List<ProjectTaskModel> projectTasks;
//
//   ProjectModel(
//     this.id,
//     this.name,
//     this.projectImage,
//     this.status,
//     this.starRating,
//     this.detailDescription,
//     this.tasksCompleted,
//     this.budget,
//     this.isLiked,
//     this.projectTasks,
//   );
// }
//
// List<ProjectModel> getPendingProjects() {
//   List<ProjectModel> list = List.empty(growable: true);
//   list.add(ProjectModel(
//     0,
//     "Project Alpha",
//     projectPendingImage,
//     "Pending",
//     "3.5",
//     "Project Alpha is in the planning phase, focusing on initial design and resource allocation.",
//     "120",
//     "5000",
//     false,
//     getProjectTasks(),
//   ));
//   list.add(ProjectModel(
//     1,
//     "Project Beta",
//     projectPendingImage,
//     "Pending",
//     "4.0",
//     "Project Beta is awaiting resource approval.",
//     "80",
//     "3000",
//     false,
//     getProjectTasks(),
//   ));
//   list.add(ProjectModel(
//     2,
//     "Project Gamma",
//     projectPendingImage,
//     "Pending",
//     "4.5",
//     "Project Gamma is currently under review for feasibility.",
//     "90",
//     "4500",
//     false,
//     getProjectTasks(),
//   ));
//   list.add(ProjectModel(
//     3,
//     "Project Delta",
//     projectPendingImage,
//     "Pending",
//     "3.8",
//     "Project Delta requires further evaluation before proceeding.",
//     "60",
//     "2500",
//     false,
//     getProjectTasks(),
//   ));
//   return list;
// }
//
// List<ProjectModel> getInProgressProjects() {
//   List<ProjectModel> list = List.empty(growable: true);
//   list.add(ProjectModel(
//     4,
//     "Project Epsilon",
//     projectInProgressImage,
//     "In Progress",
//     "4.2",
//     "Project Epsilon is currently underway, focusing on development.",
//     "150",
//     "8000",
//     false,
//     getProjectTasks(),
//   ));
//   list.add(ProjectModel(
//     5,
//     "Project Zeta",
//     projectInProgressImage,
//     "In Progress",
//     "4.5",
//     "Project Zeta is in the testing phase.",
//     "200",
//     "10000",
//     false,
//     getProjectTasks(),
//   ));
//   return list;
// }
//
// List<ProjectModel> getCompletedProjects() {
//   List<ProjectModel> list = List.empty(growable: true);
//   list.add(ProjectModel(
//     6,
//     "Project Eta",
//     projectCompletedImage,
//     "Completed",
//     "5.0",
//     "Project Eta was successfully completed with all deliverables met.",
//     "300",
//     "15000",
//     true,
//     getProjectTasks(),
//   ));
//   list.add(ProjectModel(
//     7,
//     "Project Theta",
//     projectCompletedImage,
//     "Completed",
//     "4.9",
//     "Project Theta exceeded expectations in both quality and timing.",
//     "250",
//     "12000",
//     true,
//     getProjectTasks(),
//   ));
//   return list;
// }
//
// List<ProjectModel> getLikedProjects() {
//   List<ProjectModel> list = List.empty(growable: true);
//   list.add(ProjectModel(
//     0,
//     "Project Alpha",
//     projectPendingImage,
//     "Pending",
//     "3.5",
//     "Project Alpha is in the planning phase, focusing on initial design and resource allocation.",
//     "120",
//     "5000",
//     true,
//     getProjectTasks(),
//   ));
//   list.add(ProjectModel(
//     7,
//     "Project Theta",
//     projectCompletedImage,
//     "Completed",
//     "4.9",
//     "Project Theta exceeded expectations in both quality and timing.",
//     "250",
//     "12000",
//     true,
//     getProjectTasks(),
//   ));
//   return list;
// }
//
// void addFavouriteProject(int projectIndex) {
//   likedProjects.add(projects[projectIndex]);
// }
//
// void removeFavouriteProject(int projectIndex) {
//   likedProjects
//       .removeWhere((project) => project.name == projects[projectIndex].name);
// }
