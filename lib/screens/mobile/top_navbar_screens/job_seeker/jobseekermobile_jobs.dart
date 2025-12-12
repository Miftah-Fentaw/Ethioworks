import 'package:flutter/material.dart';

class JobseekermobileJobs extends StatelessWidget {
  const JobseekermobileJobs({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "All Jobs",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              // Filters
              SizedBox(
                height: 45,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    _FilterChip("Full-time"),
                    _FilterChip("Addis Ababa"),
                    _FilterChip("IT & Tech"),
                    _FilterChip("Remote"),
                    _FilterChip("Fresh Graduate"),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Job Cards
              _JobCard(
                title: "Senior Flutter Developer",
                company: "Awash Bank",
                meta: "Addis Ababa • Full-time • ETB 35,000 - 50,000",
                tags: ["Flutter", "Dart", "Mobile"],
              ),

              _JobCard(
                title: "Backend Engineer (Node.js)",
                company: "Kifiya Financial Tech",
                meta: "Addis Ababa • Full-time",
                tags: ["Node.js", "AWS"],
              ),

              _JobCard(
                title: "Data Analyst",
                company: "Ethiopian Airlines",
                meta: "Addis Ababa • Full-time",
                tags: ["Python", "SQL"],
              ),

              _JobCard(
                title: "UI/UX Designer",
                company: "Telebirr",
                meta: "Remote • Contract",
                tags: ["Figma", "Remote"],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  const _FilterChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 3, offset: Offset(0, 1)),
        ],
      ),
      child: Text(label, style: const TextStyle(fontSize: 14)),
    );
  }
}

class _JobCard extends StatelessWidget {
  final String title;
  final String company;
  final String meta;
  final List<String> tags;

  const _JobCard({
    required this.title,
    required this.company,
    required this.meta,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(company, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 5),
          Text(meta),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            children: tags
                .map((t) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xffe3f2fd),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        t,
                        style: const TextStyle(
                          color: Color(0xff1976d2),
                          fontSize: 12,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
