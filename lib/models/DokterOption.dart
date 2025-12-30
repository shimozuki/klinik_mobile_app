class DokterOptionModel {
  final int id;
  final String name;
  final String email;

  DokterOptionModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory DokterOptionModel.fromJson(Map<String, dynamic> json) {
    return DokterOptionModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}
