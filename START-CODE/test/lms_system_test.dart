import 'package:test/test.dart';

import 'package:lms_layered_architecture_example/service/lms_system.dart';

void main() {
  test('creates a student', () {
    final lms = LmsSystem();

    // Create a student
    lms.addStudent(studentId: 'S1', studentName: 'ronan');

    expect(lms.students.first.name, 'ronan');

    // Remove the student
    lms.removeStudent(studentId: 'S1');

    expect(lms.students.length, 0);
  });
}
