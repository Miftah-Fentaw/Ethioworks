import 'package:flutter/material.dart';
import 'package:ethioworks/services/application_service.dart';
import 'package:ethioworks/providers/auth_provider.dart';
import 'package:ethioworks/providers/job_provider.dart';
import 'package:provider/provider.dart';
import 'package:ethioworks/models/application_model.dart';
import 'package:ethioworks/widgets/profile_avatar.dart';

class AllApplicantsScreen extends StatefulWidget {
  const AllApplicantsScreen({super.key});

  @override
  State<AllApplicantsScreen> createState() => _AllApplicantsScreenState();
}

class _AllApplicantsScreenState extends State<AllApplicantsScreen> {
  final ApplicationService _service = ApplicationService();
  List<Application> _applications = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final jobProvider = context.read<JobProvider>();
    final auth = context.read<AuthProvider>();
    final employer = auth.currentEmployer;
    if (employer == null) {
      if (mounted) setState(() { _applications = []; _loading = false; });
      return;
    }

    final jobs = jobProvider.jobs.where((j) => j.employerId == employer.id).toList();
    final apps = <Application>[];
    for (final job in jobs) {
      final list = await _service.getApplicationsByJob(job.id);
      apps.addAll(list);
    }

    if (mounted) setState(() { _applications = apps; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: const Text('Applicants')),
      body: _applications.isEmpty
          ? const Center(child: Text('No applicants yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _applications.length,
              itemBuilder: (context, i) {
                final a = _applications[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: ProfileAvatar(imageUrl: null, name: a.applicantName, size: 48),
                    title: Text(a.applicantName),
                    subtitle: Text(a.email),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                );
              },
            ),
    );
  }
}
