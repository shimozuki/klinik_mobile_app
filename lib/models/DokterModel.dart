class DokterModel {
  final int id;
  final String name;

  DokterModel({required this.id, required this.name});

  factory DokterModel.fromJson(Map<String, dynamic> json) {
    return DokterModel(id: json['id'], name: json['name'] ?? '');
  }
}
