class Company {
  final int id;
  final String name;

  Company({required this.id, required this.name});

  Company.fromJson(Map<String, dynamic>json)
    : id = json['id'],
      name = json['name'];

  Map<String,dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}