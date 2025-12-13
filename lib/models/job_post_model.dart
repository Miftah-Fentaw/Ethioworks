enum LocationType { remote, permanent, onSite }

class JobPost {
  final String id;
  final String title;
  final String description;
  final LocationType locationType;
  final String? location;
  final String salary;
  final List<String> roles;
  final List<String> expectedSkills;
  final String education;
  final int likes;
  final int dislikes;
  final String employerId;
  final String companyName;
  final String? companyProfilePic;
  final DateTime createdAt;
  final DateTime updatedAt;

  JobPost({
    required this.id,
    required this.title,
    required this.description,
    required this.locationType,
    this.location,
    required this.salary,
    required this.roles,
    required this.expectedSkills,
    required this.education,
    this.likes = 0,
    this.dislikes = 0,
    required this.employerId,
    required this.companyName,
    this.companyProfilePic,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'locationType': locationType.name,
    'location': location,
    'salary': salary,
    'roles': roles,
    'expectedSkills': expectedSkills,
    'education': education,
    'likes': likes,
    'dislikes': dislikes,
    'employerId': employerId,
    'companyName': companyName,
    'companyProfilePic': companyProfilePic,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory JobPost.fromJson(Map<String, dynamic> json) => JobPost(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    locationType: LocationType.values.firstWhere((e) => e.name == json['locationType']),
    location: json['location'] as String?,
    salary: json['salary'] as String,
    roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
    expectedSkills: (json['expectedSkills'] as List<dynamic>).map((e) => e as String).toList(),
    education: json['education'] as String,
    likes: json['likes'] as int? ?? 0,
    dislikes: json['dislikes'] as int? ?? 0,
    employerId: json['employerId'] as String,
    companyName: json['companyName'] as String,
    companyProfilePic: json['companyProfilePic'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  JobPost copyWith({
    String? id,
    String? title,
    String? description,
    LocationType? locationType,
    String? location,
    String? salary,
    List<String>? roles,
    List<String>? expectedSkills,
    String? education,
    int? likes,
    int? dislikes,
    String? employerId,
    String? companyName,
    String? companyProfilePic,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => JobPost(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    locationType: locationType ?? this.locationType,
    location: location ?? this.location,
    salary: salary ?? this.salary,
    roles: roles ?? this.roles,
    expectedSkills: expectedSkills ?? this.expectedSkills,
    education: education ?? this.education,
    likes: likes ?? this.likes,
    dislikes: dislikes ?? this.dislikes,
    employerId: employerId ?? this.employerId,
    companyName: companyName ?? this.companyName,
    companyProfilePic: companyProfilePic ?? this.companyProfilePic,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
