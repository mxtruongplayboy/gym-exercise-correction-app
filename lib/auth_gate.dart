import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_excercise_correction/notification.dart';
import 'package:gym_excercise_correction/register_page.dart';
import 'my_home_page.dart'; // Ensure this file exists and is properly set up

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  AnimationController? _animationController;
  Animation<double>? _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
    );
    _animationController!.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Colors.blue[800], // Blue color tone for AppBar
      ),
      body: FadeTransition(
        opacity: _opacityAnimation!,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email, color: Colors.blue[700]),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[700]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[900]!, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline, color: Colors.blue[700]),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[700]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[900]!, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 10,
                  shadowColor: Colors.blue[900],
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 36),
                ).copyWith(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors.blue[900]!;
                      return Colors.blue[800]!;
                    },
                  ),
                ),
                onPressed: _login,
                child: Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Text('Don\'t have an account? Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _login() async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      print('Starting login process'); // Logging start

      print('Before calling signInWithEmailAndPassword');
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      )
          .then((credential) async {
        print('After calling signInWithEmailAndPassword');
        final User? user = credential.user;
        if (user != null) {
          print('User signed in successfully');
          await Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => MyHomePage(),
          ));
        }
      }).catchError((error) {
        Navigator.of(context).pop(); // Hide loading indicator
        if (error is FirebaseAuthException) {
          print('FirebaseAuthException: ${error.message}');
          String errorMessage;
          switch (error.code) {
            case 'wrong-password':
              errorMessage = 'Incorrect password.';
              break;
            case 'user-not-found':
              errorMessage = 'No user found with this email.';
              break;
            case 'invalid-email':
              errorMessage = 'Invalid email address.';
              break;
            default:
              errorMessage = 'Login failed with email & password.';
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.blue[800],
            ),
          );
        } else {
          print('Unexpected error: ${error.toString()}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text("An unexpected error occurred: ${error.toString()}"),
              backgroundColor: Colors.blue[800],
            ),
          );
        }
      });
    } catch (e) {
      Navigator.of(context).pop(); // Hide loading indicator
      print('Unexpected error: ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An unexpected error occurred: ${e.toString()}"),
          backgroundColor: Colors.blue[800],
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController?.dispose();
    super.dispose();
  }
}
