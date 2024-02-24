import 'package:consume_api/SideBar/Drawer.dart';
import 'package:consume_api/UI/modules/subject_list.dart';
import 'package:consume_api/UI/exercise_page/exercise_list.dart';
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

import 'package:shimmer/shimmer.dart';

class ListSubChapter extends StatefulWidget {
  final Map chapter;
  final int studentId;
  const ListSubChapter({super.key, required this.chapter, required this.studentId});

  @override
  State<ListSubChapter> createState() => _ListSubChapterState();
}

class _ListSubChapterState extends State<ListSubChapter> {
  String? subject;
  String? chapter;
  String? lecturer;
  int totalExercisesByChapters = 0;
  int totalExercisesByChaptersAttempted = 0;
  int totalSubChapters = 0;
  List<Map<String, dynamic>> dataSubChapters = [];

  Future<Map<String, dynamic>> getDataByChapter(String chapter_id, int studentId) async {
   
    
      final response = await API().getRequest(route: '/getDataByChapter/$chapter_id/$studentId');
        try {
            if (response.statusCode == 200) {
              final responseData = json.decode(response.body);
              subject = responseData['subject'];
              chapter = responseData['chapter'];
              lecturer = responseData['lecturer'];
              totalExercisesByChapters = responseData['total_exercises_by_chapters'];
              totalExercisesByChaptersAttempted = responseData['total_attempted_exercises_by_chapters'];
              totalSubChapters = responseData['total_sub_chapters'];
              dataSubChapters = List<Map<String, dynamic>>.from(responseData['dataSubChapters']);
              return {
                'subject': subject,
                'chapter': chapter,
                'lecturer': lecturer,
                'totalExercisesByChapters': totalExercisesByChapters,
                'totalExercisesByChaptersAttempted': totalExercisesByChaptersAttempted,
                'totalSubChapters': totalSubChapters,
                'dataSubChapters': dataSubChapters,
              };
            } else {
              throw Exception('Failed to load data');
            }
        } catch (e) {
          throw Exception('Error: $e');
        }
  }


  // Endrawer
  int _currentIndex = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


   void _openEndDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

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

