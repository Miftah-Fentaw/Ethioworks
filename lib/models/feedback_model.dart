class Feedback {
  final String id;
  final String subject;
  final String username;
  final String email;
  final String message;
  final DateTime createdAt;

  Feedback({
    required this.id,
    required this.subject,
    required this.username,
    required this.email,
    required this.message,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'subject': subject,
    'username': username,
    'email': email,
    'message': message,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Feedback.fromJson(Map<String, dynamic> json) => Feedback(
    id: json['id'] as String,
    subject: json['subject'] as String,
    username: json['username'] as String,
    email: json['email'] as String,
    message: json['message'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );

  Feedback copyWith({
    String? id,
    String? subject,
    String? username,
    String? email,
    String? message,
    DateTime? createdAt,
  }) => Feedback(
    id: id ?? this.id,
    subject: subject ?? this.subject,
    username: username ?? this.username,
    email: email ?? this.email,
    message: message ?? this.message,
    createdAt: createdAt ?? this.createdAt,
  );
}
