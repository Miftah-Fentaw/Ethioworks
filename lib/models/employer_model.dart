import 'package:ethioworks/models/user_model.dart';

class Employer extends User {
  final String companyOrPersonalName;
  final String? description;
  final int followers;
  final String? profilePic;

  Employer({
    required super.id,
    required super.email,
    required super.createdAt,
    required super.updatedAt,
    required this.companyOrPersonalName,
    this.description,
    this.followers = 0,
    this.profilePic,
  }) : super(userType: UserType.employer);

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'companyOrPersonalName': companyOrPersonalName,
    'description': description,
    'followers': followers,
    'profilePic': profilePic,
  };

  factory Employer.fromJson(Map<String, dynamic> json) => Employer(
    id: json['id'] as String,
    email: json['email'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
    companyOrPersonalName: json['companyOrPersonalName'] as String,
    description: json['description'] as String?,
    followers: json['followers'] as int? ?? 0,
    profilePic: json['profilePic'] as String?,
  );

  Employer copyWith({
    String? id,
    String? email,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? companyOrPersonalName,
    String? description,
    int? followers,
    String? profilePic,
  }) => Employer(
    id: id ?? this.id,
    email: email ?? this.email,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    companyOrPersonalName: companyOrPersonalName ?? this.companyOrPersonalName,
    description: description ?? this.description,
    followers: followers ?? this.followers,
    profilePic: profilePic ?? this.profilePic,
  );
}
