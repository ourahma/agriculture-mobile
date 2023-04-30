// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();
  bool showSignIn = true;
  bool show = true;
  late String? _password, _Confirmpwd;
  final ConfirmpwdController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose() {
    passwordController.dispose();
    ConfirmpwdController.dispose();
    super.dispose();
  }
  void vueconfirm() {
    setState(() {
      show = !show;
    });
  }

  void vuePwd() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }
  Map data={};
  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>;
    String? lastname = data['lastname'];
    String? firstname=data['firstname'];
    String? email=data['email'];
    String? typeuser=data['typeuser'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Rinitialisation'),
        backgroundColor:  Color(0xFF43a047),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            setState(() {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ForgetPassword()));
            });
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.fromLTRB(10, 70, 10, 0),
              child: Text('Welcome back $lastname $firstname, Retype your new password',style: TextStyle(
                  fontSize: 16.0, fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding:  EdgeInsets.fromLTRB(10, 80, 10, 0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: passwordController,
                        onChanged: (value) => setState(() => _password = value),
                        obscureText: showSignIn,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                showSignIn ? Icons.visibility_off : Icons.visibility,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              onPressed: () {
                                vuePwd();
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const BorderSide(
                                color: Colors.greenAccent,
                              ),
                            )),
                      ),
                      const SizedBox(
                          height: 20.0
                      ),
                      TextFormField(
                        controller: ConfirmpwdController,
                        onChanged: (value) =>
                            setState(() => _Confirmpwd = value),
                        validator: (value) {
                          if (value != _password) {
                            return 'Password not Matching';
                          }
                          if (value!.isEmpty) {
                            return '*Insert password ';
                          }
                          return null;
                        },
                        obscureText: show,
                        decoration: InputDecoration(
                            hintText: 'Confirm Password ',
                            suffixIcon: IconButton(
                              icon: Icon(
                                show ? Icons.visibility_off : Icons.visibility,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              onPressed: () {
                                vueconfirm();
                              },
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0),
                            ),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), borderSide: const BorderSide(color: Colors.greenAccent,),
                            )),
                      ),
                    ],
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: SizedBox(
                height: 50,
                width: 200,
                child: ElevatedButton(onPressed: () async {
                  //Usercontroller controller=Usercontroller();
                  print(passwordController.text);
                  //bool results = await controller.controlupdatepaswd(User(firstname,lastname,email,passwordController.text,typeuser));

                  /*if (results != false) {
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacementNamed(
                        context, '/reinitailpaswd',
                        arguments: {
                          'lastname': lastname,
                          'firstname': firstname,
                        });

                  }*/
                  }, child: Text('Update your password',style: TextStyle(fontSize: 16),),style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF43a047),shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(20))),
                ),
              ),
            )
          ],
        ),
      ),

    );
  }
}
