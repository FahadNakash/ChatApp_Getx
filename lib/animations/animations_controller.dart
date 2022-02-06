import 'package:flutter/animation.dart';
class CustomAnimationController{
late final AnimationController controller;
late final Animation<double> bgOpacity;
late final Animation<double> bgDropOpacity;
late final Animation<double> titleOpacity;
late final Animation<double> formOpacity;
CustomAnimationController(this.controller):
     bgOpacity=Tween(begin: 0.0,end: 1.0).animate(CurvedAnimation(parent: controller, curve: Interval(0.000,0.500,curve: Curves.easeIn)));
}
