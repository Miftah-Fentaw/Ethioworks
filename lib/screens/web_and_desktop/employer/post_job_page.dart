import 'package:ethioworks/screens/web_and_desktop/employer/employer_root.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ethioworks/models/job_post_model.dart';
import 'package:ethioworks/providers/auth_provider.dart';
import 'package:ethioworks/providers/job_provider.dart';
import 'package:ethioworks/widgets/custom_button.dart';
import 'package:ethioworks/widgets/custom_text.dart';
import 'package:ethioworks/utils/validator.dart';
import 'package:ethioworks/theme.dart';

class PostJobScreen extends StatefulWidget {
  final JobPost? jobToEdit;

  const PostJobScreen({super.key, this.jobToEdit});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _salaryController = TextEditingController();
  final _rolesController = TextEditingController();
  final _skillsController = TextEditingController();
  final _educationController = TextEditingController();

  LocationType _selectedLocationType = LocationType.remote;

  @override
  void initState() {
    super.initState();
    if (widget.jobToEdit != null) {
      final job = widget.jobToEdit!;
      _titleController.text = job.title;
      _descriptionController.text = job.description;
      _locationController.text = job.location ?? '';
      _salaryController.text = job.salary;
      _rolesController.text = job.roles.join(', ');
      _skillsController.text = job.expectedSkills.join(', ');
      _educationController.text = job.education;
      _selectedLocationType = job.locationType;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _salaryController.dispose();
    _rolesController.dispose();
    _skillsController.dispose();
    _educationController.dispose();
    super.dispose();
  }

  Future<void> _submitJob() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final jobProvider = context.read<JobProvider>();
    final employer = authProvider.currentEmployer;

    if (employer == null) return;

    final roles = _rolesController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    final skills = _skillsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final job = JobPost(
      id: widget.jobToEdit?.id ?? '',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      locationType: _selectedLocationType,
      location: _locationController.text.isEmpty
          ? null
          : _locationController.text.trim(),
      salary: _salaryController.text.trim(),
      roles: roles,
      expectedSkills: skills,
      education: _educationController.text.trim(),
      employerId: employer.id,
      companyName: employer.companyOrPersonalName,
      companyProfilePic: employer.profilePic,
      createdAt: widget.jobToEdit?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
      likes: widget.jobToEdit?.likes ?? 0,
      dislikes: widget.jobToEdit?.dislikes ?? 0,
    );

    bool success;
    if (widget.jobToEdit != null) {
      success = await jobProvider.updateJob(job);
    } else {
      success = await jobProvider.createJob(job);
    }

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.jobToEdit != null
              ? 'Job updated successfully!'
              : 'Job posted successfully!'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
      //back to homepage
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const EmployerRoot()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(jobProvider.errorMessage ?? 'Failed to post job'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final jobProvider = context.watch<JobProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.jobToEdit != null ? 'Edit Job' : 'Post a Job'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            padding: AppSpacing.paddingLg,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextField(
                    label: 'Job Title *',
                    hint: 'e.g., Senior software Developer',
                    controller: _titleController,
                    validator: (value) =>
                        Validators.validateRequired(value, 'Job title'),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  CustomTextField(
                    label: 'Job Description *',
                    hint: 'Describe the role and responsibilities...',
                    controller: _descriptionController,
                    maxLines: 6,
                    validator: (value) =>
                        Validators.validateRequired(value, 'Description'),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Location Type *',
                    style: theme.textTheme.labelLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    children: [
                      ChoiceChip(
                        label: const Text('Remote'),
                        selected: _selectedLocationType == LocationType.remote,
                        onSelected: (selected) => setState(
                            () => _selectedLocationType = LocationType.remote),
                      ),
                      ChoiceChip(
                        label: const Text('Hybrid'),
                        selected:
                            _selectedLocationType == LocationType.permanent,
                        onSelected: (selected) => setState(() =>
                            _selectedLocationType = LocationType.permanent),
                      ),
                      ChoiceChip(
                        label: const Text('On-Site'),
                        selected: _selectedLocationType == LocationType.onSite,
                        onSelected: (selected) => setState(
                            () => _selectedLocationType = LocationType.onSite),
                      ),
                    ],
                  ),
                  if (_selectedLocationType == LocationType.onSite) ...[
                    const SizedBox(height: AppSpacing.lg),
                    CustomTextField(
                      label: 'Specific Location',
                      hint: 'e.g., Addis Ababa, Ethiopia',
                      controller: _locationController,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  CustomTextField(
                    label: 'Salary *',
                    hint: 'e.g., 50,000 - 70,000 ETB/month',
                    controller: _salaryController,
                    validator: (value) =>
                        Validators.validateRequired(value, 'Salary'),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  CustomTextField(
                    label: 'Roles & Responsibilities *',
                    hint:
                        'Separate with commas: Design UI, Write code, Review PRs',
                    controller: _rolesController,
                    maxLines: 3,
                    validator: (value) =>
                        Validators.validateRequired(value, 'Roles'),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  CustomTextField(
                    label: 'Required Skills *',
                    hint: 'Separate with commas: communication, teamwork, problem-solving',
                    controller: _skillsController,
                    maxLines: 2,
                    validator: (value) =>
                        Validators.validateRequired(value, 'Skills'),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  CustomTextField(
                    label: 'Education Requirements *',
                    hint: "e.g., Bachelor's in Computer Science or equivalent",
                    controller: _educationController,
                    validator: (value) =>
                        Validators.validateRequired(value, 'Education'),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  CustomButton(
                    text: widget.jobToEdit != null ? 'Update Job' : 'Post Job',
                    icon: Icons.send,
                    onPressed: _submitJob,
                    isLoading: jobProvider.isLoading,
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
