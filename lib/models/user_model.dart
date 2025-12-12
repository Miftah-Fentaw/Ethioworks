class User {
 final String name;
  final String email;
  final String password;
  final String phone;
  final String profession;
  final String about;
  final String education;
  final String? websiteurl;



  User ({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.profession,
    required this.about,
    required this.education,
    this.websiteurl,
  });
}
