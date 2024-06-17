import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_excercise_correction/notification.dart';

class AccountPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _logout(BuildContext context) async {
    try {
      await FirebaseAPI().unsubscribeFromTopics();
      await _auth.signOut();
      // Chuyển người dùng đến trang đăng nhập sau khi đăng xuất thành công
      Navigator.popUntil(context, ModalRoute.withName('/'));
    } catch (e) {
      print('Đăng xuất thất bại: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng xuất'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bạn có chắc chắn muốn đăng xuất?'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: Text('Đăng xuất'),
            ),
          ],
        ),
      ),
    );
  }
}
