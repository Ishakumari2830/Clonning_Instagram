import 'package:flutter/material.dart';

class likeAnimation extends StatefulWidget {
  final Widget child;
  final bool isAnimating;
  final Duration duration;
  final VoidCallback? onEnd;
  final bool smallLike;


  const likeAnimation(
      {super.key, required this.child, required this.isAnimating, this.duration = const Duration(
          milliseconds: 150), this.onEnd,  this.smallLike= false,});

  @override
  State<likeAnimation> createState() => _likeAnimationState();
}

class _likeAnimationState extends State<likeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(microseconds: widget.duration.inMilliseconds ~/ 2),);
    //will divide by 2 and cnvrt into int
    scale = Tween<double>(begin: 1,end: 1.2).animate(controller);
  }
  
  void didUpdateWidget(covariant likeAnimation oldWidget){
    super.didUpdateWidget(oldWidget);
    
    if(widget.isAnimating != oldWidget.isAnimating){
      startAnimation();
    }
  }

  
  startAnimation() async{
    if(widget.isAnimating || widget.smallLike){
      await controller.forward();
      await controller.reverse();
      await Future.delayed(const Duration(milliseconds: 100),);
      
      if(widget.onEnd != null){
        widget.onEnd!();
      }
    }
  }
  
  @override
  void dispose() {
  
    super.dispose();
    controller.dispose();
  }
  
  

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: scale,child: widget.child,);
  }
}
