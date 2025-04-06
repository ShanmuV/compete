import 'package:compete/backend/auth_provider.dart';
import 'package:compete/notifcations.dart';
import 'package:compete/pages/event_creation_page.dart';
import 'package:compete/pages/admin_login_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './extensions/extensions.dart';
import './pages/home_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  requestNotificationPermission();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData.dark(useMaterial3: true),
    );
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool inLoginPage = true;
  void switchPage() {
    setState(() {
      inLoginPage = !inLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 400,
                minHeight: 400,
                maxWidth: 400,
                maxHeight: 400,
              ),
              child:
                  inLoginPage
                      ? LoginPage(switchPage: switchPage)
                      : SignUpPage(switchPage: switchPage),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  final VoidCallback switchPage;
  const LoginPage({super.key, required this.switchPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Log In",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: context.percentHeight(0.02)),
          TextField(
            decoration: InputDecoration(
              hintText: "Email",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: context.percentHeight(0.02)),
          TextField(
            decoration: InputDecoration(
              hintText: "Password",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: context.percentHeight(0.02)),
          ElevatedButton(onPressed: () => {}, child: Text("Log In")),
          SizedBox(height: context.percentHeight(0.02)),
          RichText(
            text: TextSpan(
              text: "Don't have an account? ",
              style: TextStyle(color: Colors.grey),
              children: [
                TextSpan(
                  text: "Sign Up",
                  style: TextStyle(color: Colors.grey),
                  recognizer: TapGestureRecognizer()..onTap = widget.switchPage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SignUpPage extends StatefulWidget {
  final VoidCallback switchPage;
  const SignUpPage({super.key, required this.switchPage});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Sign Up",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: context.percentHeight(0.02)),
          TextField(
            decoration: InputDecoration(
              hintText: "Email",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: context.percentHeight(0.02)),
          TextField(
            decoration: InputDecoration(
              hintText: "Password",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: context.percentHeight(0.02)),
          TextField(
            decoration: InputDecoration(
              hintText: "Confirm Password",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: context.percentHeight(0.02)),
          ElevatedButton(onPressed: () => {}, child: Text("Sign Up")),
          SizedBox(height: context.percentHeight(0.02)),
          RichText(
            text: TextSpan(
              text: "Already Have an Account? ",
              style: TextStyle(color: Colors.grey),
              children: [
                TextSpan(
                  text: "Log In",
                  style: TextStyle(color: Colors.grey),
                  recognizer: TapGestureRecognizer()..onTap = widget.switchPage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    bool isAdmin = Provider.of<AuthProvider>(context).isAdmin;
    return SizedBox(
      height: 70,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset("logo.png", fit: BoxFit.cover),
            Text(
              "Event Management System",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            isAdmin
                ? SizedBox(
                  height: 35,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (contex) => EventCreationPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amberAccent,
                      foregroundColor: Colors.black,
                    ),
                    child: Text("Create a new Event"),
                  ),
                )
                : SizedBox(
                  height: 35,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AdminLoginPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amberAccent,
                      foregroundColor: Colors.black,
                    ),
                    child: Text("Login as a Teacher"),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
