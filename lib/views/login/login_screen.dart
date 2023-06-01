import 'package:flutter/material.dart';
import '/responsive.dart';
import '/components/login/login_background.dart';
import '/components/login/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage(
          'assets/images/login.png',
        ),
      )),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(children: <Widget>[
            Positioned(
              child: Align(
                alignment: FractionalOffset.topCenter,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                  child: Image.asset(
                    "assets/images/main_top.png",
                    width: 160,
                  ),
                ),
              ),
            ),
            Positioned(
                child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Card(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 60),
                elevation: 10,
                color: Colors.black38,
                child: Container(
                  width: 300,
                  height: 300,
                  alignment: Alignment.center,
                  child: LoginBackground(
                    child: SingleChildScrollView(
                      child: Responsive(
                        mobile: const MobileLoginScreen(),
                        desktop: Row(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  SizedBox(
                                    width: 450,
                                    child: LoginForm(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ))
          ])),
    );
  }
}

class MobileLoginScreen extends StatelessWidget {
  const MobileLoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: const [
            Spacer(),
            Expanded(
              flex: 8,
              child: LoginForm(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}