  @override
 Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    double font12 = widthScreen * 0.03;
    double font14 = widthScreen * 0.038;
    double font16 = widthScreen * 0.043;
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
                future: getDataByChapter(widget.chapter['id'].toString(), widget.studentId), 
                builder: (context, snapshot){
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
                  }else if (snapshot.hasError){
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
                            onPressed: () {},
                            icon: const Icon(Icons.more_vert_rounded))
                      ],
                    );
                  }else if (snapshot.hasData){
                    return AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        toolbarHeight: heightScreen * 0.1,
                        title: Container(
                          alignment: Alignment.center,
                          child: Text(
                            '$subject',
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
                  }else{
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
                            onPressed: () {},
                            icon: const Icon(Icons.more_vert_rounded))
                      ],
                    );
                  }
                }
              ),
              SizedBox(
                height: widthScreen * 0.02,
              ),
              FutureBuilder(
                future: getDataByChapter(widget.chapter['id'].toString(), widget.studentId), 
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!, // Warna latar belakang shimmer
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: widthScreen * 0.85,
                        height: widthScreen * 0.4,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                                text:
                                    '$subject - bab',
                                style: GoogleFonts.mulish(
                                  fontSize: font14,
                                  fontWeight: textExtra,
                                  color: blackText,
                                ),
                              ),
                            ),
                            Text(
                              'lecturer',
                              style: GoogleFonts.mulish(
                                  color: greenSolid,
                                  fontWeight: textBold,
                                  fontSize: font14
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                LinearPercentIndicator(
                                  width: widthScreen * 0.65,
                                  lineHeight: 12,
                                  percent: 0.25, 
                                  progressColor: totalExercisesByChaptersAttempted != totalExercisesByChapters ? yellowText : totalExercisesByChapters == 0 ? yellowText : totalExercisesByChaptersAttempted == totalExercisesByChapters ? blueText : yellowText,
                                  backgroundColor: progressBar,
                                ),
                                Text(
                                  '25%',
                                  style: GoogleFonts.mulish(
                                    fontWeight: textBold,
                                    fontSize: font12,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Dalam Proses Pengerjaan (0 Materi)',
                              style: GoogleFonts.mulish(
                                fontWeight: textBold,
                                fontSize: font12,
                              ),
                            ),
                          ],
                        ),
                      ) 
                    );
                  }else if(snapshot.hasError){
                    return Container(
                        width: widthScreen * 0.85,
                        height: widthScreen * 0.4,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                                text:
                                    '$subject - $chapter',
                                style: GoogleFonts.mulish(
                                  fontSize: font14,
                                  fontWeight: textExtra,
                                  color: blackText,
                                ),
                              ),
                            ),
                            Text(
                              '$lecturer',
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
                                  percent: 0,
                                  progressColor: blueText,
                                  backgroundColor: progressBar,
                                ),
                                Text(
                                  '0%',
                                  style: GoogleFonts.mulish(
                                    fontWeight: textBold,
                                    fontSize: font12,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Dalam Proses Pengerjaan',
                              style: GoogleFonts.mulish(
                                fontWeight: textBold,
                                fontSize: font12,
                              ),
                            ),
                          ],
                        ),
                      );
                  }else if(snapshot.hasData){
                    final data = snapshot.data;

                    final totalExercisesByChapters = data!['totalExercisesByChapters']; 
                    final totalExercisesByChaptersAttempted = data['totalExercisesByChaptersAttempted'];
                    int minus = totalExercisesByChapters - totalExercisesByChaptersAttempted;
                    
                    double decimal = (totalExercisesByChaptersAttempted/totalExercisesByChapters);
                    double toPercent = decimal * 100;
                    String percent = toPercent.toStringAsFixed(1);

                    return Container(
                        width: widthScreen * 0.85,
                        height: widthScreen * 0.4,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                                text:
                                    '$subject - $chapter',
                                style: GoogleFonts.mulish(
                                  fontSize: font14,
                                  fontWeight: textExtra,
                                  color: blackText,
                                ),
                              ),
                            ),
                            Text(
                              '$lecturer',
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
                                  percent: decimal.isNaN ? 0 : decimal, 
                                  progressColor: blueText,
                                  backgroundColor: progressBar,
                                ),
                                Text(
                                  decimal.isNaN ? '0%' : '$percent%',
                                  style: GoogleFonts.mulish(
                                    fontWeight: textBold,
                                    fontSize: font12,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Dalam Proses Pengerjaan (${minus} Materi)',
                              style: GoogleFonts.mulish(
                                fontWeight: textBold,
                                fontSize: font12,
                              ),
                            ),
                          ],
                        ),
                      );
                  }else{
                    return Container(
                        width: widthScreen * 0.85,
                        height: widthScreen * 0.4,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                                text:
                                    '$subject - $chapter',
                                style: GoogleFonts.mulish(
                                  fontSize: font14,
                                  fontWeight: textExtra,
                                  color: blackText,
                                ),
                              ),
                            ),
                            Text(
                              '$lecturer',
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
                                  percent: 0, 
                                  progressColor: blueText,
                                  backgroundColor: progressBar,
                                ),
                                Text(
                                  '0%',
                                  style: GoogleFonts.mulish(
                                    fontWeight: textBold,
                                    fontSize: font12,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Dalam Proses Pengerjaan Materi',
                              style: GoogleFonts.mulish(
                                fontWeight: textBold,
                                fontSize: font12,
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
                        future: getDataByChapter(widget.chapter['id'].toString(), widget.studentId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error : ${snapshot.error.toString()}'));
                          } else if (snapshot.hasData) {
                            return ListView(
                            children: dataSubChapters.map((subChapter) {
                            final totalExercise = subChapter['total_exercises_by_sub_chapter'];
                            final totalExerciseAttempted = subChapter['total_attempted_exercises_by_sub_chapter'];

                            // True or False SubChapter
                            final bool boolCheck = totalExerciseAttempted == 0 ? false : totalExerciseAttempted == totalExercise ? true : false;
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ExerciseList(
                                         subChapterId: subChapter['id'],
                                         studentId: widget.studentId
                                      ),
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
                                              width:  widthScreen * 0.5,
                                              child: Text(
                                              subChapter['title'],
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.mulish(
                                                  fontSize: font16,
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
                                                        BorderRadius.circular(
                                                            20),
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
                                                    width: widthScreen * 0.025),
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
                                                  image: AssetImage(
                                                      boolCheck ?'assets/img/TrueCheck.png' : 'assets/img/FalseCheck.png'))),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList());
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