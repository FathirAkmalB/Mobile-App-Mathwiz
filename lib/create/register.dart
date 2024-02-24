import 'dart:io';

import 'package:consume_api/UI/login_user.dart';
import 'package:consume_api/methods/api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:consume_api/data/data.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:async';

class register_screen extends StatefulWidget {
  const register_screen({Key? key}) : super(key: key);

  @override
  State<register_screen> createState() => _register_screenState();
}

class _register_screenState extends State<register_screen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _entryYearController = TextEditingController();

  String? _avatar;
  String? _nimError;
  String? _passwordError;
  String? _firstNameError;
  String? _lastNameError;
  FilePickerResult? _pickedFile;

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
    );

    if (result != null) {
      setState(() {
        _pickedFile = result;
        _avatar = result.files.first.name;
      });
    } else {
      // User canceled the picker
    }
  }

  // Register
  Future<void> _registerUser() async {
    setState(() {
      _nimError = null;
      _passwordError = null;
      _firstNameError = null;
      _lastNameError = null;
      // Reset pesan kesalahan untuk field lainnya
    });

    if (_formKey.currentState!.validate()) {
      try {
        final apiUrl = '${ApiURL.apiUrl}/api/registerStudent';
        var request = http.MultipartRequest("POST", Uri.parse(apiUrl));
        request.fields['email'] = _nimController.text;
        request.fields['password'] = _passwordController.text;
        request.fields['first_name'] = _firstNameController.text;
        request.fields['last_name'] = _lastNameController.text;
        request.fields['gender'] = _genderController.text;
        request.fields['birth_date'] = _birthDateController.text;
        request.fields['entry_year'] = _entryYearController.text;

        if (_pickedFile != null && _pickedFile!.files.isNotEmpty) {
          print('Berhasil mendapatkan Gambar');
          request.files.add(await http.MultipartFile.fromPath(
            'avatar',
            _pickedFile!.files.first.path!,
          ));
        } else if (_pickedFile == null && _pickedFile!.files.isEmpty) {
          print('Gambar Kosong');
          // If no avatar is provided, use a default avatar
          var defaultAvatarPath = 'assets/img/ProfileDefault.png';
          var defaultAvatarFile = File(defaultAvatarPath);
          request.files.add(await http.MultipartFile.fromPath(
            'avatar',
            defaultAvatarFile.path,
          ));
        }

        // Check Data Post
        print([
          request.fields['email'],
          request.fields['password'],
          request.fields['first_name'],
          request.fields['last_name'],
          _pickedFile,
          _avatar,
          request.fields['gender'],
          request.fields['birth_date'],
          request.fields['entry_year'],
        ]);

        var response = await request.send();

        if (response.statusCode == 201) {
        print('Berhasil Registrasi');
         showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Berhasil Registrasi'),
              content: Text('Silahkan tunggu Konfirmasi Admin!'),
            );
            },
        );
        Timer(const Duration(seconds: 2), () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ));
        });
         
          // Redirect ke halaman login atau halaman lainnya
        } else {
          final responseJson =
              jsonDecode(await response.stream.bytesToString());
          if (responseJson.containsKey('error')) {
            final errors = responseJson['error'];
            String errorMessage = '';
            errors.forEach((key, value) {
              errorMessage += '$key: $value';
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Gagal mendaftar. Silakan periksa data berikut: $errorMessage'),
                duration: Duration(seconds: 2),
              ),
            );
          } else {
            print(response.statusCode);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Gagal mendaftar. Silakan coba lagi.'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Terjadi kesalahan. Periksa koneksi internet Anda atau data Anda.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _birthDateController.text =
            DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  DateTime selectedYear = DateTime.now();

  Future<void> _selectYear(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedYear,
        firstDate: DateTime(1959),
        lastDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.year);
    if (picked != null && picked != selectedYear) {
      setState(() {
        selectedYear = picked;
        _entryYearController.text = '${selectedYear.year}';
      });
    }
  }

  final List<String> genderOptions = ["male", "female"];
  String selectedGender = "male";

  void initState() {
    super.initState();
    loadSelectedGender();
  }

  Future<void> saveSelectedGender(String gender) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedGender', gender);
  }

  Future<void> loadSelectedGender() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String gender = prefs.getString('selectedGender') ?? 'male';
    await prefs.setString('selectedGender', gender);
    setState(() {
      _genderController.text = gender;
    });
  }

  bool _isSecurePassword = true;

  @override
  Widget build(BuildContext context) {
    // Responsive
    double screenWidth = MediaQuery.of(context).size.width;
    double margin = screenWidth * 0.082;
    double marginWidth = screenWidth * 0.06;
    double fontSizeTitle = MediaQuery.of(context).size.width * 0.035;
    double fontSizeValue = MediaQuery.of(context).size.width * 0.032;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          shadowColor: Colors.black26,
          backgroundColor: Colors.white,
          centerTitle: true, // Menyusun judul di tengah
          title: Text(
            'DAFTAR AKUN',
            style: GoogleFonts.mulish(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
          ), // Judul AppBar
        ),
        body: ListView(
          children: [
            Container(
                margin: EdgeInsets.symmetric(
                    horizontal: marginWidth, vertical: margin),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Nomor Induk
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Nomor Induk Mahasiswa (NIM):',
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.lato(
                                        fontWeight: textRegular,
                                        fontSize: fontSizeTitle))
                              ],
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _nimController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  setState(() {
                                    _nimError =
                                        'Nomor Induk Mahasiswa (NIM) wajib diisi';
                                  });
                                  return null;
                                }
                                return null;
                              },
                              style: GoogleFonts.lato(
                                fontSize: fontSizeValue,
                              ),
                              decoration: InputDecoration(
                                errorText: _nimError,
                                hintText: 'Nomor induk mahasiswa',
                                hintStyle: GoogleFonts.lato(
                                  fontSize: fontSizeValue,
                                  color: hintText,
                                ),

                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: borderInput,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width *
                                          0.022),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 155, 155, 155),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width *
                                          0.022),
                                ),

                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 17,
                                    vertical:
                                        17), // Atur tinggi input teks di sini
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Nomor Induk End

                      SizedBox(height: 15),

                      // Password
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Kata Sandi:',
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.lato(
                                        fontWeight: textRegular,
                                        fontSize: fontSizeTitle))
                              ],
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              obscureText: _isSecurePassword,
                              controller: _passwordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  setState(() {
                                    _passwordError = 'Kata Sandi wajib diisi!';
                                  });
                                  return null;
                                } else if (value.length < 8) {
                                  _passwordError =
                                      'Kata sandi minimal 8 character';
                                }
                                return null;
                              },
                              style: GoogleFonts.lato(
                                fontSize: fontSizeValue,
                              ),
                              decoration: InputDecoration(
                                errorText: _passwordError,
                                suffixIcon: togglePassword(),
                                hintText: 'Minimal 8 character',
                                hintStyle: GoogleFonts.lato(
                                  fontSize: fontSizeValue,
                                  color: hintText,
                                ),

                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: borderInput,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width *
                                          0.022),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 155, 155, 155),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width *
                                          0.022),
                                ),

                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 17,
                                    vertical:
                                        17), // Atur tinggi input teks di sini
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Nomor Induk End

                      SizedBox(height: 15),
                      // Password End

                      // Nama Pertama
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Nama Pertama:',
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.lato(
                                        fontWeight: textRegular,
                                        fontSize: fontSizeTitle))
                              ],
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _firstNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  setState(() {
                                    _firstNameError =
                                        'Nama Pertama wajib diisi';
                                  });
                                  return null;
                                }
                                return null;
                              },
                              style: GoogleFonts.lato(
                                fontSize: fontSizeValue,
                              ),
                              decoration: InputDecoration(
                                errorText: _firstNameError,
                                hintText: 'Masukkan nama pertama',
                                hintStyle: GoogleFonts.lato(
                                  fontSize: fontSizeValue,
                                  color: hintText,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: borderInput,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width *
                                          0.022),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 155, 155, 155),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width *
                                          0.022),
                                ),

                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 17,
                                    vertical:
                                        17), // Atur tinggi input teks di sini
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Nama Pertama end

                      const SizedBox(height: 15),

                      //  Nama Terakhir
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Nama Terakhir:',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.lato(
                                      fontWeight: textRegular,
                                      fontSize: fontSizeTitle),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  setState(() {
                                    _lastNameError =
                                        'Nama Terakhir wajib diisi';
                                  });
                                  return null;
                                }
                                return null;
                              },
                              controller: _lastNameController,
                              style: GoogleFonts.lato(
                                fontSize: fontSizeValue,
                              ),
                              decoration: InputDecoration(
                                errorText: _lastNameError,
                                hintText: 'Masukkan nama terakhir',
                                hintStyle: GoogleFonts.lato(
                                  fontSize: fontSizeValue,
                                  color: hintText,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: borderInput,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width *
                                          0.022),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 155, 155, 155),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width *
                                          0.022),
                                ),

                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 17,
                                    vertical:
                                        17), // Atur tinggi input teks di sini
                              ),
                            ),
                          ],
                        ),
                      ),

                      //  Nama Terakhir End

                      const SizedBox(height: 15),

                      // Foto Profile
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Foto Profile:',
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.lato(
                                        fontWeight: textRegular,
                                        fontSize: fontSizeTitle))
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                                width: screenWidth,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.022),
                                              bottomLeft: Radius.circular(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.022)),
                                          border: Border.all(
                                              color: borderInput, width: 1),
                                        ),
                                        padding: const EdgeInsets.all(15),
                                        child: Text(
                                          _avatar ?? 'Choose Avatar',
                                          overflow: TextOverflow.clip,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: fontSizeValue),
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                        onPressed: _pickImage,
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.022),
                                                  bottomRight: Radius.circular(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.022)), // Radius sudut tombol
                                              side: const BorderSide(
                                                  color: Colors.transparent,
                                                  width:
                                                      1.0), // Border dengan warna dan lebar tertentu
                                            ),
                                            primary: outlineInput,
                                            padding: const EdgeInsets.all(16)),
                                        child: const Text('Browse'))
                                  ],
                                ))
                          ],
                        ),
                      ),
                      // Foto Profile End

                      const SizedBox(height: 15),

                      // Jenis Kelamin
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Jenis Kelamin:',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.lato(
                                    fontWeight: textRegular,
                                    fontSize: fontSizeTitle),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 17),
                            width: screenWidth,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                    MediaQuery.of(context).size.width * 0.022),
                              ),
                              border: Border.all(color: borderInput, width: 1),
                            ),
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense:
                                    true, // Mengurangi jarak di sekitar dropdown
                              ),
                              icon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: outlineInput,
                              ),
                              value: selectedGender,
                              items: genderOptions.map((String option) {
                                return DropdownMenuItem<String>(
                                  value: option,
                                  child: Text(
                                    option,
                                    style: GoogleFonts.lato(
                                      fontSize: fontSizeValue,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) async {
                                if (newValue != null) {
                                  setState(() {
                                    _genderController.text = newValue;
                                  });
                                  saveSelectedGender(selectedGender);
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();

                                  await prefs.setString(
                                      'selectedGender', newValue);
                                }
                              },
                            ),
                          )
                        ],
                      ),
                      // Jenis Kelamin End

                      const SizedBox(
                        height: 15,
                      ),

                      // Tanggal Lahir
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Tanggal Lahir:',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.lato(
                                    fontWeight: textRegular,
                                    fontSize: fontSizeTitle),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.only(left: 17, right: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                    MediaQuery.of(context).size.width * 0.022),
                              ),
                              border: Border.all(color: borderInput, width: 1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Text(
                                    '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
                                    style: GoogleFonts.mulish(
                                        fontSize: fontSizeValue),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      _selectDate(context);
                                    },
                                    icon: Icon(
                                      Icons.calendar_today_outlined,
                                      color: outlineInput,
                                    ))
                              ],
                            ),
                          )
                        ],
                      ),
                      // Tanggal Lahir End

                      const SizedBox(
                        height: 15,
                      ),

                      // Tahun Angkatan Mahasiswa
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Tahun Angkatan Mahasiswa:',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.lato(
                                    fontWeight: textRegular,
                                    fontSize: fontSizeTitle),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.only(left: 17, right: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                    MediaQuery.of(context).size.width * 0.022),
                              ),
                              border: Border.all(color: borderInput, width: 1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Text(
                                    '${selectedYear.year}',
                                    style: GoogleFonts.mulish(
                                        fontSize: fontSizeValue),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      _selectYear(context);
                                    },
                                    icon: Icon(Icons.calendar_today_outlined,
                                        color: outlineInput))
                              ],
                            ),
                          )
                        ],
                      ),
                      // Tahun Angkatan Mahasiswa End

                      SizedBox(height: 25),

                      Container(
                          width: screenWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90),
                            color: Colors.green,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: ElevatedButton(
                              onPressed: () {
                                _registerUser();
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 17),
                              ),
                              child: Container(
                                child: const Text(
                                  'Daftar',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                            ),
                          )),

                      const SizedBox(
                        height: 20,
                      ),

                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sudah punya akun?',
                              style: GoogleFonts.lato(
                                fontSize: fontSizeValue,
                                color: blueText,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ));
                              },
                              child: Text(
                                'Masuk',
                                style: GoogleFonts.lato(
                                    decoration: TextDecoration.underline,
                                    color: greenSolid,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ));
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
