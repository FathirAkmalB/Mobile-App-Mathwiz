import 'package:consume_api/SideBar/Drawer.dart';
import 'package:consume_api/UI/modules/sub_chapter_screens.dart';
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

class ListSubBabModules extends StatefulWidget {
  final chapter;
  final subject;
  final studentId;
  const ListSubBabModules(
      {super.key,
      required this.chapter,
      required this.studentId,
      required this.subject});

  @override
  State<ListSubBabModules> createState() => _ListSubBabModulesState();
}

class _ListSubBabModulesState extends State<ListSubBabModules> {

  Future<Map<String, dynamic>> getSubChapter(
      String chapter_id, int studentId) async {
    final response = await API().getRequest(route: '/getSubChapter/$chapter_id/$studentId');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final subject = data['subject'];
      final chapter = data['chapter'];
      final lecturer = data['lecturer'];
      final totalSubChaptersByChapter = data['total_sub_chapters_by_chapter'];
      final totalSubChaptersHasReadByChapter =
          data['total_sub_chapters_has_read_by_chapter'];
      final dataSubChapters = data['dataSubChapters'];
      return {
        'subject': subject,
        'chapter': chapter,
        'lecturer': lecturer,
        'totalSubChaptersByChapter': totalSubChaptersByChapter,
        'totalSubChaptersHasReadByChapter': totalSubChaptersHasReadByChapter,
        'dataSubChapters': dataSubChapters
      };
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Gagal mengambil data dari API SubChapter');
    }
  }

  // endDrawer
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

  void _openEndDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    double font14 = widthScreen * 0.038;
    double font22 = widthScreen * 0.055;

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/img/bg-blueCircle.png'),
                fit: BoxFit.cover),
          ),
          child: Column(
            children: [
              FutureBuilder(
                  future: getSubChapter(
                      widget.chapter.toString(), widget.studentId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        toolbarHeight: heightScreen * 0.1,
                        title: Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Daftar Sub Bab',
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
                      return AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        toolbarHeight: heightScreen * 0.1,
                        title: Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Daftar Sub Bab',
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
                            'Daftar Sub Bab',
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
                height: widthScreen * 0.02,
              ),
              FutureBuilder(
                future: getSubChapter(
                    widget.chapter.toString(), widget.studentId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      width: widthScreen * 0.85,
                      height: widthScreen * 0.4,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                        color: whiteText,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              text: 'Mata Kuliah - Bab',
                              style: GoogleFonts.mulish(
                                fontSize: font14,
                                fontWeight: textExtra,
                                color: blackText,
                              ),
                            ),
                          ),
                          Text(
                            'Dosen',
                            style: GoogleFonts.mulish(
                                color: greenSolid,
                                fontWeight: textBold,
                                fontSize: font14),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              LinearPercentIndicator(
                                width: widthScreen * 0.65,
                                lineHeight: 12,
                                percent: 0.25,
                                progressColor: blueText,
                                backgroundColor: progressBar,
                              ),
                              Text(
                                '25%',
                                style: GoogleFonts.mulish(
                                  fontWeight: textBold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Dalam Proses Pembelajaran (0 Materi)',
                            style: GoogleFonts.mulish(
                              fontWeight: textBold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Container(
                      width: widthScreen * 0.85,
                      height: widthScreen * 0.4,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                        color: whiteText,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              text: 'Mata Kuliah - Bab',
                              style: GoogleFonts.mulish(
                                fontSize: font14,
                                fontWeight: textExtra,
                                color: blackText,
                              ),
                            ),
                          ),
                          Text(
                            'Dosen',
                            style: GoogleFonts.mulish(
                                color: greenSolid,
                                fontWeight: textBold,
                                fontSize: font14),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              LinearPercentIndicator(
                                width: widthScreen * 0.6,
                                lineHeight: 12,
                                percent: 0.25,
                                progressColor: blueText,
                                backgroundColor: progressBar,
                              ),
                              Text(
                                '25%',
                                style: GoogleFonts.mulish(
                                  fontWeight: textBold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Dalam Proses Pembelajaran (${widget.chapter['total_subChapter']} Materi)',
                            style: GoogleFonts.mulish(
                              fontWeight: textBold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final data = snapshot.data;
                    final subject = data!['subject'];
                    final chapter = data['chapter'];
                    final lecturer = data['lecturer'];

                    final totalSubChaptersByChapter =
                        data['totalSubChaptersByChapter'];
                    final totalSubChaptersHasReadByChapter =
                        data['totalSubChaptersHasReadByChapter'];
                    double decimal = (totalSubChaptersHasReadByChapter /
                        totalSubChaptersByChapter);
                    double percent = decimal * 100;
                    String percentase = percent.toStringAsFixed(0);

                    return Container(
                      width: widthScreen * 0.85,
                      height: widthScreen * 0.4,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                        color: whiteText,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              text: subject == null
                                  ? '${widget.subject} - ${widget.chapter['title']}'
                                  : '$subject - $chapter',
                              style: GoogleFonts.mulish(
                                fontSize: font14,
                                fontWeight: textExtra,
                                color: blackText,
                              ),
                            ),
                          ),
                          Text(
                            lecturer == null ? 'Dosen' : '$lecturer',
                            style: GoogleFonts.mulish(
                                color: greenSolid,
                                fontWeight: textBold,
                                fontSize: font14),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              LinearPercentIndicator(
                                width: widthScreen * 0.64,
                                lineHeight: 12,
                                percent: decimal.isNaN ? 0 : decimal,
                                progressColor: blueText,
                                backgroundColor: progressBar,
                              ),
                              Text(
                                decimal.isNaN ? '0%' : '$percentase%',
                                style: GoogleFonts.mulish(
                                  fontWeight: textBold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Dalam Proses Pembelajaran ($totalSubChaptersByChapter Materi)',
                            style: GoogleFonts.mulish(
                              fontWeight: textBold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container(
                      width: widthScreen * 0.85,
                      height: widthScreen * 0.4,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                        color: whiteText,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              text: 'Mata Kuliah - Bab',
                              style: GoogleFonts.mulish(
                                fontSize: font14,
                                fontWeight: textExtra,
                                color: blackText,
                              ),
                            ),
                          ),
                          Text(
                            'Dosen',
                            style: GoogleFonts.mulish(
                                color: greenSolid,
                                fontWeight: textBold,
                                fontSize: font14),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              LinearPercentIndicator(
                                width: widthScreen * 0.65,
                                lineHeight: 12,
                                percent: 0,
                                progressColor: blueText,
                                backgroundColor: progressBar,
                              ),
                              Text(
                                '0%',
                                style: GoogleFonts.mulish(
                                  fontWeight: textBold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Dalam Proses Pembelajaran (${widget.chapter['total_subChapter']} Materi)',
                            style: GoogleFonts.mulish(
                              fontWeight: textBold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
              SizedBox(
                height: heightScreen * 0.04,
              ),
              Expanded(
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: widthScreen * 0.08),
                      decoration: BoxDecoration(
                          color: whiteText,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      child: FutureBuilder(
                        future: getSubChapter(
                            widget.chapter.toString(), widget.studentId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text(
                                    'Error : ${snapshot.error.toString()}'));
                          } else if (snapshot.hasData) {
                            final data = snapshot.data;
                            final dataSubChapters = data!['dataSubChapters'];
                            if (dataSubChapters.length > 0) {
                              return ListView.builder(
                                itemCount: dataSubChapters.length,
                                itemBuilder: (context, index) {
                                  var subChapter = dataSubChapters[index];
                                  bool hasRead = subChapter['has_read'];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SubChapterScreen(
                                              subChapterId: subChapter['id'],
                                              studentId: widget.studentId),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      height: widthScreen * 0.22,
                                      padding: const EdgeInsets.only(left: 14),
                                      decoration: BoxDecoration(
                                        color: blueText,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(8),
                                              bottomRight: Radius.circular(8)),
                                          color: searchBar,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  width: widthScreen * 0.45,
                                                  child: Text(
                                                    subChapter['title'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.mulish(
                                                        fontSize: 16,
                                                        fontWeight: textBold,
                                                        color: blackText),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 32,
                                                      height: 32,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 6,
                                                        vertical: 8,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: greenSolid,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.play_arrow,
                                                          color: whiteText,
                                                          size: 16,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        width: widthScreen *
                                                            0.025),
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
                                              ],
                                            ),
                                            Container(
                                              width: widthScreen * 0.12,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(hasRead
                                                          ? 'assets/img/TrueCheck.png'
                                                          : 'assets/img/FalseCheck.png'))),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
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
                            throw Exception('Gagal Mengambil API subChapter');
                          }
                        },
                      ))),
            ],
          )),
      endDrawer: CommonDrawer(
        currentIndex: _currentIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}
