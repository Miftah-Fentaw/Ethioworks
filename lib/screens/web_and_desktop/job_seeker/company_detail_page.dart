import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ethioworks/models/employer_model.dart';
import 'package:ethioworks/models/job_post_model.dart';
import 'package:ethioworks/providers/job_provider.dart';
import 'package:ethioworks/providers/auth_provider.dart';
import 'package:ethioworks/services/job_seeker_service.dart';
import 'package:ethioworks/widgets/profile_avatar.dart';
import 'package:ethioworks/widgets/custom_button.dart';
import 'package:ethioworks/theme.dart';
import 'package:ethioworks/screens/web_and_desktop/job_seeker/job_detail_page.dart';

class CompanyDetailScreen extends StatefulWidget {
  final Employer employer;

  const CompanyDetailScreen({super.key, required this.employer});

  @override
  State<CompanyDetailScreen> createState() => _CompanyDetailScreenState();
}

class _CompanyDetailScreenState extends State<CompanyDetailScreen> {
  bool _loading = true;
  List<JobPost> _companyJobs = [];
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final jobProvider = context.read<JobProvider>();
    final authProvider = context.read<AuthProvider>();
    final seeker = authProvider.currentJobSeeker;

    await jobProvider.loadEmployerJobs(widget.employer.id);

    if (mounted) {
      setState(() {
        _companyJobs = jobProvider
            .jobs; // Assuming loadEmployerJobs updates the list in provider
        _loading = false;
        if (seeker != null) {
          _isFollowing = seeker.followedCompanies.contains(widget.employer.id);
        }
      });
    }
  }

  Future<void> _toggleFollow() async {
    final authProvider = context.read<AuthProvider>();
    final seeker = authProvider.currentJobSeeker;

    if (seeker == null) return;

    final service = JobSeekerService();
    bool success;

    if (_isFollowing) {
      success = await service.unfollowCompany(seeker.id, widget.employer.id);
    } else {
      success = await service.followCompany(seeker.id, widget.employer.id);
    }

    if (success) {
      final updatedSeeker = await service.getProfile(seeker.id);
      if (updatedSeeker != null) {
        await authProvider.updateUser(updatedSeeker);
      }
      setState(() => _isFollowing = !_isFollowing);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.employer.companyOrPersonalName)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Container(
            margin: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              padding: AppSpacing.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        ProfileAvatar(
                          imageUrl: widget.employer.profilePic,
                          name: widget.employer.companyOrPersonalName,
                          size: 100,
                          avatarType: AvatarType.company,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          widget.employer.companyOrPersonalName,
                          style: theme.textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          '${widget.employer.followers} Followers',
                          style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        CustomButton(
                          text: _isFollowing ? 'Following' : 'Follow',
                          icon: _isFollowing ? Icons.check : Icons.add,
                          onPressed: _toggleFollow,
                          isOutlined: _isFollowing,
                          backgroundColor: _isFollowing
                              ? Colors.transparent
                              : theme.colorScheme.primary,
                          textColor: _isFollowing
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onPrimary,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  if (widget.employer.description != null &&
                      widget.employer.description!.isNotEmpty) ...[
                    Text('About',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: AppSpacing.sm),
                    Text(widget.employer.description!,
                        style: theme.textTheme.bodyMedium),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                  Text('Active Jobs',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppSpacing.md),
                  _loading
                      ? const Center(child: CircularProgressIndicator())
                      : _companyJobs.isEmpty
                          ? const Center(child: Text('No active jobs'))
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _companyJobs.length,
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemBuilder: (context, index) {
                                final job = _companyJobs[index];
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(job.title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Text(
                                      '${job.location} • ${job.locationType.name}'),
                                  trailing: const Icon(Icons.arrow_forward_ios,
                                      size: 16),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            JobDetailScreen(jobId: job.id),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
