import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/Authentification/authentification_bloc.dart';
import '../bloc/Authentification/authentification_event.dart';

import '../common/color.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _key = GlobalKey<FormState>();
  final rolecontroller = TextEditingController();
  final firstnamecontroller = TextEditingController();
  final lastnamecontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final pwdcontroller = TextEditingController();
  final conpwdcontroller = TextEditingController();
  final phonecontroller = TextEditingController();
  late String _profile = 'agriculteur';
  late String _firstname, _lastname, _email, _pwd, _confpwd, _phone;
  bool showsignin = true, show = true, isLoading = false;

  late AuthentificationBloc authBloc;

  get height => MediaQuery.of(context).size.height;

  get width => MediaQuery.of(context).size.width;

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthentificationBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    firstnamecontroller.dispose();
    lastnamecontroller.dispose();
    emailcontroller.dispose();
    pwdcontroller.dispose();
    conpwdcontroller.dispose();
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthentificationBloc, AuthentificationState>(
        builder: (context, state) {
      if (state is SignupLoadingState) {
        return const Scaffold(
            backgroundColor: AppColor.backgroundcolor,
            body: Center(
                child: SpinKitCircle(
              color: AppColor.primarygreencolor,
              size: 60,
            )));
      } else {
        return Scaffold(
          body: form(),
        );
      }
    }, listener: (context, state) {
      if (State is SignupErrorState) {
        Get.snackbar(
          "Something went wrong ! ",
          "An error occured while trying to sign you up, please try again ",
          icon: Icon(
            Icons.error,
            size: 25,
            color: Colors.red,
          ),
          backgroundColor: Colors.white,
          duration: Duration(seconds: 3),
        );
      } else if (state is UserSignupSuccess) {
        Navigator.pushReplacementNamed(context, "/nav");
      }
    });
  }

  Widget form() {
    return SafeArea(
      child: Container(
        color: Colors.white,
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                'images/top.svg',
                width: width,
                height: 95,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.agriculture,
                    size: 40,
                    color: AppColor.primarygreencolor,
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  Text('Welcome',
                      style: TextStyle(
                          fontFamily: "Verdana",
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.black))
                ],
              ),
              Row(
                children: [
                  radiowidget('admin'),
                  const SizedBox(width: 5),
                  radiowidget('Farmer'),
                ],
              ),
              Form(
                  key: _key,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            textfieldnames('first name'),
                            const SizedBox(width: 5),
                            textfieldnames('last name'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        textfieldphone('phone'),
                        textfieldemail("email"),
                        const SizedBox(
                          height: 10,
                        ),
                        textfielpassword("password"),
                        const SizedBox(
                          height: 10,
                        ),
                        textfielpassword("confirm password"),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: SizedBox(
                            height: 60,
                            width: width * 0.9,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_key.currentState!.validate()) {
                                  final SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setString(
                                      "firstname", firstnamecontroller.text);
                                  prefs.setString(
                                      "lastname", lastnamecontroller.text);
                                  prefs.setString(
                                      "email", emailcontroller.text);
                                  prefs.setString(
                                      "password", pwdcontroller.text);
                                  print('user is $_firstname $_lastname $_pwd $_profile $_email');
                                  authBloc.add(SignupButtonPressed(
                                      role: _profile,
                                      firstname: _firstname,
                                      lastname: _lastname,
                                      phone: _phone,
                                      email: _email,
                                      password: _pwd));
                                } else {
                                  Get.snackbar(
                                    "Something went wrong ! ",
                                    "Make sure you inseted all the fields ",
                                    icon: Icon(
                                      Icons.error,
                                      size: 25,
                                      color: Colors.red,
                                    ),
                                    backgroundColor: Colors.white,
                                    duration: Duration(seconds: 3),
                                  );
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
                                      'Sign Up',
                                      style: TextStyle(fontSize: 20),
                                    ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()));
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Already have an account '),
                              Text(
                                'Log in',
                                style:
                                    TextStyle(color: AppColor.secondarycolor),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget radiowidget(String title) {
    return Expanded(
      child: RadioListTile(
          title: Text(title),
          value: title,
          groupValue: _profile,
          onChanged: (value) => setState(() {
                _profile = value.toString();
              })),
    );
  }

  Widget textfieldnames(String title) {
    return Expanded(
      child: TextFormField(
        controller:
            title == 'first name' ? firstnamecontroller : lastnamecontroller,
        onChanged: (value) => setState(() =>
            title == 'first name' ? _firstname = value : _lastname = value),
        decoration: InputDecoration(
          hintText: title == 'first name' ? 'first name' : 'last name',
          suffixIcon: const Icon(Icons.person),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.greenAccent)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.greenAccent)),
        ),
      ),
    );
  }

  Widget textfielpassword(String title) {
    return TextFormField(
      controller: title == 'password' ? pwdcontroller : conpwdcontroller,
      onChanged: (value) =>
          setState(() => title == 'password' ? _pwd = value : _confpwd = value),
      validator: (value) {
        if (value!.isEmpty) {
          return '*Insert a password';
        }
        return null;
      },
      obscureText: title == 'password' ? showsignin : show,
      decoration: InputDecoration(
          hintText: title,
          suffixIcon: title == 'password'
              ? IconButton(
                  icon: Icon(
                    showsignin ? Icons.visibility_off : Icons.visibility,
                    color: AppColor.primarygreencolor,
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
                    color: AppColor.primarygreencolor,
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

  Widget textfieldphone(String title) {
    return IntlPhoneField(
      keyboardType: TextInputType.number,
      controller: phonecontroller,
      onChanged: (value) => setState(() => _phone = value.toString()),
      decoration: InputDecoration(
        hintText: title,
        suffixIcon: const Icon(Icons.phone),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.greenAccent)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.greenAccent)),
      ),
    );
  }

  Widget textfieldemail(String title) {
    return TextFormField(
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
