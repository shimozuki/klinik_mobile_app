class AttachmentModel {
  final String url;
  final String name;
  final String mime;

  AttachmentModel({required this.url, required this.name, required this.mime});

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    return AttachmentModel(
      url: json['url'],
      name: json['name'],
      mime: json['mime'],
    );
  }

  bool get isImage {
    const imageExt = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
    return imageExt.contains(mime.toLowerCase());
  }
}
