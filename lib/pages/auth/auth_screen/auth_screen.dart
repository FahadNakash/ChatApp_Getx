import '../widgets/form.dart';
import 'package:flutter/material.dart';
class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}
class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  @override
  void initState() {
    controller=AnimationController(vsync:this,duration: Duration(milliseconds: 2000));
    controller.forward();
    super.initState();
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
        children:[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple.withOpacity(0.2),
                  Colors.purpleAccent,
                  Colors.deepPurple.withOpacity(0.2)
                ],
                begin:Alignment.topLeft,
                end: Alignment.bottomRight
              )
            ),
            child: AuthForm(controller)
          ),
    ]
      ),
    );
  }
}
