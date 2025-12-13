import 'package:ethioworks/models/user_model.dart';

class JobSeeker extends User {
  final String name;
  final String? title;
  final String? about;
  final String? profilePic;
  final String? phoneNo;
  final List<String> followedCompanies;

  JobSeeker({
    required super.id,
    required super.email,
    required super.createdAt,
    required super.updatedAt,
    required this.name,
    this.title,
    this.about,
    this.profilePic,
    this.phoneNo,
    List<String>? followedCompanies,
  }) : followedCompanies = followedCompanies ?? [],
       super(userType: UserType.jobSeeker);

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'name': name,
    'title': title,
    'about': about,
    'profilePic': profilePic,
    'phoneNo': phoneNo,
    'followedCompanies': followedCompanies,
  };

  factory JobSeeker.fromJson(Map<String, dynamic> json) => JobSeeker(
    id: json['id'] as String,
    email: json['email'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
    name: json['name'] as String,
    title: json['title'] as String?,
    about: json['about'] as String?,
    profilePic: json['profilePic'] as String?,
    phoneNo: json['phoneNo'] as String?,
    followedCompanies: (json['followedCompanies'] as List<dynamic>?)?.map((e) => e as String).toList(),
  );

  JobSeeker copyWith({
    String? id,
    String? email,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? name,
    String? title,
    String? about,
    String? profilePic,
    String? phoneNo,
    List<String>? followedCompanies,
  }) => JobSeeker(
    id: id ?? this.id,
    email: email ?? this.email,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    name: name ?? this.name,
    title: title ?? this.title,
    about: about ?? this.about,
    profilePic: profilePic ?? this.profilePic,
    phoneNo: phoneNo ?? this.phoneNo,
    followedCompanies: followedCompanies ?? this.followedCompanies,
  );
}
