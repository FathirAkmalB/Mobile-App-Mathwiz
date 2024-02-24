import 'package:consume_api/UI/modules/subject_list.dart';
import 'package:consume_api/UI/exercise_page/subject_list.dart';

import 'package:consume_api/UI/remedial_page/subject_list.dart';
import 'package:consume_api/UI/exam_page/subject_list.dart';
import 'package:consume_api/data/data.dart';
import 'package:consume_api/layout/mainlayout.dart';
import 'package:consume_api/methods/api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Map<String, dynamic>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? name = prefs.getString('name');
    final String? email = prefs.getString('email');
    final String? avatar = prefs.getString('avatar');
    final int? entry_year = prefs.getInt('entry_year');

    return {
      'name': name ?? 'no name',
      'email': email ?? 'no email',
      'avatar': avatar ?? 'no avatar',
      'entry_year': entry_year ?? 2019,
    };
  }

  Future<void> _refresh() async {
    await getUserData();
  }

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    double font16 = widthScreen * 0.043;
    double mtkSize = widthScreen * 0.05;
    double font25 = widthScreen * 0.058;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: RefreshIndicator(
            onRefresh: _refresh,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // App bar
                    AppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      toolbarHeight: heightScreen * 0.1,
                      title: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: widthScreen * 0.02),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Selamat datang di',
                                  style: GoogleFonts.mulish(
                                      fontSize: font16, color: subTitle),
                                ),
                                Text(
                                  'AR MATH',
                                  style: GoogleFonts.mulish(
                                      fontSize: font25,
                                      color: greenSolid,
                                      fontWeight: textBlack),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: widthScreen * 0.38,
                            ),
                            FutureBuilder<Map<String, dynamic>>(
                                future: getUserData(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircleAvatar(
                                      radius:
                                          MediaQuery.of(context).size.width *
                                              0.06,
                                      backgroundImage: const AssetImage(
                                          'assets/img/ProfileDefault.png'),
                                    );
                                  } else if (snapshot.hasError) {
                                    return CircleAvatar(
                                      radius:
                                          MediaQuery.of(context).size.width *
                                              0.06,
                                      backgroundImage: const AssetImage(
                                          'assets/img/ProfileDefault.png'),
                                    );
                                  } else {
                                    final data = snapshot.data;
                                    final avatar = data?['avatar'];
                                    if (avatar != null) {
                                      final avatarData =
                                          '${ApiURL.apiUrl}/storage/${avatar}';
                                      return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MainLayout(
                                                            initialIndex: 3)));
                                          },
                                          child: CircleAvatar(
                                            radius: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.06,
                                            backgroundImage:
                                                NetworkImage('${avatarData}'),
                                          ));
                                    } else if (avatar == null) {
                                      return CircleAvatar(
                                        radius:
                                            MediaQuery.of(context).size.width *
                                                0.06,
                                        backgroundImage: const AssetImage(
                                            'assets/img/ProfileDefault.png'),
                                      );
                                    } else {
                                      return CircleAvatar(
                                        radius:
                                            MediaQuery.of(context).size.width *
                                                0.06,
                                        backgroundImage: const AssetImage(
                                            'assets/img/ProfileDefault.png'),
                                      );
                                    }
                                  }
                                })
                          ],
                        ),
                      ),
                    ),
                    // Hero Image
                    Container(
                      padding: EdgeInsets.all(widthScreen * 0.04),
                      width: widthScreen * 0.89,
                      height: heightScreen * 0.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(widthScreen * 0.05),
                        image: const DecorationImage(
                          image: AssetImage('assets/img/WaveHomeImage.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder<Map<String, dynamic>>(
                            future: getUserData(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text(
                                  'Loading...', // Display a loading message.
                                  style: GoogleFonts.mulish(
                                    fontSize: font16,
                                    color: whiteText,
                                    fontWeight: textExtra,
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                  'Error: ${snapshot.error}', // Display an error message.
                                  style: GoogleFonts.mulish(
                                    fontSize: font16,
                                    color: whiteText,
                                    fontWeight: textExtra,
                                  ),
                                );
                              } else {
                                final data = snapshot.data;
                                final email = data?['email'] ?? '123000';
                                return Text(
                                  email,
                                  style: GoogleFonts.mulish(
                                    color: whiteText,
                                    fontSize: font16,
                                    fontWeight: textBold,
                                  ),
                                );
                              }
                            },
                          ),
                          SizedBox(
                            height: widthScreen * 0.02,
                          ),
                          Container(
                            width: widthScreen * 0.5,
                            child: FutureBuilder<Map<String, dynamic>>(
                              future: getUserData(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text(
                                    'Loading...', // Display a loading message.
                                    style: GoogleFonts.mulish(
                                      fontSize: font25,
                                      color: whiteText,
                                      fontWeight: textExtra,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text(
                                    'Error: ${snapshot.error}', // Display an error message.
                                    style: GoogleFonts.mulish(
                                      fontSize: font25,
                                      color: whiteText,
                                      fontWeight: textExtra,
                                    ),
                                  );
                                } else {
                                  final data = snapshot.data;
                                  final name = data?['name'] ?? 'Guest';
                                  return RichText(
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                        text: name,
                                        style: GoogleFonts.mulish(
                                            fontSize: font25,
                                            color: whiteText,
                                            fontWeight: textExtra)),
                                  );
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: widthScreen * 0.03,
                          ),
                          FutureBuilder(
                              future: getUserData(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text(
                                    'Loading...', // Display a loading message.
                                    style: GoogleFonts.mulish(
                                      color: whiteText,
                                      fontSize: mtkSize,
                                      fontWeight: textMedium,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text(
                                      'Error : ${snapshot.error.hashCode}');
                                } else if (snapshot.hasData) {
                                  final data = snapshot.data;
                                  final tahunAngkatan = data?['entry_year'];
                                  return Text(
                                    tahunAngkatan.toString(),
                                    style: GoogleFonts.mulish(
                                      color: whiteText,
                                      fontSize: font16,
                                      fontWeight: textMedium,
                                    ),
                                  );
                                } else {
                                  return Text(
                                      'Error : ${snapshot.error.hashCode}');
                                }
                              })
                        ],
                      ),
                    ),
                    SizedBox(
                      height: heightScreen * 0.025,
                    ),

                    // Search Bar
                    Container(
                        width: widthScreen * 0.89,
                        height: widthScreen * 0.14,
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        decoration: BoxDecoration(
                          color: searchBar,
                          borderRadius:
                              BorderRadius.circular(widthScreen * 0.08),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search),
                            SizedBox(
                              width: 6,
                            ),
                            Expanded(
                              child: TextField(
                                style: GoogleFonts.mulish(
                                    fontSize: font16, color: blackText),
                                decoration: InputDecoration(
                                  hintText: "Cari disini...",
                                  border: InputBorder.none,
                                  hintStyle:
                                      GoogleFonts.mulish(color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        )),

                    // Learn Today
                    SizedBox(
                      height: heightScreen * 0.027,
                    ),
                    Container(
                      width: widthScreen * 0.89,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'What would your learn today?',
                        style: GoogleFonts.mulish(
                            color: Colors.black,
                            fontWeight: textBold,
                            fontSize: font16),
                      ),
                    ),
                    SizedBox(
                      height: heightScreen * 0.03,
                    ),

                    Container(
                      width: widthScreen * 0.89,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const ListSubjectModules();
                                  }));
                                },
                                child: Container(
                                  width: widthScreen * 0.4,
                                  height: widthScreen * 0.4,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        widthScreen * 0.04),
                                    color: inputLogin,
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: widthScreen * 0.18,
                                          height: widthScreen * 0.18,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              image: const DecorationImage(
                                                  image: AssetImage(
                                                      'assets/img/Materi.png'))),
                                        ),
                                        Text(
                                          'Mata Kuliah',
                                          style: GoogleFonts.mulish(
                                              fontSize: font16,
                                              color: Colors.black,
                                              fontWeight: textBold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const ListSubjectExercise();
                                  }));
                                },
                                child: Container(
                                  width: widthScreen * 0.4,
                                  height: widthScreen * 0.4,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        widthScreen * 0.04),
                                    color: inputLogin,
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: widthScreen * 0.18,
                                          height: widthScreen * 0.18,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              image: const DecorationImage(
                                                  image: AssetImage(
                                                      'assets/img/Latihan.png'))),
                                        ),
                                        Text(
                                          'Latihan',
                                          style: GoogleFonts.mulish(
                                              fontSize: font16,
                                              color: Colors.black,
                                              fontWeight: textBold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: widthScreen * 0.89,
                      padding: EdgeInsets.only(bottom: widthScreen * 0.08),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const ListSubjectExam();
                                  }));
                                },
                                child: Container(
                                  width: widthScreen * 0.4,
                                  height: widthScreen * 0.4,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        widthScreen * 0.04),
                                    color: inputLogin,
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: widthScreen * 0.18,
                                          height: widthScreen * 0.18,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              image: const DecorationImage(
                                                  image: AssetImage(
                                                      'assets/img/Ujian.png'))),
                                        ),
                                        Text(
                                          'Ujian',
                                          style: GoogleFonts.mulish(
                                              fontSize: font16,
                                              color: Colors.black,
                                              fontWeight: textBold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const SubjectRemedial();
                                  }));
                                },
                                child: Container(
                                  width: widthScreen * 0.4,
                                  height: widthScreen * 0.4,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        widthScreen * 0.04),
                                    color: inputLogin,
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: widthScreen * 0.18,
                                          height: widthScreen * 0.18,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              image: const DecorationImage(
                                                  image: AssetImage(
                                                      'assets/img/Remedial.png'))),
                                        ),
                                        Text(
                                          'Remedial',
                                          style: GoogleFonts.mulish(
                                              fontSize: font16,
                                              color: Colors.black,
                                              fontWeight: textBold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
