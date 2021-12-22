// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_constructors_in_immutables, await_only_futures

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:gelberaberolsun/services/Auth.dart';
import 'package:provider/provider.dart';

class SignUp extends StatelessWidget {
  final _signUpKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordAgainController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController meslekController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  SignUp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Hesap Oluştur',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Form(
              key: _signUpKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 50, right: 50),
                child: Column(
                  children: [
                    Text(
                      'Hesap Oluştur',
                      style: TextStyle(fontSize: 30),
                    ),
                    SizedBox(height: 20),
                    Card(
                      shadowColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      elevation: 20,
                      color: Colors.white54,
                      child: MyTextFormField(
                        controller: nameController,
                        label: "İsim Soyisim",
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
                      shadowColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      elevation: 20,
                      color: Colors.white54,
                      child: MyTextFormField(
                        inputType: TextInputType.emailAddress,
                        label: "E-posta",
                        controller: emailController,
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
                      shadowColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      elevation: 20,
                      color: Colors.white54,
                      child: MyTextFormField(
                        label: "Meslek",
                        controller: meslekController,
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
                      shadowColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      elevation: 20,
                      color: Colors.white54,
                      child: MyTextFormField(
                        label: "Yaş",
                        controller: ageController,
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
                      shadowColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      elevation: 20,
                      color: Colors.white54,
                      child: MyTextFormField(
                          inputType: TextInputType.visiblePassword,
                          label: "Şifre",
                          controller: passwordController),
                    ),
                    SizedBox(height: 20),
                    Card(
                      shadowColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      elevation: 20,
                      color: Colors.white54,
                      child: MyTextFormField(
                        label: "Şifre Tekrar",
                        controller: passwordAgainController,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_signUpKey.currentState.validate() &&
                            passwordController.text ==
                                passwordAgainController.text) {
                          await Provider.of<Auth>(context, listen: false)
                              .createUserWithEmailAndPassword(
                                  emailController.text,
                                  passwordController.text);
                          String uid =
                              await Provider.of<Auth>(context, listen: false)
                                  .getCurrentUser()
                                  .uid;
                          await Provider.of<Auth>(context, listen: false)
                              .updateDisplayName(nameController.text);

                          await Provider.of<Auth>(context, listen: false)
                              .createUser({
                            "name": nameController.text,
                            "id": uid,
                            "yas": ageController.text,
                            "meslek": meslekController.text,
                            "bio": "",
                            "olusturma tarihi": DateTime.now(),
                          });

                          Navigator.pop(context);
                        }
                      },
                      child: Text('Kayıt Ol'),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          minimumSize: Size(350, 50),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25))),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyTextFormField extends StatelessWidget {
  final String label, infoMessage;
  final TextEditingController controller;
  final Function validator;
  final TextInputType inputType;

  MyTextFormField(
      {Key key,
      @required this.label,
      this.controller,
      this.infoMessage,
      this.validator,
      this.inputType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: inputType,
      validator: (value) {
        if (label.contains("Email") && !EmailValidator.validate(value)) {
          return "Geçerli Bir Mail Adresi Giriniz.";
        } else if (label.contains("Password") && value.length < 6) {
          return "Şifre 6 Haneden Az Olamaz.";
        } else if (label.contains("Name") && value.isEmpty) {
          return "Bu Alan Boş Bırakılamaz.";
        } else {
          return null;
        }
      },
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.black),
          borderRadius: BorderRadius.circular(35),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.green),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
