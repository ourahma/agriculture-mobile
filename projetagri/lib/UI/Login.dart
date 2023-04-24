import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:projetagri/Reposistory/auth_repo.dart';
import 'package:projetagri/bloc/Authentification/authentification_event.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/Authentification/authentification_bloc.dart';
import '../common/color.dart';
import 'signup.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _key = GlobalKey<FormState>();
  final emailcontroller = TextEditingController();
  final pwdcontroller = TextEditingController();
  late String _email, _pwd;
  bool showsignin = true, show = true, isLoading = false;
  var authBloc;
  final userdata = GetStorage();

  get width => MediaQuery.of(context).size.width;

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthentificationBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    pwdcontroller.dispose();
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BlocConsumer<AuthentificationBloc, AuthentificationState>(
        builder: (context, state) {
      if (state is LoginLoadingState) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      } else {
        return Scaffold(body: form());
      }
    }, listener: (context, state) {
      if (state is LoginErrorState) {
        Get.snackbar(
          "Something went wrong ! ",
          state.message,
          icon: Icon(
            Icons.error,
            size: 25,
            color: Colors.red,
          ),
          backgroundColor: Colors.white,
          duration: Duration(seconds: 3),
        );
      }
      if (state is UserLoginSuccess) {
        Navigator.pushReplacementNamed(context, "/nav");
      }
    });
  }

  Widget form() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SvgPicture.asset(
              'images/top.svg',
              width: width,
              height: 95,
            ),
            const Row(
              children: [
                Icon(Icons.login, color: AppColor.primarygreencolor, size: 60),
                SizedBox(width: 5),
                Text('Log in ', style: TextStyle(fontSize: 30)),
              ],
            ),
            const SizedBox(height: 20),
            Form(
                child: Column(
              children: [
                textfieldemail('email'),
                const SizedBox(
                  height: 5,
                ),
                textfielpassword("password"),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 60,
                        width: width * 0.9,
                        child: ElevatedButton(
                          onPressed: () async {
                            print("tapped");
                            if (_email != null && _pwd != null) {
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString("email", _email);
                              prefs.setString("password", _pwd);
                              authBloc.add(LoginButtonPressed(
                                  email: _email, password: _pwd));
                            } else {
                              Get.snackbar("Warining",
                                  "Make sure you enter all information ");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primarygreencolor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          child: isLoading
                              ? const SpinKitWave(
                                  color: AppColor.backgroundcolor,
                                  type: SpinKitWaveType.start)
                              : const Text(
                                  'Log in',
                                  style: TextStyle(fontSize: 20),
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Signup()));
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Don\'t have an account  '),
                            Text(
                              'Sign up',
                              style: TextStyle(color: AppColor.secondarycolor),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }

  Widget textfielpassword(String title) {
    return TextFormField(
      autocorrect: false,
      controller: pwdcontroller,
      onChanged: (value) => setState(() => _pwd = value),
      validator: (value) {
        if (value!.isEmpty) {
          return '*Insert a password';
        }
      },
      obscureText: title == 'password' ? showsignin : show,
      decoration: InputDecoration(
          hintText: title,
          suffixIcon: title == 'password'
              ? IconButton(
                  icon: Icon(
                    showsignin ? Icons.visibility_off : Icons.visibility,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    setState(() {
                      showsignin = !showsignin;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(
                    show ? Icons.visibility_off : Icons.visibility,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    setState(() {
                      show = !show;
                    });
                  },
                ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.greenAccent),
          )),
    );
  }

  Widget textfieldemail(String title) {
    return TextFormField(
      autocorrect: false,
      autofocus: true,
      controller: emailcontroller,
      onChanged: (value) => setState(() => _email = value),
      validator: (value) => value == null ||
              !RegExp(r"[a-z0-9\.-]+@[a-z0-9\.-]+\.[a-z]+").hasMatch(value)
          ? "Please enter a valid Email"
          : null,
      decoration: InputDecoration(
        hintText: title,
        suffixIcon: const Icon(Icons.email),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.greenAccent)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.greenAccent)),
      ),
    );
  }
}
