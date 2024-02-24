import 'dart:convert';

import 'package:consume_api/UI/login_user.dart';
import 'package:consume_api/layout/mainlayout.dart';
import 'package:consume_api/methods/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:consume_api/data/data.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreens extends StatefulWidget {
  const ProfileScreens({super.key});

  @override
  State<ProfileScreens> createState() => _ProfileScreensState();
}

class _ProfileScreensState extends State<ProfileScreens> {
  FilePickerResult? _pickedFile;
  String? avatar;

  Future<Map<String, dynamic>> getAllSharedPreferencesData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map<String, dynamic> allData = {};

    Set<String> keys = preferences.getKeys();
    for (String key in keys) {
      allData[key] = preferences.get(key);
    }
    print(allData);
    return allData;
  }

  Future<void> _pickImage() async {
    getAllSharedPreferencesData();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
    );

    if (result != null) {
      setState(() {
        _pickedFile = result;
      });

      // Memanggil fungsi untuk mengirim avatar ke API setelah gambar terpilih
      await updateAvatar(_pickedFile);
    } else {
      // User canceled the picker
    }
  }

  Future<void> updateAvatar(FilePickerResult? pickedFile) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final userId = pref.getInt('id');

    try {
      var apiUrl = '${ApiURL.apiUrl}/api/updateAvatar/$userId';

      var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
        ..fields['_method'] = 'PUT'
        ..headers.addAll({
          'Content-Type': 'multipart/form-data',
        });

      if (pickedFile != null && pickedFile.files.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
          'avatar',
          pickedFile.files.first.path!,
        ));
      } else {
        // Optional: Jika tidak ada foto dipilih, Anda dapat mengirim tanda kosong untuk mempertahankan foto profil yang ada.
        request.fields['avatar'] =
            ''; // Atau sesuaikan dengan parameter kosong yang diharapkan oleh API.
      }

      var response = await request.send();

      if (response.statusCode == 201) {
        var jsonResponse = await response.stream.bytesToString();
        Map<String, dynamic> parsedResponse = jsonDecode(jsonResponse);

        if (parsedResponse.containsKey('avatar')) {
          var avatarUrl = parsedResponse['avatar'];
          setState(() {
            avatar = avatarUrl;
          });
          print('URL Avatar: $avatarUrl');

          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.setString('avatar', avatarUrl);
          print('Avatar URL disimpan di SharedPreferences');
        } else {
          print('Kunci "avatar" tidak ditemukan dalam respons JSON');
        }
      } else {
        print('Gagal memperbarui avatar mahasiswa');
        print('response status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Terjadi kesalahan: $error');
    }
  }

  Future? refreshAvatar;

  Future<void> _refreshAvatar() async {
    refreshAvatar = SharedPreferences.getInstance();
  }

  Future<Map<String, dynamic>> getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    avatar = pref.getString('avatar');
    final String? name = pref.getString('name');
    final String? role = pref.getString('role');
    final String? email = pref.getString('email');
    final String? firstName = pref.getString('first_name');
    final String? lastName = pref.getString('last_name');
    final String? gender = pref.getString('gender');
    final String? birthDate = pref.getString('birth_date');
    final int? entryYear = pref.getInt('entry_year');

    return {
      'name': name ?? 'no name',
      'avatar': avatar ?? 'no avatar',
      'email': email ?? 'no email',
      'first_name': firstName ?? 'no first_name',
      'last_name': lastName ?? 'no first_name',
      'gender': gender ?? 'no gender',
      'role': role ?? 'no role',
      'birth_date': birthDate,
      'entry_year': entryYear,
    };
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    double marginWidth = widthScreen * 0.06;
    double margin = widthScreen * 0.082;
    double font12 = widthScreen * 0.03;
    double font14 = widthScreen * 0.038;
    double font22 = widthScreen * 0.055;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshAvatar,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  toolbarHeight: heightScreen * 0.1,
                  title: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Profile',
                      style: GoogleFonts.mulish(
                          fontWeight: textExtra,
                          fontSize: font22,
                          color: blackText),
                    ),
                  ),
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainLayout(
                                    initialIndex: 0,
                                  )));
                    },
                    icon: const Icon(Icons.keyboard_arrow_left_rounded),
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {
                          _refreshAvatar();
                        },
                        icon: const Icon(
                          Icons.notifications_active,
                          color: Colors.transparent,
                        ))
                  ],
                ),
                FutureBuilder(
                    future: getUserData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Text('Sedang mengecek data...'),
                        );
                      } else if (snapshot.hasData) {
                        final data = snapshot.data;
                        final name = data?['name'];
                        final role = data?['role'];
                        final avatar = data?['avatar'];
                        return Column(
                          children: [
                            Container(
                              width: widthScreen * 0.3,
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  CircleAvatar(
                                    radius: MediaQuery.of(context).size.width *
                                        0.15,
                                    backgroundImage: avatar != null
                                        ? NetworkImage(
                                            '${ApiURL.apiUrl}/storage/$avatar')
                                        : const AssetImage(
                                                'assets/img/DefaultProfile.png')
                                            as ImageProvider,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                        alignment: Alignment.bottomRight,
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: whiteText),
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          color: yellowText,
                                        ),
                                        child: Center(
                                          child: IconButton(
                                              onPressed: () {
                                                _pickImage();
                                              },
                                              icon: Icon(
                                                Icons.photo_camera_rounded,
                                                size: 30,
                                                color: whiteText,
                                              )),
                                        )),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: heightScreen * 0.02,
                            ),
                            Container(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: heightScreen * 0.02,
                                  ),
                                  Text(
                                    name.toString(),
                                    style: GoogleFonts.mulish(
                                        fontSize: font22,
                                        fontWeight: textExtra,
                                        color: blackText),
                                  ),
                                  SizedBox(
                                    height: heightScreen * 0.01,
                                  ),
                                  Text(
                                    role.toString(),
                                    style: GoogleFonts.mulish(
                                        fontSize: font14,
                                        fontWeight: textMedium,
                                        color: Color(0xFFABABAB)),
                                  ),
                                  SizedBox(
                                    height: heightScreen * 0.03,
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: marginWidth),
                                    height: 1,
                                    color: progressBar,
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Text('error has not data');
                      }
                    }),
                FutureBuilder(
                    future: getUserData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Text('Sedang memuat data'),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error.hashCode}'),
                        );
                      } else if (snapshot.hasData) {
                        final data = snapshot.data;
                        final firstName = data?['first_name'];
                        final lastName = data?['last_name'];
                        final email = data?['email'];
                        final gender = data?['gender'];
                        final birthDate = data?['birth_date'];
                        final entryYear = data?['entry_year'];

                        return Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: marginWidth, vertical: margin),
                          child: Column(children: [
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
                                              fontSize: 14))
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    width: widthScreen,
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: widthScreen * 0.04),
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: borderInput,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.width *
                                              0.022),
                                    ),
                                    child: Text(email.toString()),
                                  )
                                ],
                              ),
                            ),
                            // Nomor Induk End

                            SizedBox(height: 15),
                            // Nomor Induk
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
                                              fontSize: 14))
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    width: widthScreen,
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: widthScreen * 0.04),
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: borderInput,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.width *
                                              0.022),
                                    ),
                                    child: Text(firstName.toString()),
                                  )
                                ],
                              ),
                            ),
                            // Nomor Induk End

                            SizedBox(height: 15),
                            // Nomor Induk
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Nama Terakhir:',
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.lato(
                                              fontWeight: textRegular,
                                              fontSize: 14))
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    width: widthScreen,
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: widthScreen * 0.04),
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: borderInput,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.width *
                                              0.022),
                                    ),
                                    child: Text(lastName.toString()),
                                  )
                                ],
                              ),
                            ),
                            // Nomor Induk End

                            SizedBox(height: 15),
                            // Nomor Induk
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Jenis Kelamin:',
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.lato(
                                              fontWeight: textRegular,
                                              fontSize: 14))
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    width: widthScreen,
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: widthScreen * 0.04),
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: borderInput,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.width *
                                              0.022),
                                    ),
                                    child: Text(gender.toString()),
                                  )
                                ],
                              ),
                            ),
                            // Nomor Induk End

                            SizedBox(height: 15),
                            // Nomor Induk
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Tanggal Lahir:',
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.lato(
                                              fontWeight: textRegular,
                                              fontSize: 14))
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    width: widthScreen,
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: widthScreen * 0.04),
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: borderInput,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.width *
                                              0.022),
                                    ),
                                    child: Text(birthDate.toString()),
                                  )
                                ],
                              ),
                            ),
                            // Nomor Induk End

                            SizedBox(height: 15),
                            // Nomor Induk
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Tahun Angkatan:',
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.lato(
                                              fontWeight: textRegular,
                                              fontSize: 14))
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    width: widthScreen,
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: widthScreen * 0.04),
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: borderInput,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.width *
                                              0.022),
                                    ),
                                    child: Text(entryYear.toString()),
                                  )
                                ],
                              ),
                            ),
                            // Nomor Induk End
                          ]),
                        );
                      } else {
                        return Text('Periksa Koneksi anda');
                      }
                    }),
                SizedBox(
                  height: heightScreen * 0.005,
                ),
                ElevatedButton(
                  onPressed: validasiLogout,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    fixedSize: MaterialStateProperty.all<Size>(
                      Size(widthScreen * 0.9, heightScreen * 0.058),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(90),
                      ),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.all(16),
                    ),
                  ),
                  child: Text(
                    'Keluar',
                    style: GoogleFonts.mulish(
                        fontSize: font12, fontWeight: textMedium),
                  ),
                ),
                SizedBox(
                  height: heightScreen * 0.02,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> validasiLogout() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Apakah kamu yakin?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  logout();
                },
                child: Text('Keluar'),
              )
            ],
          );
        });
  }

  Future<void> logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    var response = await http.post(
      Uri.parse('${ApiURL.apiUrl}/api/auth/logout'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      // Hapus token autentikasi dari SharedPreferences
      preferences.remove('token');

      // Kembali ke halaman login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    } else {
      // Tampilkan pesan kesalahan jika logout gagal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout gagal')),
      );
    }
  }
}
