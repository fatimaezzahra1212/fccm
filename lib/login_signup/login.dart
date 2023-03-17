import 'package:fccm/model/mapss.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fccm/model/testmaps.dart';
import '../app_theme.dart';
import 'package:animations/animations.dart';
import 'signupp.dart';
import 'package:http/http.dart' as http;
import 'package:fccm/model/mapss.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fccm/model/currentlocation.dart';
import 'forget.dart';

import 'package:fccm/app_theme.dart';

const Color primaryColor = Color(0xFF9A9696);
const Color secondaryColor = Color(0xFF013C61);

class loginPage extends StatefulWidget {
  const loginPage({Key? key}) : super(key: key);
  @override
  loginPageState createState() => loginPageState();
}

final _formKey = GlobalKey<FormState>();
final firstNameEditingController = new TextEditingController();
final secondNameEditingController = new TextEditingController();
final emailNameEditingController = new TextEditingController();
final PasswordNameEditingController = new TextEditingController();
final confirmPasswordNameEditingController = new TextEditingController();
bool showSpinner = true;

// Uncomment lines 3 and 6 to view the visual layou
class loginPageState extends State<loginPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final emailNameEditingController = new TextEditingController();
  final PasswordNameEditingController = new TextEditingController();
  void submitLoginForm() async {
    /* final response = await http.post(
      Uri.parse('https://10.211.25.236:8000/api/auth/login'),
      body: {
        'email': emailNameEditingController.text,
        'password': PasswordNameEditingController.text,
      },
    );

    if (response.statusCode == 200) {
      // Login successful, handle response data
      // For example, you can navigate to the profile page:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    } else {
      // Login failed, handle error
      // For example, you can show a snackbar with the error message:
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed. Please try again.')),
      );
    }*/
  }

  @override
//  String _title = 'Uber';
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final emailField = TextFormField(
        autofocus: false,
        controller: emailNameEditingController,
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) {
          emailNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (textValue) {
          if (textValue == null || textValue.isEmpty) {
            return 'Email is required!';
          }
          if (!EmailValidator.validate(textValue)) {
            return 'Please enter a valid email';
          }
          return null;
        });

    final PasswordNameField = TextFormField(
      autofocus: false,
      controller: PasswordNameEditingController,
      obscureText: true,
      onSaved: (value) {
        PasswordNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password.';
        }
        return null;
      },
    );

    final signupButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: secondaryColor,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 30, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () async {
          setState(() {
            showSpinner = true;
          });
          try {
            final user = await _auth.signInWithEmailAndPassword(
              email: emailNameEditingController.text,
              password: PasswordNameEditingController.text,
            );
            if (user != null) {
              Navigator.pushNamed(context, '/CurrentLocationScreen');
            }
          } catch (e) {
            print(e);
          }
          setState(() {
            showSpinner = false;
          });

          /*if (_formKey.currentState!.validate()) {
            var response = await http.post(Uri.parse(backendUrl), body: {
              "email": emailNameEditingController.text,
              "password": PasswordNameEditingController.text,
              // add any other required fields here
            });
            if (response.statusCode == 200) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => mapsi()));
            } else {
              // handle error response from backend
              // for example, show a snackbar with the error message
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Signup failed: ${response.body}"),
                duration: Duration(seconds: 3),
              ));
            }
          }*/
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => mapss()),
                );
              },
              child: const Text(
                'Log in',
                style: TextStyle(
                    fontSize: 20,
                    color: primaryColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
          iconSize: 20,
          color: secondaryColor,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      height: size.height * 0.3,
                      child: Image.asset('assets/images/inviteImage.png',
                          fit: BoxFit.contain),
                    ),
                    SizedBox(height: 20),
                    emailField,
                    SizedBox(height: 20),
                    PasswordNameField,
                    SizedBox(height: 15),
                    signupButton,
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: Text(
                              'Forget password',
                              style: TextStyle(
                                color: Color(0xff132137),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgetScreen()),
                              );
                            },
                          ),
                        ],
                      ),
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

  void _handleLoginUser() {
    // login user
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Submitting data..')),
      );
    }
  }
}
