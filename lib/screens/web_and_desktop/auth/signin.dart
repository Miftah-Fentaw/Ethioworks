// lib/signin_page.dart
import 'package:ethioworks/screens/web_and_desktop/top_navbar_screens/employer/home_page.dart';
import 'package:ethioworks/screens/web_and_desktop/top_navbar_screens/job_seeker/home_page.dart' hide HomePage;
import 'package:ethioworks/screens/web_and_desktop/auth/signup.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Row(
        children: [
          // LEFT — Form (visible on all screens)
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ETHIOWORKS',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..shader = const LinearGradient(
                          colors: [Color(0xFF0052CC), Color(0xFF00AEEF)],
                        ).createShader(const Rect.fromLTWH(0, 0, 300, 70)),
                    ),
                  ),
                  const Text(
                    "Ethiopia's #1 Job Platform",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 40),

                  const Text("Welcome back!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const Text("Sign in to continue your job search", style: TextStyle(color: Colors.grey)),

                  const SizedBox(height: 30),

                  TextField(
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                  ),
                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(value: true, onChanged: (_) {}),
                          const Text("Keep me signed in"),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text("Forgot password?", style: TextStyle(color: Color(0xFF0052CC))),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0052CC),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Sign In", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white)),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Center(child: Text("Or sign in with")),

                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: Image.network("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAT4AAACfCAMAAABX0UX9AAAApVBMVEX/////ugD4UQx+ugAAo/R0tQD/+/n4PwD5/f///fkAnPMAoPT/uAD/tQD+5d7r8974SgD6l3qv03f8s5/E3pxLtvb/yEt3xfj/03dxcXHq6uqioqKOjo6AgIDJycnT09Oqqqrz8/Pf39++vr6Xl5eFhYWnp6e1tbV5eXlsbGzk5OSSkpKcnJz+7unx9+j3KwD6kHBpsQD9zsDZ6r6R0fn/3JH/xDie1Ba2AAAD3klEQVR4nO3c2ZLTRgBG4SYBQ1gSQsLS2mXJkmyJfXn/R6MXyXZRVIXhByYene9iENZS1pluSfbFGIP/qz8lL5fDvPpLcp0FFJvXdxVvluM8uaN4+8d1NhBs7v4mePz3cpwnvyvukI985Lsq8knIJyGfhHwS8knIJyGfhHwS8knIJyGfhHwS8knIJyGfhHwS8knIJyGfhHwS8knIJyGfhHwS8knIJyGfhHwS8knIJyGfhHwS8knIJyGfhHwS8knIJyGfhHwS8knIJyGfhHwS8knIJyGfhHwS8knIJyGfhHwS8knIJyGfhHwS8kk2rx8LVv8nwMw/knfLYd7/K7nOAgAAAMB/ufdU8mE5zsdnik+X+qnj3v0HgvvPl+O8eKh4dLn5bgsenOW7JSAf+ch3ZeSTkE9CPgn5JOSTkE9CPgn5JOSTkE9CPgn5JOSTkE9CPgn5JOSTkE9CPgn5JOSTkE9CPgn5JOSTkE9CPgn5JOSTkE9CPgn5JOSTkE9CPgn5JOSTkE9CPgn5JOSTkE9CPgn5JOSTkE9CPgn5JOSTkE9CPgn5JOSTkE9CPgn5JOST/Lh8X3Prpv8JMAAAcFPV2/q638Iv1PSH43Ld9+5nb0vheJ21Vn5TlyMbpuNyP/gzH/f99x+usWm5db+IZqu/tUuQ5cNxsuX54P9RzjyNQy9RfgWXxOVbzrQcYj5FGo9Q27XkG9t8XhzzMHbKKQzHpNrlaRiIVW/6fGf8tXGXT/OF0a+e5nFatHnW+52K1O3jtqimIUsnswLZWM63isQ2lc9X7BP3s7RD2uW2cYu7cRqm1k1q91K1s53f2C1X/S7uOdqsmuzg9mpa17QtTOp6+j1uviwzwxiWKluH0VfYxLfM/HBq9wd/d0n9+s2Q+5f6kDSMRrcm7Fe4n4chvLK6yZu5IH64maE1p3xVfK3uyjmSv6nGubpz/93YUNTnrG2cpUUYinO+ZEX54lDxp3/Kl2dnm8SL4zjfVxp78A2Lee0y9+swq1eYz7T+nH2kU76hO9sk5svjHHeXPdcrya0dez9CmzhO3Xp/sVtjvtJdvQ7+kvZN+ebhVro7h9+HfH6qdrY2V5i8QZ25TZm8/q4Q7q6nfN1860jLY77zW4eJ3wv4dKu/dbhK7vOGb3PKVy8PLskx3/mDy2Ef7rytH7LxwSX54sFlFU99cz531vHk92Z5bC78Y/MQH5vnjyVbayf32BzCdXZXudVhjPnH5jY8NhszzV+3pHbIzQqE76jMoQsXsMZfvrZp/NDWj1kVpmtfzdvW7qVu/qBWdtlYLctp1jZxsVluOUWabn7+uz/5DBZhMdA81HiDAAAAAElFTkSuQmCC", height: 24),
                          label: const Text("Microsoft"),
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: Image.network("data:image/png;base64,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", height: 24),
                          label: const Text("Google"),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpPage())),
                      child: const Text.rich(
                        TextSpan(text: "Don't have an account? ", children: [
                          TextSpan(text: "Sign up free", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0052CC))),
                        ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // RIGHT — Hero (hidden on mobile)
          if (size.width > 900)
            Expanded(
              flex: 6,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?ixlib=rb-4.0.3&auto=format&fit=crop&q=80',
                    fit: BoxFit.cover,
                  ),
                  Container(color: Colors.black.withOpacity(0.4)),
                  Padding(
                    padding: const EdgeInsets.all(50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.work, size: 90, color: Color(0xFFFCDB00)),
                        const SizedBox(height: 20),
                        const Text(
                          "Find Your Dream Job\nin Ethiopia",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Connect with top companies in Addis Ababa,\nMekelle, Hawassa, Bahir Dar and beyond.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, color: Colors.white70),
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            _StatCard(number: "50K+", label: "Active Jobs"),
                            _StatCard(number: "25K+", label: "Companies"),
                            _StatCard(number: "1M+", label: "Job Seekers"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String number;
  final String label;
  const _StatCard({required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(number, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFFCDB00))),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}