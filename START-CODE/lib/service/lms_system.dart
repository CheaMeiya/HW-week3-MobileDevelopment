
import '../model/student.dart';
import '../model/course.dart';
import '../model/course_result.dart';

class LmsSystem {
  final List<Student> students = [];
  final List<Course> courses = [];
  final List<CourseResult> results = [];

  // Add student
  void addStudent({
    required String studentId,
    required String studentName,
  }) {
    // Student shall not exist already
    Student? student = _findStudentOrNull(studentId);
    if (student != null) {
      throw Exception('Student $studentId already exists');
    }

    students.add(Student(id: studentId, name: studentName));
  }

  // Add course
  void addCourse({
    required String courseId,
    required String courseName,
  }) {
    // Course shall not exist already
    Course? course = _findCourseOrNull(courseId);
    if (course != null) {
      throw Exception('Course $courseId already exists');
    }

    courses.add(Course(id: courseId, name: courseName));
  }

  // Remove course
  void removeCourse({required String courseId}) {
    Course? course = _findCourseOrNull(courseId);

    if (course == null) {
      throw Exception('Course $courseId not found');
    }

    // Course cannot be removed if it has students or results
    if (course.studentIds.isNotEmpty ||
        results.any((result) => result.courseId == courseId)) {
      throw Exception('Cannot remove course with students or results');
    }

    courses.removeWhere((c) => c.id == courseId);
  }

  // Add student to course
  void enrollStudent({
    required String studentId,
    required String courseId,
  }) {
    // Student must exist
    Student? student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception('Student $studentId not found');
    }

    // Course must exist
    Course? course = _findCourseOrNull(courseId);
    if (course == null) {
      throw Exception('Course $courseId not found');
    }

    // Student shall not already be enrolled
    if (course.studentIds.contains(studentId)) {
      throw Exception('Student $studentId already enrolled');
    }

    course.studentIds.add(studentId);
  }

  // Remove student from course
  void discardStudentFromCourse({
    required String studentId,
    required String courseId,
  }) {
    // Student must exist
    Student? student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception('Student $studentId not found');
    }

    // Course must exist
    Course? course = _findCourseOrNull(courseId);
    if (course == null) {
      throw Exception('Course $courseId not found');
    }

    // Student must be enrolled
    if (!course.studentIds.contains(studentId)) {
      throw Exception('Student $studentId is not enrolled');
    }

    // Remove student from course
    course.studentIds.remove(studentId);

    // Remove results belonging to this student in this course
    results.removeWhere(
      (result) =>
          result.studentId == studentId &&
          result.courseId == courseId,
    );
  }

  // Add result
  void addResult({
    required String resultId,
    required String studentId,
    required String courseId,
    required double score,
  }) {
    // Student must exist
    Student? student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception('Student $studentId not found');
    }

    // Course must exist
    Course? course = _findCourseOrNull(courseId);
    if (course == null) {
      throw Exception('Course $courseId not found');
    }

    // Student must be enrolled in the course
    if (!course.studentIds.contains(studentId)) {
      throw Exception('Student $studentId is not enrolled');
    }

    // Score must be between 0 and 100
    if (score < 0 || score > 100) {
      throw Exception('Score must be between 0 and 100');
    }

    // Result ID shall not exist already
    if (results.any((result) => result.id == resultId)) {
      throw Exception('Result $resultId already exists');
    }

    results.add(
      CourseResult(
        id: resultId,
        studentId: studentId,
        courseId: courseId,
        score: score,
      ),
    );
  }

  // Remove result
  void removeResult({required String resultId}) {
    bool resultExists = results.any((result) => result.id == resultId);

    if (!resultExists) {
      throw Exception('Result $resultId not found');
    }

    results.removeWhere((result) => result.id == resultId);
  }

  // Keep your original addScore method
  void addScore({
    required String studentId,
    required String courseId,
    required double score,
  }) {
    addResult(
      resultId: 'R${results.length + 1}',
      studentId: studentId,
      courseId: courseId,
      score: score,
    );
  }

  // Remove student
  void removeStudent({required String studentId}) {
    Student? student = _findStudentOrNull(studentId);

    if (student == null) {
      throw Exception('Student $studentId not found');
    }

    // 1- Remove student from the students list
    students.removeWhere((s) => s.id == studentId);

    // 2- Remove student from every course
    for (Course course in courses) {
      course.studentIds.remove(studentId);
    }

    // 3- Remove all results belonging to this student
    results.removeWhere((result) => result.studentId == studentId);
  }

  Student? _findStudentOrNull(String studentId) {
    for (Student s in students) {
      if (s.id == studentId) {
        return s;
      }
    }

    return null; // not found
  }

  Course? _findCourseOrNull(String courseId) {
    for (Course c in courses) {
      if (c.id == courseId) {
        return c;
      }
    }

    return null; // not found
  }
}
