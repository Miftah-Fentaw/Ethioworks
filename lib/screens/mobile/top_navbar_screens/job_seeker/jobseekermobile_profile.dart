import 'package:flutter/material.dart';

class JobseekermobileProfile extends StatelessWidget {
  const JobseekermobileProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: () {},
          )
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile header
            Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1976d2),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "A",
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 15),
                const Text("Abebe Kebede",
                    style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                const Text("Flutter Developer",
                    style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 5),
                const Text("Addis Ababa, Ethiopia",
                    style: TextStyle(color: Colors.black54)),
              ],
            ),

            const SizedBox(height: 20),

            // About Me
            _section(
              title: "About Me",
              child: const Text(
                "Passionate mobile developer with 3+ years of experience building cross-platform apps using Flutter. Skilled in Dart, Firebase, and state management.",
              ),
            ),

            // Skills
            _section(
              title: "Skills",
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  _SkillChip("Flutter"),
                  _SkillChip("Dart"),
                  _SkillChip("Firebase"),
                  _SkillChip("REST APIs"),
                  _SkillChip("Git"),
                  _SkillChip("UI/UX Design"),
                ],
              ),
            ),

            // Experience
            _section(
              title: "Experience",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Mobile Developer — Tech Solutions PLC\nJan 2023 – Present",
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Junior Developer — Digital Ethiopia\nJun 2021 – Dec 2022",
                  ),
                ],
              ),
            ),

            // Education
            _section(
              title: "Education",
              child: const Text(
                "BSc in Computer Science\nAddis Ababa University\n2017 – 2021",
              ),
            ),
          ],
        ),
      ),

      // Bottom nav
      bottomNavigationBar: Container(
        height: 70,
        decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            _BottomItem(icon: Icons.home, label: "Home"),
            _BottomItem(icon: Icons.work, label: "Jobs"),
            _BottomItem(icon: Icons.dashboard, label: "Dashboard"),
            _BottomItem(
                icon: Icons.person, label: "Profile", active: true),
          ],
        ),
      ),
    );
  }

  // Reusable section box
  Widget _section({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          child
        ],
      ),
    );
  }
}

// SKILL CHIP
class _SkillChip extends StatelessWidget {
  final String text;
  const _SkillChip(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xffe3f2fd),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: const TextStyle(color: Color(0xff1976d2))),
    );
  }
}

// BOTTOM NAV ITEM
class _BottomItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _BottomItem(
      {required this.icon, required this.label, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 28, color: active ? Colors.blue : Colors.grey),
        Text(label,
            style: TextStyle(
                color: active ? Colors.blue : Colors.grey, fontSize: 12)),
      ],
    );
  }
}
