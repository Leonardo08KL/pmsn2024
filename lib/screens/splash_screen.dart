import 'package:flutter/material.dart';
import 'package:pmsn2024/screens/login_screen.dart';
import 'package:splash_view/source/presentation/pages/pages.dart';
import 'package:splash_view/source/presentation/widgets/done.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashView(
      backgroundColor: Colors.green[600],
      loadingIndicator: RefreshProgressIndicator(),
      logo: Image.network(
        "https://sandstormit.com/wp-content/uploads/2021/06/incognito-2231825_960_720-1.png",
        height: 200,
      ),
      done: Done(const LoginScreen(),
          animationDuration: const Duration(milliseconds: 300)),
    );
  }
}
