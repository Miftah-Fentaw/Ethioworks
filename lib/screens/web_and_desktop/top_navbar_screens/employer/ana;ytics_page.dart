import 'package:flutter/material.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Analytics Page",
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
