class Person {
  final String name;
  final String email;
  final String avatar;

  Person({
    required this.name,
    required this.email,
    required this.avatar,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: "\${json['name']['first']} \${json['name']['last']}",
      email: json['email'],
      avatar: json['picture']['medium'],
    );
  }

  static List<Person> fromList(Map<String, dynamic> json) {
    final list = json['results'] as List;
    return list.map((e) => Person.fromJson(e)).toList();
  }
}