import 'dart:ui';
import 'package:flutter/material.dart';

import '../../model/palette.dart';

class GradientIcon extends StatelessWidget {
  GradientIcon(
    this.icon,
    this.size,
    this.gradient,
  );

  final IconData icon;
  final double size;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: SizedBox(
        width: size * 1.2,
        height: size * 1.2,
        child: Icon(
          icon,
          size: size,
          color: Colors.white,
        ),
      ),
      shaderCallback: (Rect bounds) {
        final Rect rect = Rect.fromLTRB(0, 0, size, size);
        return gradient.createShader(rect);
      },
    );
  }
}

class TabBarWidget extends StatelessWidget {
  final String title;
  final List<Tab> tabs;
  final List<Widget> children;

  const TabBarWidget({
    Key? key,
    required this.title,
    required this.tabs,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
            centerTitle: true,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.blue],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
              ),
            ),
            bottom: TabBar(
              isScrollable: true,
              indicatorColor: Colors.white,
              indicatorWeight: 5,
              tabs: tabs,
            ),
            elevation: 20,
            titleSpacing: 20,
          ),
          body: TabBarView(children: children),
        ),
      );
}

/// {@template hero_dialog_route}
/// Custom [PageRoute] that creates an overlay dialog (popup effect).
///
/// Best used with a [Hero] animation.
/// {@endtemplate}
class HeroDialogRoute<T> extends PageRoute<T> {
  /// {@macro hero_dialog_route}
  HeroDialogRoute({
    WidgetBuilder? builder,
    RouteSettings? settings,
    bool fullscreenDialog = false,
  })  : _builder = builder!,
        super(settings: settings, fullscreenDialog: fullscreenDialog);

  final WidgetBuilder _builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return _builder(context);
  }

  @override
  String get barrierLabel => 'Popup dialog open';
}

/// {@template custom_rect_tween}
/// Linear RectTween with a [Curves.easeOut] curve.
///
/// Less dramatic that the regular [RectTween] used in [Hero] animations.
/// {@endtemplate}
class CustomRectTween extends RectTween {
  /// {@macro custom_rect_tween}
  CustomRectTween({
    Rect? begin,
    Rect? end,
  }) : super(begin: begin, end: end);

  @override
  Rect lerp(double t) {
    double elasticCurveValue = Curves.easeOut.transform(t);
    return Rect.fromLTRB(
      lerpDouble(begin!.left, end!.left, elasticCurveValue)!,
      lerpDouble(begin!.top, end!.top, elasticCurveValue)!,
      lerpDouble(begin!.right, end!.right, elasticCurveValue)!,
      lerpDouble(begin!.bottom, end!.bottom, elasticCurveValue)!,
    );
  }
}

/// {@template todo_popup_card}
/// Popup card to expand the content of a [Todo] card.
///
/// Activated from [_TodoCard].
/// {@endtemplate}
class PopupImageCard extends StatelessWidget {
  const PopupImageCard({Key? key, this.image_url, this.title, required this.id})
      : super(key: key);
  final String? image_url;
  final String? title;
  final int id;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: id,
      createRectTween: (begin, end) {
        return CustomRectTween(begin: begin, end: end);
      },
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            borderRadius: BorderRadius.circular(16),
            color: Palette.facebookColor.withOpacity(0.7),
            child: SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(title!,
                          style: TextStyle(fontSize: 15, color: Colors.white)),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.network(image_url!,
                            width: 320, height: 320, fit: BoxFit.scaleDown),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InkWellWidget extends StatefulWidget {
  final Widget? Function(bool isTapped) builder;
  final Color? color;
  final BorderRadius? borderRadius;
  final ShapeBorder? customBorder;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const InkWellWidget({
    required this.builder,
    required this.onTap,
    required this.onLongPress,
    this.color,
    this.borderRadius,
    this.customBorder,
    Key? key,
  }) : super(key: key);

  @override
  _InkWellWidgetState createState() => _InkWellWidgetState();
}

class _InkWellWidgetState extends State<InkWellWidget> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    final color = this.widget.color ?? Colors.grey.withOpacity(0.2);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: color,
        highlightColor: color,
        borderRadius: widget.borderRadius,
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: widget.builder(isTapped),
        onHighlightChanged: (isTapped) =>
            setState(() => this.isTapped = isTapped),
        customBorder: widget.customBorder,
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  var icon;
  var red = false;

