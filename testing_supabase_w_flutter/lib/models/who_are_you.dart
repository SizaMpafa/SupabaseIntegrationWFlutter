class WhoAreYou {
  final int id;
  final DateTime? createdAt;
  final String name;
  final String occupation;

  WhoAreYou({
    required this.id,
    this.createdAt,
    required this.name,
    required this.occupation
  });

  factory WhoAreYou.fromJson(Map<String, dynamic> json) {
    return WhoAreYou(
      id: json['id'] as int,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      name: json['name'] as String,
      occupation: json['occupation'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'name': name,
      'occupation': occupation,
    };
  }
}