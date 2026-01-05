import 'package:ethioworks/widgets/web_landing_page_widgets/landing_page_widgets.dart';
import 'package:flutter/material.dart';

class WebCategoriesSection extends StatelessWidget {
  const WebCategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 100),
      child: Column(
        children: [
          Text(
            'Explore by Category',
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Find the job that fits you best from various industries',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 64),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 24,
            crossAxisSpacing: 24,
            childAspectRatio: 1.5,
            children: [
              CategoryCard(
                  icon: Icons.computer,
                  title: 'Technology',
                  jobs: '1,200+ Jobs'),
              CategoryCard(
                  icon: Icons.account_balance,
                  title: 'Finance',
                  jobs: '850+ Jobs'),
              CategoryCard(
                  icon: Icons.medical_services,
                  title: 'Healthcare',
                  jobs: '450+ Jobs'),
              CategoryCard(
                  icon: Icons.architecture,
                  title: 'Engineering',
                  jobs: '600+ Jobs'),
              CategoryCard(
                  icon: Icons.campaign, title: 'Marketing', jobs: '300+ Jobs'),
              CategoryCard(
                  icon: Icons.school, title: 'Education', jobs: '200+ Jobs'),
              CategoryCard(
                  icon: Icons.shopping_bag, title: 'Sales', jobs: '900+ Jobs'),
              CategoryCard(
                  icon: Icons.support_agent,
                  title: 'Customer Service',
                  jobs: '1,100+ Jobs'),
            ],
          ),
        ],
      ),
    );
  }
}