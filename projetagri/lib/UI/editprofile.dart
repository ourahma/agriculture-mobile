import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool isobscuredPassword = true ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Colors.green,
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.arrow_back,
        //     color: Colors.white,
        //   ), onPressed: () {  },
        // ),
      ),
      body:Container(
        padding: EdgeInsets.only(left: 15,top: 20, right: 15),
        child: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(width: 4, color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                            ),
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage('https://img.freepik.com/photos-gratuite/photo-gros-plan-mains-du-jardinier-planter-plantes_1150-26615.jpg?w=740&t=st=1677843326~exp=1677843926~hmac=ef163ce27af5300e9de9c679f34e81eedde7ca7f91af949b51518893995713c6')
                          )
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  width: 4,
                                  color: Colors.white
                              ),
                              color: Colors.green
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        )
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              buildTextField('Full Name', 'Firstname Lastname', false),
              buildTextField('Email', 'email@gmail.com', false),
              buildTextField('Password', '***', true),
              buildTextField('Numero Telephone', '0600776654', false),
              buildTextField('Role', 'Agriculture', false),
              buildTextField('Lacation', 'Mekens', false),
              SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: (){},
                      child: Text('Cancel',
                        style: TextStyle(
                            fontSize: 15,
                            letterSpacing: 2,
                            color: Colors.black
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: (){},
                      child: Text('Save' , style: TextStyle(
                          fontSize: 15,
                          letterSpacing: 2,
                          color: Colors.white
                      ),),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ) ,
    );
  }
  Widget buildTextField(String labelText, String placeholder , bool isPasswordText){
    return Padding(
      padding: EdgeInsets.only(bottom: 30) ,
      child: TextField(
        obscureText: isPasswordText ? isobscuredPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordText ? IconButton(
                onPressed: (){
                  setState(() {
                    isobscuredPassword = !isobscuredPassword;
                  });
                },
                icon: Icon(
                  Icons.remove_red_eye ,
                  color: Colors.grey,
                )
            ):null ,
            contentPadding: EdgeInsets.only(bottom: 5),
            labelText: labelText ,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.grey
            )
        ),
      ),
    );
  }
}