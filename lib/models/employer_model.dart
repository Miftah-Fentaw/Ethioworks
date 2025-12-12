class Employer{
  final String name;
  final String email;
  final String phone;
  final String password;
  final String industry;
  final String? websiteurl;

  Employer({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.industry,
    this.websiteurl,
  });
}