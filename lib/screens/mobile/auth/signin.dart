import 'package:flutter/material.dart';
import '../top_navbar_screens/job_seeker/jobseekermobile_home.dart';
import 'forgot_password.dart';
import 'signup.dart';

class SigninPage extends StatelessWidget {
  const SigninPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: Center(
        child: Container(
          width: 480,
          color: Colors.white,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              children: [
                const Text("JobFinder",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue)),
                const SizedBox(height: 8),
                const Text("Welcome back!", style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 40),

                _input("Email"),
                const SizedBox(height: 20),
                _input("Password", isPass: true),
                const SizedBox(height: 20),

                _primaryBtn("Sign In", context),

                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                  ),
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
                  ),
                ),

                _or(),
                _socialRow(),

                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () => Navigator.push(
                      context, MaterialPageRoute(builder: (_) => const SignupPage())),
                  child: const Text(
                    "Don't have an account? Sign Up",
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _input(String label, {bool isPass = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          obscureText: isPass,
          decoration: InputDecoration(
            hintText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _primaryBtn(String text, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Demo only")));
          Navigator.push(context, MaterialPageRoute(builder: (_) => const JobSeekerMobileHome()));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(text,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _or() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: const [
          Expanded(child: Divider(color: Colors.grey)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text("OR", style: TextStyle(color: Colors.grey)),
          ),
          Expanded(child: Divider(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _socialRow() {
    return Row(
      children: [
        _social("Google"),
        const SizedBox(width: 15),
        _social("Apple"),
        const SizedBox(width: 15),
        _social("LinkedIn"),
      ],
    );
  }

  Widget _social(String name) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(name),
      ),
    );
  }
}
