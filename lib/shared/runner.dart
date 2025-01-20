class Runner {
  final int id;
  final String name;
  final bool isTeacher;

  Runner({required this.id, required this.name, required this.isTeacher});

  factory Runner.fromJson(Map<String, dynamic> json) {
    return Runner(
      id: json['id'],
      name: json['name'],
      isTeacher: json['isTeacher'],
    );
  }
}
