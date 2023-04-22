class SqlModel {
  late int id;
  late String title;
  late String description;
  late String category;
  late String path;
  late String location;

  SqlModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.path,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'path': path,
      'location': location,
    };

    return map;
  }

  SqlModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    description = map['description'];
    category = map['category'];
    path = map['path'];
    location = map['location'];
  }
}
