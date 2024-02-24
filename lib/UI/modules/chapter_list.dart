import 'package:consume_api/SideBar/Drawer.dart';
import 'package:consume_api/UI/modules/sub_chapter_list.dart';
import 'package:consume_api/UI/modules/subject_list.dart';
import 'package:consume_api/UI/exercise_page/subject_list.dart';
import 'package:consume_api/UI/remedial_page/subject_list.dart';


import 'package:consume_api/layout/mainlayout.dart';
import 'package:consume_api/methods/api.dart';
import 'package:flutter/material.dart';
import 'package:consume_api/data/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:convert';
import 'dart:core';

class ListChapterModules extends StatefulWidget {
  final Map subject;
  final studentId;
  const ListChapterModules(
      {super.key, required this.subject, required this.studentId});

  @override
  State<ListChapterModules> createState() => _ListChapterModulesState();
}

class _ListChapterModulesState extends State<ListChapterModules> {
  Future<Map<String, dynamic>> getChapter(String id, int studentId) async {
    final response =
        await API().getRequest(route: '/getChapter/$id/$studentId');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final subject = data['subject'];
      final totalChapters = data['total_chapters'];
      final dataChapters = data['dataChapters'];
      return {
        'subject': subject,
        'totalChapters': totalChapters,
        'dataChapters': dataChapters
      };
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Gagal mengambil data dari API Chapter');
    }
  }

  // Endrawer
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openEndDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void _onItemSelected(int index) {
    setState(() {
      _currentIndex = index;
      Navigator.pop(context);
    });
    switch (index) {
      case 0:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ListSubjectModules()));
        break;

      case 1:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ListSubjectExercise()));
        break;

      case 2:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const MainLayout(initialIndex: 0)));
        break;

      case 3:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const MainLayout(initialIndex: 2)));
        break;

      case 4:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SubjectRemedial()));
        break;

      case 5:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const MainLayout(initialIndex: 1)));
        break;

      case 6:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const MainLayout(
                      initialIndex: 3,
                    )));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    double font12 = widthScreen * 0.035;
    double font14 = widthScreen * 0.038;
    double font18 = widthScreen * 0.048;
    double font22 = widthScreen * 0.055;

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/img/bg-blueCircle.png'),
                fit: BoxFit.cover),
          ),
          child: Column(children: [
            FutureBuilder(
                future: getChapter(
                    widget.subject['id'].toString(), widget.studentId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      toolbarHeight: heightScreen * 0.1,
                      title: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Daftar Bab',
                          style: GoogleFonts.mulish(
                              fontWeight: textExtra, fontSize: font22),
                        ),
                      ),
                      leading: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.keyboard_arrow_left_rounded),
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(LucideIcons.alignRight),
                          onPressed: () {
                            _openEndDrawer();
                          },
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      toolbarHeight: heightScreen * 0.1,
                      title: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Daftar Bab',
                          style: GoogleFonts.mulish(
                              fontWeight: textExtra, fontSize: font22),
                        ),
                      ),
                      leading: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.keyboard_arrow_left_rounded),
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(LucideIcons.alignRight),
                          onPressed: () {
                            _openEndDrawer();
                          },
                        ),
                      ],
                    );
                  } else if (snapshot.hasData) {
                    final data = snapshot.data;
                    final subject = data!['subject'];
                    return AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      toolbarHeight: heightScreen * 0.1,
                      title: Container(
                        alignment: Alignment.center,
                        child: Text(
                          subject == null
                              ? '${widget.subject['title']}'
                              : '$subject',
                          style: GoogleFonts.mulish(
                              fontWeight: textExtra, fontSize: font22),
                        ),
                      ),
                      leading: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.keyboard_arrow_left_rounded),
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(LucideIcons.alignRight),
                          onPressed: () {
                            _openEndDrawer();
                          },
                        ),
                      ],
                    );
                  } else {
                    return AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      toolbarHeight: heightScreen * 0.1,
                      title: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Daftar Bab',
                          style: GoogleFonts.mulish(
                              fontWeight: textExtra, fontSize: font22),
                        ),
                      ),
                      leading: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.keyboard_arrow_left_rounded),
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(LucideIcons.alignRight),
                          onPressed: () {
                            _openEndDrawer();
                          },
                        ),
                      ],
                    );
                  }
                }),
            SizedBox(
              height: widthScreen * 0.04,
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.symmetric(horizontal: widthScreen * 0.06),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(36),
                      topRight: Radius.circular(36))),
              child: Column(
                children: [
                  SizedBox(
                    height: widthScreen * 0.06,
                  ),
                  FutureBuilder(
                    future: getChapter(
                        widget.subject['id'].toString(), widget.studentId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Materi Pembelajaran',
                                style: GoogleFonts.mulish(
                                    fontSize: font18,
                                    fontWeight: textBold,
                                    color: blackText),
                              ),
                              Text(
                                '(0 Bab)',
                                style: GoogleFonts.mulish(
                                    fontSize: font14,
                                    fontWeight: textBold,
                                    color: greenSolid),
                              ),
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Materi Pembelajaran',
                                style: GoogleFonts.mulish(
                                    fontSize: font18,
                                    fontWeight: textBold,
                                    color: blackText),
                              ),
                              Text(
                                '(0 Bab)',
                                style: GoogleFonts.mulish(
                                    fontSize: font14,
                                    fontWeight: textBold,
                                    color: greenSolid),
                              ),
                            ],
                          ),
                        );
                      } else if (snapshot.hasData) {
                        final data = snapshot.data;
                        final totalSubChapter = data!['totalChapters'];

                        return Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Materi Pembelajaran',
                                style: GoogleFonts.mulish(
                                    fontSize: font18,
                                    fontWeight: textBold,
                                    color: blackText),
                              ),
                              Text(
                                '($totalSubChapter Bab)',
                                style: GoogleFonts.mulish(
                                    fontSize: font14,
                                    fontWeight: textBold,
                                    color: greenSolid),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Materi Pembelajaran',
                                style: GoogleFonts.mulish(
                                    fontSize: font18,
                                    fontWeight: textBold,
                                    color: blackText),
                              ),
                              Text(
                                '(0 Bab)',
                                style: GoogleFonts.mulish(
                                    fontSize: font14,
                                    fontWeight: textBold,
                                    color: greenSolid),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: heightScreen * 0.02,
                  ),
                  Expanded(
                    child: FutureBuilder(
                        future: getChapter(
                            widget.subject['id'].toString(), widget.studentId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text(
                                    'Error: ${snapshot.error.toString()}'));
                          } else if (snapshot.hasData) {
                            final data = snapshot.data;
                            final chaptersData = data!['dataChapters'];
                            final subject = data['subject'];
                            if (chaptersData.length > 0) {
                              final chapterWidgets =
                                  chaptersData.map<Widget>((chapter) {
                                final totalSubChapter =
                                    chapter['total_sub_chapters'];
                                final totalHasRead =
                                    chapter['total_sub_chapters_has_read'];
                                double decimal = totalHasRead / totalSubChapter;
                                double percentase = decimal * 100;
                                String percent = percentase.toStringAsFixed(0);
                                return GestureDetector(
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    height: widthScreen * 0.4,
                                    padding: const EdgeInsets.only(left: 12),
                                    decoration: BoxDecoration(
                                      color: blueText,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: inputLogin,
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(16),
                                          bottomRight: Radius.circular(16),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: widthScreen * 0.78,
                                            child: Text(
                                              '${chapter['title']}',
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.mulish(
                                                fontWeight: textExtra,
                                                fontSize: font14,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '$totalSubChapter Sub Bab',
                                            style: GoogleFonts.mulish(
                                              fontWeight: FontWeight.bold,
                                              fontSize: font14,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              LinearPercentIndicator(
                                                width: widthScreen * 0.65,
                                                lineHeight: 12,
                                                percent:
                                                    decimal.isNaN ? 0 : decimal,
                                                progressColor: blueText,
                                                backgroundColor: progressBar,
                                              ),
                                              SizedBox(
                                                  width: widthScreen * 0.02),
                                              Text(
                                                  decimal.isNaN
                                                      ? '0%'
                                                      : '$percent%',
                                                  style: GoogleFonts.mulish(
                                                    fontWeight: textBold,
                                                    fontSize: font12,
                                                  ))
                                            ],
                                          ),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ListSubBabModules(
                                                            chapter: chapter['id'].toString(),
                                                            subject: subject,
                                                            studentId: widget
                                                                .studentId),
                                                  ),
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 35,
                                                    height: 35,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 6,
                                                      vertical: 8,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: greenSolid,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.play_arrow,
                                                        color: whiteText,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width:
                                                          widthScreen * 0.025),
                                                  Text(
                                                    'Mulai Materi',
                                                    style: GoogleFonts.mulish(
                                                      fontSize: font14,
                                                      color: greenSolid,
                                                      fontWeight: textBold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(); // Konversi ke List<Widget>
                              return ListView(
                                children: chapterWidgets,
                              );
                            } else {
                              return Center(
                                child: Container(
                                  width: widthScreen * 0.6,
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/statuscode/NoData-1.png'))),
                                ),
                              );
                            }
                          } else {
                            return const Center(child: Text('Tidak ada data.'));
                          }
                        }),
                  ),
                  SizedBox(
                    height: heightScreen * 0.02,
                  ),
                ],
              ),
            )),
          ]),
        ),
      ),
      endDrawer: CommonDrawer(
        currentIndex: _currentIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}
