import 'package:consume_api/SideBar/Drawer.dart';
import 'package:consume_api/UI/modules/subject_list.dart';
import 'package:consume_api/UI/exercise_page/exercise_list.dart';
import 'package:consume_api/UI/exercise_page/subject_list.dart';

import 'package:consume_api/UI/qr_scanner/scanner.dart';
import 'package:consume_api/UI/remedial_page/subject_list.dart';

import 'package:consume_api/layout/mainlayout.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/material.dart';
import 'package:consume_api/methods/api.dart';
import 'package:consume_api/data/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'dart:core';

import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubChapterScreen extends StatefulWidget {
  final subChapterId;
  final studentId;
  const SubChapterScreen(
      {super.key, required this.subChapterId, required this.studentId});

  @override
  State<SubChapterScreen> createState() => _SubChapterScreenState();
}

class _SubChapterScreenState extends State<SubChapterScreen> {
  @override
  void initState() {
    super.initState();
    getTitle();
  }

  String title = '';

  Future<void> getTitle() async {
    final response = await API().getRequest(route: '/getSubChapterById/${widget.subChapterId}/${widget.studentId}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        title = data['title'];
      });
      
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Gagal mengambil data dari API SubChapter');
    }
  }

  Future<Map<String, dynamic>> getSubChapterById(
      String sub_id, int studentId) async {
    final response = await API().getRequest(
        route: '/getSubChapterById/${widget.subChapterId}/$studentId');
    print('Successfully response');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Gagal mengambil data dari API SubChapter');
    }
  }

  Future? hasRead;
  Future<void> refreshContent() async {
    setState(() {
      hasRead = getSubChapterById(widget.subChapterId.toString(), widget.studentId);
    });
  }

  Future<bool> markAsRead(int id, int studentId) async {
    Map<String, dynamic> body = {
      'student_id': studentId,
    };

    try {
    final response = await API().postRequest(route: '/hasRead/$id', data: body);    
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        print('message: ${response.statusCode}');
        // ignore: use_build_context_synchronously
        Navigator.push(context, 
        MaterialPageRoute(builder: (context) => const ListSubjectModules(),));

        return data['status'] ?? false;
      } else {
        throw Exception('Gagal melakukan request: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

   int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onItemSelected(int index) {
    setState(() {
      _currentIndex = index;
      Navigator.pop(context); 
    });
    switch (index){
      case 0:
      Navigator.push(context, 
      MaterialPageRoute(builder: (context)=> const ListSubjectModules()));
        break;

      case 1:
      Navigator.push(context, 
      MaterialPageRoute(builder: (context)=> const ListSubjectExercise()));
        break;

      case 2:
      Navigator.push(context, 
      MaterialPageRoute(builder: (context)=> const MainLayout(initialIndex: 0)));
        break;

      case 3:
      Navigator.push(context, 
      MaterialPageRoute(builder: (context)=> const MainLayout(initialIndex: 2)));
        break;
      
      case 4:
      Navigator.push(context, 
      MaterialPageRoute(builder: (context)=> const SubjectRemedial()));
        break;
      
      case 5:
      Navigator.push(context, 
      MaterialPageRoute(builder: (context)=> const MainLayout(initialIndex: 1)));
        break;
      
      case 6:
      Navigator.push(context, 
      MaterialPageRoute(builder: (context)=> const MainLayout(initialIndex: 3,)));
        break;
      

    }
  }
  
   void _openEndDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }



  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    double margin = widthScreen * 0.082;
    double font12 = widthScreen * 0.03;
    double font14 = widthScreen * 0.038;
    double font16 = widthScreen * 0.043;
    double font18 = widthScreen * 0.048;
    double font22 = widthScreen * 0.055;

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/img/bg-blueCircle.png'),
                fit: BoxFit.cover),
          ),
          child: Column(children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: heightScreen * 0.1,
              title: Container(
                alignment: Alignment.center,
                child: Text(
                  title,
                  style: GoogleFonts.mulish(
                      fontWeight: textExtra, fontSize: font22),
                ),
              ),
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  (Icons.keyboard_arrow_left_rounded),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(LucideIcons.alignRight),
                  onPressed: () {
                    _scaffoldKey.currentState!.openEndDrawer();
                  },
                ),
              ],
            ),
            SizedBox(
              height: heightScreen * 0.02,
            ),
            Expanded(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: widthScreen * 0.04),
                  decoration: BoxDecoration(
                      color: whiteText,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24))),
                  child: ListView(
                    children: [
                      FutureBuilder(
                          future: getSubChapterById(widget.subChapterId.toString(), widget.studentId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: greenSolid,
                                ),
                              );
                            } else if (snapshot.hasError) {
                              print('Error Materi: ${snapshot.error.hashCode}');
                              return const Text('Tidak dapat memuat Materi.');
                            } else if (snapshot.hasData) {
                              final data = snapshot.data;
                              final hasRead = data!['has_read'];
                              final htmlContent = data['content'].toString();
                              return Column(
                                children: [
                                  HtmlWidget( 
                                    enableCaching: true,
                                    htmlContent,
                                    textStyle: GoogleFonts.mulish(
                                      height: 1.5,
                                    ),
                                  ),
                                  SizedBox(
                                    height: widthScreen * 0.06,
                                  ),
                                  Container(
                                    height: 1,
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(70, 61, 61, 61),
                                      boxShadow:  [
                                                  BoxShadow(
                                                    color: Color.fromARGB(40, 0, 0, 0),
                                                    offset: Offset(0,
                                                        0.5), // Y-offset of -2
                                                    blurRadius:
                                                        2, // Optional blur radius
                                                    spreadRadius:
                                                        0, // Optional spread radius
                                                  ),
                                                ], 
                                    ),
                                  ),
                                  SizedBox(
                                    height: widthScreen * 0.035,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      markAsRead(widget.subChapterId, widget.studentId);
                                      refreshContent();
                                    },
                                    child: Container(
                                      height: widthScreen * 0.12,
                                      decoration: BoxDecoration(
                                        color: hasRead? subTitle : blueText,
                                        borderRadius: BorderRadius.circular(8)
                                      ),
                                      child: Center(
                                        child: Text('Selesai',
                                        style: GoogleFonts.mulish(
                                          fontSize: font14,
                                          color: whiteText,
                                          fontWeight: textBold
                                        ) ,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return const Text('Tidak ada Content');
                            }
                          }),
                      SizedBox(
                        height: widthScreen * 0.2,
                      ),
                    ],
                  )),
            ),
          ])),
      floatingActionButton: FutureBuilder<Map<String, dynamic>>(
        future: getSubChapterById(widget.subChapterId.toString(), widget.studentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SpeedDial(
              backgroundColor: greenSolid,
              child: CircularProgressIndicator(color: whiteText),
            );
          } else if (snapshot.hasError) {
            print('Err:' + snapshot.error.hashCode.toString());
            return SpeedDial(
              animatedIcon: AnimatedIcons.menu_close,
              backgroundColor: greenSolid,
              overlayColor: blackText,
              overlayOpacity: 0.4,
              spacing: 12,
              spaceBetweenChildren: 12,
              children: [
                SpeedDialChild(
                  onTap: () async {
                    SharedPreferences pref = await SharedPreferences.getInstance();
                    final studentId = pref.getInt('student_id');
                    final subChapter = widget.subChapterId;
                    if (subChapter != subChapter.isEmpty) {
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExerciseList(
                              studentId: studentId,
                              subChapterId: subChapter,
                            ),
                          ),
                        );
                      } else {
                        print('Else Materi');
                      }
                    },
                    child: Icon(
                      Icons.ads_click,
                      color: whiteText,
                    ),
                    backgroundColor: blueText,
                    label: 'Soal Latihan',
                    labelStyle:
                        const TextStyle(backgroundColor: Colors.transparent),
                  ),
                ],
              );
            } else if (snapshot.hasData) {
              final data = snapshot.data;
              final resource = data!['resource'].toString();
              print('data resource: ${resource}');

            // Instagram Resource
            if (resource.startsWith('https://www.instagram.com/ar/')) {
              return SpeedDial(
                animatedIcon: AnimatedIcons.menu_close,
                backgroundColor: greenSolid,
                overlayColor: const Color.fromARGB(255, 0, 0, 0),
                overlayOpacity: 0.41,
                spacing: 12,
                spaceBetweenChildren: 12,
                children: [
                  SpeedDialChild(
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QRScanner(link: resource)));
                    },
                    child: Icon(
                      Icons.view_in_ar_rounded,
                      color: whiteText,
                    ),
                    backgroundColor: blueText,
                    label: 'AR Math',
                    labelStyle:
                        const TextStyle(backgroundColor: Colors.transparent),
                  ),
                  SpeedDialChild(
                    onTap: () async {
                      SharedPreferences pref = await SharedPreferences.getInstance();
                    final studentId = pref.getInt('student_id');
                      final subChapter = widget.subChapterId;
                      if (subChapter != null) {
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExerciseList(
                              subChapterId: subChapter,
                              studentId: studentId,
                            ),
                          ),
                        );
                      } else {
                        print('Tidak ada');
                      }
                    },
                    child: Icon(
                      Icons.ads_click,
                      color: whiteText,
                    ),
                    backgroundColor: blueText,
                    label: 'Soal Latihan',
                    labelStyle:
                        const TextStyle(backgroundColor: Colors.transparent),
                  ),
                ],
              );

              // Youtube Resource
            } else if (resource.startsWith('https://www.youtube.com/') ||
                resource.startsWith('<iframe>')) {
              return SpeedDial(
                animatedIcon: AnimatedIcons.menu_close,
                backgroundColor: greenSolid,
                overlayColor: Colors.black,
                overlayOpacity: 0.4,
                spacing: 12,
                spaceBetweenChildren: 12,
                children: [
                  SpeedDialChild(
                    onTap: () async {
                      SharedPreferences pref = await SharedPreferences.getInstance();
                      final studentId = pref.getInt('student_id');
                      final subChapter = widget.subChapterId;
                      if (subChapter != null) {
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExerciseList(
                              subChapterId: subChapter,
                              studentId: studentId,
                            ),
                          ),
                        );
                      } else {
                        print('Tidak');
                      }
                    },
                    child: Icon(
                      Icons.ads_click,
                      color: whiteText,
                    ),
                    backgroundColor: blueText,
                    label: 'Soal Latihan',
                    labelStyle:
                        const TextStyle(backgroundColor: Colors.transparent),
                  ),
                ],
              );

              // Google Drive Resource
            } else if (resource.startsWith('https://drive.google.com/')) {
              return SpeedDial(
                animatedIcon: AnimatedIcons.menu_close,
                backgroundColor: greenSolid,
                overlayColor: Colors.black,
                overlayOpacity: 0.4,
                spacing: 12,
                spaceBetweenChildren: 12,
                children: [
                  SpeedDialChild(
                    onTap: () async {
                      
                    },
                    child: Icon(
                      Icons.mic_none,
                      color: whiteText,
                    ),
                    backgroundColor: blueText,
                    label: 'Audio',
                    labelStyle:
                        const TextStyle(backgroundColor: Colors.transparent),
                  ),
                  SpeedDialChild(
                    onTap: () async {
                      final subChapter = widget.subChapterId;
                      SharedPreferences pref = await SharedPreferences.getInstance();
                      final studentId = pref.getInt('student_id');
                      if (subChapter != null) {
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ExerciseList(
                                    subChapterId: widget.subChapterId,
                                    studentId: studentId,
                                  )),
                        );
                      } else {
                        print('Tidak');
                      }
                    },
                    child: Icon(
                      Icons.ads_click,
                      color: whiteText,
                    ),
                    backgroundColor: blueText,
                    label: 'Soal Latihan',
                    labelStyle:
                        const TextStyle(backgroundColor: Colors.transparent),
                  ),
                ],
              );
            } else {
              return SpeedDial(
                animatedIcon: AnimatedIcons.menu_close,
                backgroundColor: greenSolid,
                overlayColor: Colors.black,
                overlayOpacity: 0.4,
                spacing: 12,
                spaceBetweenChildren: 12,
                children: [
                  SpeedDialChild(
                    onTap: () async {
                      final subChapter = widget.subChapterId;
                      SharedPreferences pref = await SharedPreferences.getInstance();
                      final studentId = pref.getInt('student_id');
                      if (subChapter != null) {
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExerciseList(
                              subChapterId:
                                  subChapter,
                                  studentId: studentId,
                            ),
                          ),
                        );
                      } else {
                        print('Tidak');
                      }
                    },
                    child: Icon(
                      Icons.ads_click,
                      color: whiteText,
                    ),
                    backgroundColor: blueText,
                    label: 'Soal Latihan',
                    labelStyle:
                        const TextStyle(backgroundColor: Colors.transparent),
                  ),
                ],
              );
            }
          } else {
            throw Exception('hua');
          }
        },
      ),
      endDrawer:CommonDrawer(
        currentIndex: _currentIndex,
        onItemSelected: _onItemSelected,
      )
    );
  }
}