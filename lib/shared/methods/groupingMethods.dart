

import '../../models.dart';

List<DirectoryGroupedModel> groupStudentsByYear(List<ProfileStudent> students) {
  List<DirectoryGroupedModel> directoryGroupedStudents = [];
  List groupedByElements = [];
  for (var i in students) {
    var groupByElement = i.godinaStudija;

    //Provjera je li vec sortirano po danom parametru
    if(!groupedByElements.contains(groupByElement)){
      groupedByElements.add(i.godinaStudija);
      List<ProfileStudent> directoryStudents = [];
      for(var j in students){
        if(j.godinaStudija == groupByElement)  directoryStudents.add(j);
      }
      directoryGroupedStudents.add(DirectoryGroupedModel(groupingByElement:  '$groupByElement. godina studija',  students: directoryStudents));
    }
  }
  if(directoryGroupedStudents.isNotEmpty) directoryGroupedStudents[0].isExtended = true;
  return directoryGroupedStudents;

}



List<DirectoryGroupedModel> groupStudentsByCourses(List<ProfileStudent> students, List<Course> courses) {

  List<DirectoryGroupedModel> directoryGroupedStudents = [];
  List groupedByElements = [];


  for(var course in courses){
    List<ProfileStudent> directoryStudents = [];
    for(var j in students) {
      if (j.enrolledCoursesCodes.contains(course.code)) directoryStudents.add(j);
    }
    if(directoryStudents.isNotEmpty) directoryGroupedStudents.add(DirectoryGroupedModel(groupingByElement: course.title,  students: directoryStudents));
  }
  if(directoryGroupedStudents.isNotEmpty) directoryGroupedStudents[0].isExtended = true;
  return directoryGroupedStudents;

}



List<CourseGroupedModel> groupCoursesBySemester(List<Course> courses) {
  List<CourseGroupedModel> courseGroupedModels = [];
  List groupedByElements = [];
  for (var courseOne in courses) {
    var groupByElement = courseOne.semester;

    //Provjera je li vec sortirano po danom parametru
    if(!groupedByElements.contains(groupByElement)){
      groupedByElements.add(courseOne.semester);
      List<Course> modelCourses = [];
      for(var courseTwo in courses){
        if(courseTwo.semester == groupByElement)  modelCourses.add(courseTwo);
      }
      courseGroupedModels.add(CourseGroupedModel(groupingByElement:  '$groupByElement. semestar',  courses: modelCourses));
    }
  }
  if(courseGroupedModels.isNotEmpty) courseGroupedModels[0].isExtended = true;
  return courseGroupedModels;
}
