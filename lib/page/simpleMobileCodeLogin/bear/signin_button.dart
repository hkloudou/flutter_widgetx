part of '../SimpleMobileCodeLoginPage.dart';

class SigninButton extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double width;
  final double height;
  final void Function()? onPressed;

  const SigninButton({
    Key? key,
    required this.child,
    required this.gradient,
    this.width = double.infinity,
    this.height = 50.0,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 50.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0), gradient: this.gradient),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onPressed,
            child: Center(
              child: child,
            )),
      ),
    );
  }
}
