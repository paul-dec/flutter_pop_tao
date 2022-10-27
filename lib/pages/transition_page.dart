import 'package:bored_board/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TransitionPage extends StatefulWidget {
  final User? user;
  final Map<String, dynamic>? collectionUser;

  const TransitionPage(
      {Key? key, required this.user, required this.collectionUser})
      : super(key: key);

  @override
  State<TransitionPage> createState() => _State();
}

class _State extends State<TransitionPage> with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  );

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomePage(
                  user: widget.user,
                  collectionUser: widget.collectionUser,
                )));
      }
    });
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 46, 55, 71),
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          child: Container(width: 180, height: 180, color: Colors.blue),
          builder: (context, child) {
            return Transform.rotate(
              angle: 1 * 3.14 * _animationController.value,
              child: child,
            );
          },
        ),
      ),
    );
  }
}
