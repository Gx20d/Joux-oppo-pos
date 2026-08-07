import 'package:flutter/material.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();

}

class _LoginScreenState
    extends State<LoginScreen> {

  final usernameController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  void login() {

    final username =
        usernameController.text.trim();

    final password =
        passwordController.text;

    if (username == "admin" &&
        password == "1234") {

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (_) =>
              const HomeScreen(),

        ),

      );

    } else {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            "اسم المستخدم أو كلمة المرور غير صحيحة",
          ),

        ),

      );

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Center(

        child: SingleChildScrollView(

          padding:
              const EdgeInsets.all(25),

          child: Column(

            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [

              const Icon(

                Icons.phone_android,

                size: 90,

                color: Colors.orange,

              ),

              const SizedBox(
                height: 20,
              ),

              const Text(

                "Joux Oppo POS",

                style: TextStyle(

                  fontSize: 30,

                  fontWeight:
                      FontWeight.bold,

                ),

              ),

              const SizedBox(
                height: 40,
              ),              TextField(

                controller:
                    usernameController,

                decoration:
                    const InputDecoration(

                  labelText:
                      "اسم المستخدم",

                  border:
                      OutlineInputBorder(),

                  prefixIcon:
                      Icon(Icons.person),

                ),

              ),

              const SizedBox(
                height: 15,
              ),

              TextField(

                controller:
                    passwordController,

                obscureText: true,

                decoration:
                    const InputDecoration(

                  labelText:
                      "كلمة المرور",

                  border:
                      OutlineInputBorder(),

                  prefixIcon:
                      Icon(Icons.lock),

                ),

              ),

              const SizedBox(
                height: 25,
              ),

              SizedBox(

                width: double.infinity,

                height: 50,

                child: ElevatedButton(

                  onPressed: login,

                  child: const Text(

                    "دخول",

                    style: TextStyle(

                      fontSize: 18,

                      fontWeight:
                          FontWeight.bold,

                    ),

                  ),

                ),

              ),

              const SizedBox(
                height: 20,
              ),              const Text(

                "الإصدار 1.0.0",

                style: TextStyle(

                  color: Colors.grey,

                  fontSize: 14,

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}