class Runner {
  final String id;
  final String name;

  Runner({required this.id, required this.name});

  factory Runner.fromJson(Map<String, dynamic> json) {
    return Runner(
      id: json['runnerId'],
      name: json['name'],
    );
  }
}
