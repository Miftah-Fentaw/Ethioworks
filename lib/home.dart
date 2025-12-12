import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        title: Row(
          children: [
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: 'E',
                    style: TextStyle(color: Color.fromARGB(255, 0, 255, 76)),
                  ),
                  TextSpan(
                    text: 'THIO',
                    style: TextStyle(color: Color(0xFFFCDB00)),
                  ),
                  TextSpan(
                    text: 'WORKS',
                    style: TextStyle(color: Color.fromARGB(255, 255, 0, 0)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "Ethiopia's #1 Job Platform",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 80),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0052CC), Color(0xFF00AEEF)],
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    "Find Your Dream Job in Ethiopia",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Connect with top companies in Addis Ababa, Mekelle, Hawassa, Bahir Dar and beyond.",
                    style: TextStyle(fontSize: 24, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  // Search Bar
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 20),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Job title, keywords...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "City, region or remote",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0052CC),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 20,
                            ),
                          ),
                          child: const Text(
                            "Search Jobs",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStat("50K+", "Active Jobs"),
                      _buildStat("25K+", "Companies"),
                      _buildStat("1M+", "Job Seekers"),
                    ],
                  ),
                ],
              ),
            ),

            // Opportunities Images Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 64),
              child: Column(
                children: [
                  const Text(
                    "Opportunities Across Ethiopia",
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 24,
                    crossAxisSpacing: 24,
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    childAspectRatio: 1.5,
                    children:
                        [
                              Image.asset(
                                "assets/images/image1.jpg",
                              ),

                              Image.asset(
                                "assets/images/image2.jpg",
                              ),

                              Image.asset(
                                "assets/images/image3.jpg",
                              ),

                              Image.asset(
                                "assets/images/image4.jpg",
                              ),

                              Image.asset(
                                "assets/images/image5.jpg",
                              ),

                              Image.asset(
                                "assets/images/image6.jpg",
                              ),
                            ]
                            .map(
                              (widget) => ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: widget,
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
            ),

            // Call to Action
            Container(
              padding: const EdgeInsets.symmetric(vertical: 80),
              color: Colors.grey[100],
              child: Column(
                children: [
                  const Text(
                    "Ready to Start Your Journey?",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Join thousands of job seekers finding their perfect role every day.",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            255,
                            255,
                            255,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 20,
                          ),
                        ),
                        child: const Text(
                          "Browse Jobs",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF0052CC),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF0052CC),
                          side: const BorderSide(color: Color(0xFF0052CC)),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 20,
                          ),
                        ),
                        child: const Text(
                          "Post a Job",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.symmetric(vertical: 48),
              color: Colors.grey[900],
              child: Column(
                children: [
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: 'e',
                          style: TextStyle(color: Color(0xFF0052CC)),
                        ),
                        TextSpan(
                          text: 'THIO',
                          style: TextStyle(color: Color(0xFFFCDB00)),
                        ),
                        TextSpan(
                          text: 'WORKS',
                          style: TextStyle(color: Color(0xFF00A651)),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    "Ethiopia's #1 Job Platform © 2025. All rights reserved.",
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.facebook),
                        color: Colors.white70,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.facebook),
                        color: Colors.white70,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.facebook),
                        color: Colors.white70,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String number, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFCDB00),
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 18, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
