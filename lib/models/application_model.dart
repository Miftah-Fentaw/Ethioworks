class Application {
  final String id;
  final String coverLetter;
  final List<String> portfolioLinks;
  final String resumeLink;
  final String telegramUsername;
  final String email;
  final String phoneNo;
  final String jobId;
  final String userId;
  final String applicantName;
  final String? applicantTitle;
  final DateTime createdAt;

  Application({
    required this.id,
    required this.coverLetter,
    required this.portfolioLinks,
    required this.resumeLink,
    required this.telegramUsername,
    required this.email,
    required this.phoneNo,
    required this.jobId,
    required this.userId,
    required this.applicantName,
    this.applicantTitle,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'coverLetter': coverLetter,
    'portfolioLinks': portfolioLinks,
    'resumeLink': resumeLink,
    'telegramUsername': telegramUsername,
    'email': email,
    'phoneNo': phoneNo,
    'jobId': jobId,
    'userId': userId,
    'applicantName': applicantName,
    'applicantTitle': applicantTitle,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Application.fromJson(Map<String, dynamic> json) => Application(
    id: json['id'] as String,
    coverLetter: json['coverLetter'] as String,
    portfolioLinks: (json['portfolioLinks'] as List<dynamic>).map((e) => e as String).toList(),
    resumeLink: json['resumeLink'] as String,
    telegramUsername: json['telegramUsername'] as String,
    email: json['email'] as String,
    phoneNo: json['phoneNo'] as String,
    jobId: json['jobId'] as String,
    userId: json['userId'] as String,
    applicantName: json['applicantName'] as String,
    applicantTitle: json['applicantTitle'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );

  Application copyWith({
    String? id,
    String? coverLetter,
    List<String>? portfolioLinks,
    String? resumeLink,
    String? telegramUsername,
    String? email,
    String? phoneNo,
    String? jobId,
    String? userId,
    String? applicantName,
    String? applicantTitle,
    DateTime? createdAt,
  }) => Application(
    id: id ?? this.id,
    coverLetter: coverLetter ?? this.coverLetter,
    portfolioLinks: portfolioLinks ?? this.portfolioLinks,
    resumeLink: resumeLink ?? this.resumeLink,
    telegramUsername: telegramUsername ?? this.telegramUsername,
    email: email ?? this.email,
    phoneNo: phoneNo ?? this.phoneNo,
    jobId: jobId ?? this.jobId,
    userId: userId ?? this.userId,
    applicantName: applicantName ?? this.applicantName,
    applicantTitle: applicantTitle ?? this.applicantTitle,
    createdAt: createdAt ?? this.createdAt,
  );
}
