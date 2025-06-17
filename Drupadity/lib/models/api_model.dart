class AndroidApi {
  final String name;
  final String description;
  final List<String> files;

  AndroidApi({
    required this.name,
    required this.description,
    required this.files,
  });

  factory AndroidApi.fromJson(Map<String, dynamic> json) {
    return AndroidApi(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      files: (json['files'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  static List<AndroidApi> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => AndroidApi.fromJson(json)).toList();
  }
} 