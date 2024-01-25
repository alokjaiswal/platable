import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platableapp/Screens/login_page.dart';
import 'package:platableapp/services/authentication.dart';
import 'package:platableapp/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final User? user = Authentication.getUser();
    final username = user?.displayName;
    return Scaffold(
      body: SizedBox(
        width: width,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 100,),
              Expanded(
                child: Container(
                  width: width,
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(color: Utils.colorFromHex('#8636BB'),borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                  child: Column(
                    children: [
                      if (user?.photoURL != null)
                        Container(
                          width: width/4,
                          height: width/4,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
                          child: Image.network(user?.photoURL ?? '', fit: BoxFit.fill,width: width/4, height: width/4,),
                        ),
                      const SizedBox(height: 16,),
                      Text("Welcome ${username ?? ", you are logged In"}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Roboto',
                          fontSize: 22,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 100,),
                      ElevatedButton(
                        onPressed: () async {
                          await Authentication.signOutWithGoogle();
                          if (mounted) {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                                builder: (context) => const LoginPage()
                            ));
                          }
                        },
                        child: Container(
                          // decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(15))),
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          child: const Text("Sign Out",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
