import 'package:flutter/material.dart';

enum TransitionType {
  slide,
  scale,
  rotation,
  fade,
  toTop,
  toBottom,
  toStart,
  toEnd,
}

class MyRoute<T> extends MaterialPageRoute<T> {
  TransitionType? type;

  MyRoute({required WidgetBuilder builder, this.type, RouteSettings? settings,bool fullscreenDialog=false})
      : super(builder: builder, settings: settings,fullscreenDialog:fullscreenDialog);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.name == '/') return child;

    // Fades between routes. (If you don't want any animation,
    // just return child.)
    switch (type) {
      case TransitionType.fade:
        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
          child: child,
        );
      case TransitionType.rotation:
        return RotationTransition(
          turns: Tween(begin: -1.0, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
          child: ScaleTransition(
            scale: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                parent: animation, curve: Curves.fastOutSlowIn)),
            child: child,
          ),
        );
      case TransitionType.slide:
        return SlideTransition(
          position:
              Tween<Offset>(begin: Offset(-1.0, -1.0), end: Offset(0.0, 0.0))
                  .animate(CurvedAnimation(
                      parent: animation, curve: Curves.easeOutExpo)),
          child: child,
        );
      case TransitionType.scale:
        return ScaleTransition(
          scale: Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
          child: child,
        );
      case TransitionType.toTop:
        return SlideTransition(
          position: new Tween<Offset>(
            begin: Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      case TransitionType.toBottom:
        return SlideTransition(
          position: new Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      case TransitionType.toEnd:
        final TextDirection currentDirection = Directionality.of(context);
        if (currentDirection == TextDirection.rtl)
          return SlideTransition(
            position: new Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        else
          return SlideTransition(
            position: new Tween<Offset>(
              begin: const Offset(-1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );

      case TransitionType.toStart:
        final TextDirection currentDirection = Directionality.of(context);
        if (currentDirection == TextDirection.rtl)
          return SlideTransition(
            position: new Tween<Offset>(
              begin: const Offset(-1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        else
          return SlideTransition(
            position: new Tween<Offset>(
              begin: const Offset(-1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
      default:
        final PageTransitionsTheme theme =
            Theme.of(context).pageTransitionsTheme;
        return theme.buildTransitions<T>(
            this, context, animation, secondaryAnimation, child);
    }
  }
}
