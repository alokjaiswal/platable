import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../home_page.dart';
import '../services/authentication.dart';
import '../utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
  }

  @override
  void dispose() {
    super.dispose();
    _isLoading = false;
  }

  void SigninFunction(bool isSignUp) async {
    try {
      setState(() {
        _isLoading = true;
      });
      final user = await Authentication.signInWithGoogle(
          context: context, isSignUp: isSignUp);
      setState(() {
        _isLoading = false;
      });
      if (user != null) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (
                      context) => const HomePage()
              ));
        }
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Account not found, Please SignUp")));
      }
    } on FirebaseAuthException catch (err) {
      print(err.message);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err.message ?? "Something went wrong")));
    } catch (err) {
      print(err);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Container(
        width: width,
        color: Utils.colorFromHex('#FFFBFF'),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                color: Utils.colorFromHex('#FFFBFF'),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    child: Image.asset(
                      'assets/platableTop.png',
                      height: 132,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: width,
              margin: EdgeInsets.only(top: 132),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2.0,
                      offset: Offset(0.0, 0.75),
                      blurStyle: BlurStyle.solid
                  )
                ],
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      // color: Colors.green,
                      transform: Matrix4.translationValues(0.0, -40.0, 0.0),
                      child: Image.asset(
                        'assets/platableLogo.png',
                        height: 80,
                        width: 80,
                      ),
                    ),
                  ),
                  Container(
                    transform: Matrix4.translationValues(0.0, -23.0, 0.0),
                    child: const Text(
                      'platable',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Ramaraja',
                          fontSize: 28,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -1.849
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: width,
                      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      decoration: BoxDecoration(color: Utils.colorFromHex('#8636BB'),borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                      child: Column(
                        children: [
                          Text(
                            "Hey there, welcome back",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Roboto',
                              fontSize: 22,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 16,),
                          Text(
                            "Sign in to continue with your email, facebook or google account.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Utils.colorFromHex("#E3B5FF"),
                              fontFamily: 'Avenir',
                              fontSize: 14,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 16,),
                          InkWell(
                            onTap: () async {
                              SigninFunction(false);
                            },
                            child: Container(
                              padding: EdgeInsets.all(29),
                              decoration: BoxDecoration(border: Border.all(color: Utils.colorFromHex("#EADFEA"), width: 1, style: BorderStyle.solid), borderRadius: BorderRadius.circular(16)),
                              child: Image.asset(
                                'assets/GoogleLogo.png',
                                height: 32,
                                width: 32,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Need to create an account?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Utils.colorFromHex("#E3B5FF"),
                                  fontFamily: 'Roboto',
                                  fontSize: 14,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 8,),
                              InkWell(
                                onTap: () async {
                                  SigninFunction(true);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    "Sign Up.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Utils.colorFromHex("#FFFBFF"),
                                      fontFamily: 'Roboto',
                                      fontSize: 14,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            if (_isLoading)
              Align(
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3,backgroundColor: Utils.colorFromHex('#8636BB'),strokeCap: StrokeCap.round,),
                alignment: Alignment.center,
              )
          ],
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
