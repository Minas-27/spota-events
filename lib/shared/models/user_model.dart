class UserModel {
  final String uid;
  final String email;
  final String name;
  final String phone;
  final UserRole role;
  final DateTime createdAt;
  final String? organization; // For organizers
  final String? bio; // For organizers

  const UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.phone,
    required this.role,
    required this.createdAt,
    this.organization,
    this.bio,
  });

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
      'role': role.toString().split('.').last,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'organization': organization,
      'bio': bio,
    };
  }

  // Create from Map
  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == map['role'],
        orElse: () => UserRole.attendee,
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      organization: map['organization'],
      bio: map['bio'],
    );
  }

  // Empty user
  static UserModel empty() {
    return UserModel(
      uid: '',
      email: '',
      name: '',
      phone: '',
      role: UserRole.attendee,
      createdAt: DateTime.now(),
    );
  }
}

enum UserRole {
  attendee,
  organizer,
  admin,
}
