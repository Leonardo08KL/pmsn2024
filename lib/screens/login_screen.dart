import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:pmsn2024/firebase/email_auth_firebase.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  final emailAuthFirebase = EmailAuthFirebase();
  final _emailController = TextEditingController();
  final _contrasenaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final txtUser = TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      // style: const TextStyle(
      //   color: const Color.fromARGB(255, 3, 2, 0),
      //   fontSize: 40,
      // ),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
    );

    final pdwUser = TextFormField(
      controller: _contrasenaController,
      keyboardType: TextInputType.text,
      obscureText: true,
      // style: TextStyle(color: const Color.fromARGB(255, 3, 2, 0), fontSize: 40),
    );

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('images/madara.jpg'),
          ),
        ),
        child: Column(
          // alignment: Alignment.center,
          children: [
            Image.asset(
              'images/logo.png',
              //width: 50,
              //alignment: Alignment.topCenter,
            ),
            Positioned(
              top: 470,
              child: Opacity(
                opacity: .5,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 155,
                  width: MediaQuery.of(context).size.width * .9,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      txtUser,
                      const SizedBox(
                        height: 10,
                      ),
                      pdwUser,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width * .9,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    SignInButton(
                      Buttons.Email,
                      onPressed: () {
                        setState(() {
                          isLoading = !isLoading;
                        });
                        emailAuthFirebase
                            .signUpUser(
                          name: null,
                          email: _emailController.text,
                          password: _contrasenaController.text,
                        )
                            .then(
                          (value) {
                            if (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("El usuario se ha agregado.."),
                                ),
                              );
                            } else {
                              Navigator.pushNamed(context, '/dash').then(
                                (value) {
                                  setState(
                                    () {
                                      isLoading = !isLoading;
                                    },
                                  );
                                },
                              );
                            }
                          },
                        );
                        // Future.delayed(
                        //   const Duration(milliseconds: 5000),
                        //   () {
                        //     // Navigator.push(
                        //     //     context,
                        //     //     MaterialPageRoute(
                        //     //       builder: (context) => new DashboardScreen(),
                        //     //     ));
                        //     Navigator.pushNamed(context, "/dash").then(
                        //       (value) => setState(
                        //         () {
                        //           isLoading = !isLoading;
                        //         },
                        //       ),
                        //     );
                        //   },
                        // );
                      },
                    ),
                    SignInButton(
                      Buttons.Google,
                      onPressed: () {},
                    ),
                    SignInButton(
                      Buttons.Facebook,
                      onPressed: () {},
                    ),
                    SignInButton(
                      Buttons.GitHub,
                      onPressed: () {},
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/registro');
                      },
                      icon: const Icon(
                        Icons.app_registration,
                        color: Colors.black,
                      ),
                      label: const Text(
                        "Register account",
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  ],
                ),
              ),
            ),
            isLoading
                ? const Positioned(
                    top: 260,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
