import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pmsn2024/screens/dashboard_screen.dart';
import 'package:pmsn2024/screens/datail_movie_screen.dart';
import 'package:pmsn2024/screens/despensa_screen.dart';
import 'package:pmsn2024/screens/popular_movies_screen.dart';
import 'package:pmsn2024/screens/register_screen.dart';
import 'package:pmsn2024/screens/splash_screen.dart';
import 'package:pmsn2024/settings/app_value_notifier.dart';
import 'package:pmsn2024/settings/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAjdLSlnYxV_OYGIJl7uZv8bOsP9P_3LbY",
          appId: "com.example.pmsn2024",
          messagingSenderId: "357758942772",
          projectId: "pmsn2024-7fa6c"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppValueNotifier.banTheme,
      builder: (context, value, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: value
              ? ThemeApp.darkTheme(context)
              : ThemeApp.lightTheme(context),
          home: const SplashScreen(),
          routes: {
            "/dash": (BuildContext context) => const DashboardScreen(),
            "/despensa": (BuildContext context) => const DespensaScreen(),
            "/registro": (BuildContext context) => const RegisterScreen(),
            "/movies": (BuildContext context) => const PopularMoviesScreen(),
            "/detail": (BuildContext context) => const DetailMovieScreen(),
          },
        );
      },
    );
  }
}




/*
class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int contador = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Practica 1",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.blue,
        ),
        drawer: Drawer(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () {
            contador++;
            print(contador);
            setState(() {});
          },
          child: Icon(Icons.ads_click),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.network(
                "https://sandstormit.com/wp-content/uploads/2021/06/incognito-2231825_960_720-1.png",
                height: 250,
              ),
            ),
            Text('Valor del contador $contador'),
          ],
        ),
      ),
    );
  }
}
*/