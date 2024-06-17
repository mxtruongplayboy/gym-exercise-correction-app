import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'my_home_page.dart'; // Ensure this file exists and is properly set up

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
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
        title: Text("Register"),
        backgroundColor: Colors.blue[800], // Brick color tone for AppBar
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
                  prefixIcon: Icon(Icons.email, color: Colors.blue[800]),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[800]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[800]!, width: 2),
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
                  prefixIcon: Icon(Icons.lock_outline, color: Colors.blue[800]),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[800]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[800]!, width: 2),
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
                  shadowColor: Colors.blue[800],
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 36),
                ).copyWith(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors.blue[800]!;
                      return Colors.blue[800]!;
                    },
                  ),
                ),
                onPressed: _register,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _register() async {
    // Hiển thị loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      final UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      final User? user = credential.user;
      if (user != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MyHomePage(),
        ));
      }
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop(); // Ẩn loading indicator
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'Mật khẩu quá yếu.';
          break;
        case 'email-already-in-use':
          errorMessage = 'Email đã được sử dụng.';
          break;
        case 'invalid-email':
          errorMessage = 'Địa chỉ email không hợp lệ.';
          break;
        default:
          errorMessage = 'Đăng ký thất bại.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.deepOrange[800],
        ),
      );
    } catch (e) {
      Navigator.of(context).pop(); // Ẩn loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Đã xảy ra lỗi không mong muốn: ${e.toString()}"),
          backgroundColor: Colors.deepOrange[800],
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
