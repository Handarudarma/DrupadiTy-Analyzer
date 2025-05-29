class Permission {
  final String name;
  final String status;
  final String info;
  final String description;

  Permission({
    required this.name,
    required this.status,
    required this.info,
    required this.description,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      info: json['info'] ?? '',
      description: json['description'] ?? '',
    );
  }

  static List<Permission> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Permission.fromJson(json)).toList();
  }
} 
