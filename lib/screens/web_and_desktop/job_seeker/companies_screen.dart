import 'package:flutter/material.dart';
import 'package:ethioworks/services/employer_service.dart';
import 'package:ethioworks/models/employer_model.dart';
import 'package:ethioworks/widgets/profile_avatar.dart';
import 'package:ethioworks/screens/web_and_desktop/job_seeker/company_detail_page.dart';

class CompaniesScreen extends StatefulWidget {
  const CompaniesScreen({super.key});

  @override
  State<CompaniesScreen> createState() => _CompaniesScreenState();
}

class _CompaniesScreenState extends State<CompaniesScreen> {
  final EmployerService _service = EmployerService();
  List<Employer> _companies = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final items = await _service.getAllEmployers();
    if (mounted)
      setState(() {
        _companies = items;
        _loading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: const Text('Companies')),
      body: _companies.isEmpty
          ? const Center(child: Text('No companies found'))
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _companies.length,
                  itemBuilder: (context, i) {
                    final c = _companies[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CompanyDetailScreen(employer: c),
                            ),
                          );
                        },
                        leading: ProfileAvatar(
                            imageUrl: c.profilePic,
                            name: c.companyOrPersonalName,
                            size: 48,
                            avatarType: AvatarType.company),
                        title: Text(c.companyOrPersonalName),
                        subtitle: Text('${c.followers} followers'),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
