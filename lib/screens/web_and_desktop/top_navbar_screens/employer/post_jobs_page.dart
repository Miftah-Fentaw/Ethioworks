import 'package:flutter/material.dart';

class PostJobsPage extends StatelessWidget {
  const PostJobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 0),
        padding: const EdgeInsets.symmetric(horizontal: 0),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
          child: Column(
            children: [

              // Body
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTwoFields(
                        "Job Title *",
                        "e.g. Senior React Developer",
                        "Company Name *",
                        "Google, Tesla, etc.",
                      ),

                      const SizedBox(height: 20),

                      buildTwoFields(
                        "Location *",
                        "Addis Ababa, Remote...",
                        "Employment Type",
                        "",
                        isDropdown: true,
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        "Work Type",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          buildWorkType("On-site", Icons.apartment, true),
                          const SizedBox(width: 16),
                          buildWorkType("Hybrid", Icons.home, false),
                          const SizedBox(width: 16),
                          buildWorkType("Remote", Icons.laptop_mac, false),
                        ],
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        "Salary Range (optional)",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: buildTextField("Min: \$50,000")),
                          const SizedBox(width: 16),
                          Expanded(child: buildTextField("Max: \$80,000")),
                        ],
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        "Job Description *",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        maxLines: 8,
                        decoration: InputDecoration(
                          hintText: "Describe the role, responsibilities...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.all(14),
                        ),
                      ),

                      const SizedBox(height: 25),

                      const Text(
                        "How to Apply *",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      buildTextField("example@company.com or https://apply.com/job-id"),

                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {},
                            child: const Text(
                              "Save as Draft",
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(width: 14),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 28),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () {},
                            child: const Text(
                              "Post Job Now",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  Widget buildTwoFields(
    String title1,
    String hint1,
    String title2,
    String hint2, {
    bool isDropdown = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title1, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              buildTextField(hint1),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title2, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              isDropdown
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: "Full-time",
                          items: const [
                            DropdownMenuItem(value: "Full-time", child: Text("Full-time")),
                            DropdownMenuItem(value: "Part-time", child: Text("Part-time")),
                            DropdownMenuItem(value: "Contract", child: Text("Contract")),
                            DropdownMenuItem(value: "Internship", child: Text("Internship")),
                            DropdownMenuItem(value: "Freelance", child: Text("Freelance")),
                          ],
                          onChanged: (value) {},
                        ),
                      ),
                    )
                  : buildTextField(hint2),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTextField(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.all(14),
      ),
    );
  }

  Widget buildWorkType(String title, IconData icon, bool selected) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: selected ? Colors.blue : Colors.grey.shade400, width: selected ? 2 : 1),
          color: selected ? Colors.blue.withOpacity(0.1) : Colors.white,
        ),
        child: Row(
          children: [
            Icon(icon, size: 28, color: Colors.grey.shade600),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
