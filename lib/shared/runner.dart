class Runner {
  final int id;
  final String course;
  final String name;
  final bool isTeacher;
  final int? teacherId; // Rend le champ nullable
  final int courseId;

  Runner({
    required this.id,
    required this.course,
    required this.name,
    required this.isTeacher,
    this.teacherId, // Pas requis
    required this.courseId,
  });

  factory Runner.fromJson(Map<String, dynamic> json) {
    return Runner(
      id: json['id'],
      course: json['course'],
      name: json['name'],
      isTeacher: json['isTeacher'],
      teacherId: json['teacherId'], // Peut être null
      courseId: json['courseId'],
    );
  }
}
