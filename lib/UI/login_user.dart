import 'dart:convert';

import 'package:consume_api/create/register.dart';
import 'package:consume_api/data/data.dart';
import 'package:consume_api/layout/mainlayout.dart';
import 'package:consume_api/methods/api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  void loginUser() async {
    final data = {
      'email': email.text.toString(),
      'password': password.text.toString(),
    };
    final result = await API().postRequest(route: '/login', data: data);
    
    final response = jsonDecode(result.body);
    if (response['message'] == 'Attempt to read property "id" on null') {
       return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Akun tidak terdaftar'),
            content: Text('Silahkan Registrasi dulu'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
    if (response['status'] == 200) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setInt('id', response['user']['id']);
      await preferences.setString('email', response['user']['email']);
      await preferences.setString('role', response['user']['role']);
      await preferences.setString('name', response['user']['name']);
      await preferences.setString('first_name', response['user']['first_name']);
      await preferences.setString('last_name', response['user']['last_name']);
      await preferences.setString('gender', response['user']['gender']);
      await preferences.setString('avatar', response['user']['avatar'] ?? 'assets/img/ProfileDefault.png');
      await preferences.setString('birth_date', response['user']['birth_date']);
      await preferences.setInt('student_id', response['user']['student_id']);
      await preferences.setInt('entry_year', response['user']['entry_year']);
      await preferences.setString('token', response['token']);  
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const MainLayout(initialIndex: 0,),   
      ));
    } else if (response['status'] == 404) {
      //validasi admin
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Akun tidak terdaftar'),
            content: Text('Silahkan Registrasi dulu'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else if (response['status'] == 403) {
      //validasi admin
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Gagal'),
            content: Text(response['message'].toString()),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else if (response['status'] == 401) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Password Salah!'),
            content: Text('Coba Periksa kembali password anda'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon Periksa Koneksi Anda.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  bool _isSecurePassword = true;
  @override
  Widget build(BuildContext context) {
    // responsive Variable
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth * 0.01;
    double containerWidth = screenWidth * 0.8;
    double sizedBox = MediaQuery.of(context).size.height * 0.024;
    double containerHeight = screenWidth * 0.95;

    // fontsize
    double fontSizeValue = MediaQuery.of(context).size.width * 0.038;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
            child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/Onboarding_mathmob.png'),
              fit: BoxFit.cover,
            ),
          ),

          //  all container
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.045),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly, // gap all container
                  children: [
                    // Background Image ( wave )
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.width * 0.1,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/img/logo-mathwiz.png'),
                              fit: BoxFit.cover)),
                    ), // Background Image ( wave ) end
                  ],
                ),
              ),

              // Image Illustration
              Container(
                width: 300,
                height: 300,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/img/Group.png'))),
              ),
              // Image Illustration

              // Container Form Login
              Container(
                padding: EdgeInsets.only(
                    right: padding, left: padding, top: 15, bottom: 15),
                width: containerWidth,
                height: containerHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Masuk',
                        style: GoogleFonts.mulish(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: greenSolid),
                      ),
                    ),

                    //  Email Field
                    SizedBox(height: sizedBox),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Container(
                              child: TextFormField(
                                controller: email,
                                style: GoogleFonts.mulish(
                                  color: Colors.black,
                                  fontSize: fontSizeValue,
                                  fontWeight: FontWeight.w400,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: 'Nomor Induk',
                                  hintStyle: GoogleFonts.mulish(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.028,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black45),
                                  filled: true,
                                  fillColor: inputLogin,
                                  prefixIcon: const Align(
                                    widthFactor: 3,
                                    heightFactor: 1.0,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.black,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent)),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    // Password field
                    SizedBox(height: sizedBox),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Column(
                        children: [
                          Container(
                            // key: _formKey,
                            child: TextFormField(
                              controller: password,
                              obscureText: _isSecurePassword,
                              style: GoogleFonts.mulish(
                                color: Colors.black,
                                fontSize: fontSizeValue,
                                fontWeight: FontWeight.w400,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: GoogleFonts.mulish(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.028,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black45),
                                filled: true,
                                fillColor: inputLogin,
                                suffixIcon: togglePassword(),
                                prefixIcon: const Align(
                                  widthFactor: 3,
                                  heightFactor: 1.0,
                                  child: Icon(
                                    Icons.lock_outline_rounded,
                                    color: Colors.black,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                              ),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.014),
                          // Align(
                          //   alignment: Alignment.topLeft,
                          //   child: Text(
                          //     'Lupa password?',
                          //     style: GoogleFonts.mulish(
                          //         color: blueText, fontSize: 14),
                          //   ),
                          // ),
                        ],
                      ),
                    ),

                    // Button
                    SizedBox(height: sizedBox),

                    Container(
                        width: screenWidth * 0.73,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(90),
                          color: greenSolid,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: ElevatedButton(
                            onPressed: () {
                              loginUser();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: greenSolid,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 17),
                            ),
                            child: Container(
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ),
                        )),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Belum punya akun?',
                            style: GoogleFonts.mulish(color: blueText),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const register_screen(),
                                  ));
                            },
                            child: Text(
                              'Daftar',
                              style: GoogleFonts.mulish(
                                  color: greenSolid,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ), // Container Form Login
            ],
          ),
        )),
      ),
    );
  }

  Widget togglePassword() {
    return IconButton(
        onPressed: () {
          setState(() {
            _isSecurePassword = !_isSecurePassword;
          });
        },
        icon: _isSecurePassword
            ? Icon(Icons.visibility)
            : Icon(Icons.visibility_off),
        color: Colors.grey);
  }
}
