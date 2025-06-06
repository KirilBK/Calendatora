class AppUser {
  final String uid;
  final String email;
  final String name;
  final DateTime createdAt;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    DateTime? createdAt,
  })  : createdAt = createdAt ?? DateTime.now() {
    if (!_isValidEmail(email)) {
      throw ArgumentError('Invalid email format');
    }
    if (name.trim().isEmpty) {
      throw ArgumentError('Name cannot be empty');
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email);
  }

  factory AppUser.fromMap(Map<String, dynamic> data) {
    try {
      return AppUser(
        uid: data['uid'] as String,
        email: data['email'] as String,
        name: data['name'] as String,
        createdAt: DateTime.parse(data['createdAt'] as String),
      );
    } catch (e) {
      throw FormatException('Failed to parse AppUser: $e');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  AppUser copyWith({
    String? uid,
    String? email,
    String? name,
    DateTime? createdAt,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppUser &&
          uid == other.uid &&
          email == other.email &&
          name == other.name &&
          createdAt == other.createdAt;

  @override
  int get hashCode => Object.hash(uid, email, name, createdAt);

  @override
  String toString() =>
      'AppUser(uid: $uid, email: $email, name: $name, createdAt: $createdAt)';
}