  MyButton({
    Key? key,
    this.icon,
    required this.red,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: Container(
        padding: EdgeInsets.only(left: 13, right: 13, bottom: 2, top: 2),
        child: Icon(
          icon,
          size: 25,
          //color: Colors.grey[800],
          color: red ? Colors.red[600] : Colors.green[600],
        ),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(23),
            color: Colors.grey[300],
            boxShadow: [
              BoxShadow(
                  color: Palette.kGrey500,
                  offset: Offset(2.0, 2.0),
                  blurRadius: 5.0,
                  spreadRadius: 1.0),
              BoxShadow(
                  color: Colors.white,
                  offset: Offset(-2.0, -2.0),
                  blurRadius: 5.0,
                  spreadRadius: 1.0),
            ],
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Palette.kGrey200,
                  Palette.kGrey300,
                  Palette.kGrey400,
                  Palette.kGrey500,
                ],
                stops: [
                  0.1,
                  0.3,
                  0.8,
                  1
                ])),
      ),
    );
  }
}

class MyButtonRed extends StatelessWidget {
  var icon;

  MyButtonRed({
    Key? key,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: Container(
        padding: EdgeInsets.only(left: 13, right: 13, bottom: 2, top: 2),
        child: Icon(
          icon,
          size: 25,
          color: Colors.white,
        ),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(23),
            color: Palette.kRed300,
            boxShadow: [
              BoxShadow(
                  color: Palette.kRed600,
                  offset: Offset(3.0, 3.0),
                  blurRadius: 10.0,
                  spreadRadius: 1.0),
              BoxShadow(
                  color: Colors.white,
                  offset: Offset(-3.0, -3.0),
                  blurRadius: 15.0,
                  spreadRadius: 1.0),
            ],
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Palette.kRed200,
                  Palette.kRed300,
                  Palette.kRed400,
                  Palette.kRed500,
                ],
                stops: [
                  0.1,
                  0.3,
                  0.8,
                  1
                ])),
      ),
    );
  }
}

class ButtonTapped extends StatelessWidget {
  var icon;

  ButtonTapped({
    Key? key,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: Container(
        padding: EdgeInsets.all(5),
        child: Container(
          padding: EdgeInsets.only(left: 13, right: 13, bottom: 2, top: 2),
          child: Icon(
            icon,
            size: 25,
            color: Palette.kGrey700,
          ),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(23),
              color: Palette.kGrey300,
              boxShadow: [
                BoxShadow(
                    color: Colors.white,
                    offset: Offset(4.0, 4.0),
                    blurRadius: 10.0,
                    spreadRadius: 1.0),
                BoxShadow(
                    color: Palette.kGrey600,
                    offset: Offset(-4.0, -4.0),
                    blurRadius: 10.0,
                    spreadRadius: 1.0),
              ],
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Palette.kGrey700,
                    Palette.kGrey600,
                    Palette.kGrey500,
                    Palette.kGrey200,
                  ],
                  stops: [
                    0,
                    0.1,
                    0.3,
                    1
                  ])),
        ),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(23),
            color: Colors.grey[300],
            boxShadow: [
              BoxShadow(
                  color: Palette.kGrey600,
                  offset: Offset(4.0, 4.0),
                  blurRadius: 10.0,
                  spreadRadius: 1.0),
              BoxShadow(
                  color: Colors.white,
                  offset: Offset(-4.0, -4.0),
                  blurRadius: 10.0,
                  spreadRadius: 1.0),
            ],
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Palette.kGrey200,
                  Palette.kGrey300,
                  Palette.kGrey400,
                  Palette.kGrey500,
                ],
                stops: [
                  0.1,
                  0.3,
                  0.8,
                  1
                ])),
      ),
    );
  }
}

class TransparentButton extends StatelessWidget {
  var icon;
  var red = false;

  TransparentButton({
    Key? key,
    this.icon,
    required this.red,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0),
      child: Container(
        padding: EdgeInsets.only(left: 18, right: 18, bottom: 3, top: 3),
        child: Icon(
          icon,
          size: 30,
          //color: Colors.grey[800],
          color: red ? Colors.red[600] : Colors.green[600],
        ),
        // decoration: BoxDecoration(
        //     shape: BoxShape.rectangle,
        //     borderRadius: BorderRadius.circular(23),
        //     color: Colors.grey[300],
        //     boxShadow: [
        //       BoxShadow(
        //           color: Palette.kGrey500,
        //           offset: Offset(2.0, 2.0),
        //           blurRadius: 5.0,
        //           spreadRadius: 1.0),
        //       BoxShadow(
        //           color: Colors.white,
        //           offset: Offset(-2.0, -2.0),
        //           blurRadius: 5.0,
        //           spreadRadius: 1.0),
        //     ],
        //     gradient: LinearGradient(
        //         begin: Alignment.topLeft,
        //         end: Alignment.bottomRight,
        //         colors: [
        //           Palette.kGrey200,
        //           Palette.kGrey300,
        //           Palette.kGrey400,
        //           Palette.kGrey500,
        //         ],
        //         stops: [
        //           0.1,
        //           0.3,
        //           0.8,
        //           1
        //         ])),
      ),
    );
  }
}
