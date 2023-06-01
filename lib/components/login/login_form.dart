import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/controllers/login_controller.dart';
import '/constants/styles.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: loginController.usernameController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: const InputDecoration(
              hintText: "Tài khoản",
              hintStyle: TextStyle(color: kPrimaryLightColor),
              filled: true,
              fillColor: Colors.black45,
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person, color: kPrimaryLightColor),
              ),
            ),
            style: const TextStyle(color: kPrimaryLightColor),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: loginController.passwordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "Mật khẩu",
                hintStyle: TextStyle(color: kPrimaryLightColor),
                filled: true,
                fillColor: Colors.black45,
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock, color: kPrimaryLightColor),
                ),
              ),
              style: const TextStyle(color: kPrimaryLightColor),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () => loginController.login(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
              child: Text(
                "Đăng nhập".toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
