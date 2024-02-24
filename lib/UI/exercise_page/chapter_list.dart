
import 'package:consume_api/UI/modules/subject_list.dart';
import 'package:consume_api/UI/exercise_page/subject_list.dart';
import 'package:consume_api/UI/remedial_page/subject_list.dart';
import 'package:flutter/material.dart';
import 'package:consume_api/methods/api.dart';
import 'package:consume_api/data/data.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../SideBar/Drawer.dart';
import 'package:consume_api/layout/mainlayout.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'dart:convert';
import 'dart:core';


import 'package:consume_api/UI/exercise_page/sub_chapter_list.dart';

class ListChapterExercise extends StatefulWidget {
  final studentId;
  final subjectExam;
  const ListChapterExercise({super.key, required this.subjectExam, required this.studentId});

  @override
  State<ListChapterExercise> createState() => ListChapterExerciseState();
}

class ListChapterExerciseState extends State<ListChapterExercise> {
  Future<Map<String, dynamic>> getDataBySubject(int subjectId, int studentId) async { // For Fetch Data Chapter(Bab)

    final response = await API().getRequest(route: '/getDataBySubject/$subjectId/$studentId');

    try {
      if(response.statusCode == 200){
        print('Successfully get data by subject');
        final data = jsonDecode(response.body);
          String subject = data['subject'];
          int totalChapters = data['total_chapters'];
          int totalExercisesBySubject = data['total_exercises_by_subject'];
          List<dynamic> dataChapters = data['dataChapters'];
        return {
          'subject': subject,
          'totalChapters': totalChapters,
          'totalExercisesBySubject': totalExercisesBySubject,
          'dataChapters': dataChapters
        };
      }else{
        throw Exception('check your connection');
      }
    } catch (e) {
      throw Exception('Gagal mendapatkan API ${response.statusCode} $e');
    }

  }


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
    double font14 = widthScreen * 0.038;
    double font16 = widthScreen * 0.043;
    double font18 = widthScreen * 0.048;

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/img/bg-blueCircle.png'),
                fit: BoxFit.cover),
          ),
          child: Column(
            children: [
            FutureBuilder(
                future: getDataBySubject(widget.subjectExam['id'], widget.studentId), 
                builder: (context, snapshot){
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
                              fontWeight: textExtra, fontSize: widthScreen * 0.055),
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
                          'Daftar Bab',
                          style: GoogleFonts.mulish(
                              fontWeight: textExtra, fontSize: widthScreen * 0.055),
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
                  }else if (snapshot.hasData){
                    final data = snapshot.data;
                    final subject = data!['subject'];
                    return AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      toolbarHeight: heightScreen * 0.1,
                      title: Container(
                        alignment: Alignment.center,
                        child: Text(
                          '$subject - Latihan',
                          style: GoogleFonts.mulish(
                              fontWeight: textExtra, fontSize: widthScreen * 0.055),
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
                          'Daftar Bab',
                          style: GoogleFonts.mulish(
                              fontWeight: textExtra, fontSize: widthScreen * 0.055),
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
                }
              ),
            SizedBox(
              height: widthScreen * 0.04,
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.symmetric(horizontal: widthScreen * 0.06),
              // width: widthScreen,
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
                    future: getDataBySubject(widget.subjectExam['id'], widget.studentId), 
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Daftar Bab',
                             style: GoogleFonts.mulish(
                                fontSize: font18,
                                fontWeight: textBold,
                                color: blackText),
                            ),
                            Text(
                              '(0 Bab)',
                              style: GoogleFonts.mulish(
                                  fontWeight: textBold, color: greenSolid),
                            ),
                          ],
                        );
                      }else if(snapshot.hasError){
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Daftar Bab',
                              style: GoogleFonts.mulish(
                                        fontSize: font16,
                                        fontWeight: textMedium,
                                        color: Colors.black),
                            ),
                            Text(
                              '(0 Bab)',
                              style: GoogleFonts.mulish(
                                  fontWeight: textBold, color: greenSolid),
                            ),
                          ],
                        );
                      }else if (snapshot.hasData){
                        final data = snapshot.data;
                        final totalChapters = data!['totalChapters'];
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Daftar Bab',
                               style: GoogleFonts.mulish(
                                fontSize: font18,
                                fontWeight: textBold,
                                color: blackText),
                            ),
                            Text(
                              '($totalChapters Bab)',
                              style: GoogleFonts.mulish(
                                  fontWeight: textBold, color: greenSolid),
                            ),
                          ],
                        );
                      }else{
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Daftar Bab',
                              style: GoogleFonts.mulish(
                                        fontSize: font16,
                                        fontWeight: textMedium,
                                        color: Colors.black),
                            ),
                            Text(
                              '(0 Bab)',
                              style: GoogleFonts.mulish(
                                  fontWeight: textBold, color: greenSolid),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: heightScreen * 0.02,
                  ),
                  Expanded(
                    child: FutureBuilder(
                        future: getDataBySubject(widget.subjectExam['id'], widget.studentId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            print(snapshot.error);
                            return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(bottom: 14),
                                        child: Text('Terjadi masalah..', style: GoogleFonts.mulish(fontSize: font14, color: placeHolder,fontWeight: textBold),),
                                      ),
                                      ElevatedButton(
                                        onPressed: (){
                                          _refreshData();
                                        }, 
                                        style: ElevatedButton.styleFrom(
                                          primary: subTitle,
                                          foregroundColor: greenSolid,
                                        ),
                                        child: Text('Refresh', style: GoogleFonts.mulish(fontWeight: textBold,fontSize: font14, color: whiteText))
                                      )
                                    ],
                                  ) ,
                                );
                          } else if (snapshot.hasData) {
                              final responseData = snapshot.data!;
                              final dataChapters = responseData['dataChapters'];
                            return ListView.builder(
                              itemCount: dataChapters.length,
                              itemBuilder: (context, index) {
                                final chapter = dataChapters[index];
                                final totalExerciseByChapter = chapter['total_exercises_by_chapter'];
                                final totalExerciseByAttempted = chapter['total_attempted_exercises_by_chapter'];
                                final totalSubChapters = chapter['total_sub_chapters'];
                                double decimal = (totalExerciseByAttempted/totalExerciseByChapter);
                                double toPercent = decimal * 100;
                                String percent = toPercent.toStringAsFixed(0);
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  height: widthScreen * 0.4,
                                  padding: const EdgeInsets.only(left: 12),
                                  decoration: BoxDecoration(
                                    color: totalExerciseByAttempted != totalExerciseByChapter ? yellowText : totalExerciseByChapter == 0 ? yellowText : totalExerciseByAttempted == totalExerciseByChapter ? blueText : yellowText,
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
                                        SizedBox(
                                          width: widthScreen * 0.55,
                                          child: Text(
                                              chapter['title'],
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.mulish(
                                                fontWeight: textExtra,
                                                fontSize: font14,
                                              ),
                                          ),
                                        ),
                                        Text(
                                          '$totalSubChapters Sub Bab',
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
                                              percent: decimal.isNaN ? 0 : decimal,
                                              progressColor: totalExerciseByAttempted != totalExerciseByChapter ? yellowText : totalExerciseByChapter == 0 ? yellowText : totalExerciseByAttempted == totalExerciseByChapter ? blueText : yellowText,
                                              backgroundColor: progressBar,
                                            ),
                                            SizedBox(width: widthScreen * 0.02),
                                            Text(decimal.isNaN ? '0%' : '$percent%')
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
                                                      ListSubChapter(
                                                        studentId: widget.studentId,
                                                    chapter: chapter, // Pass the subjectData as an argument
                                                  ),
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
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
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
  Future? exerciseList;

  Future<void> _refreshData() async{
    setState(() {
     exerciseList = getDataBySubject(widget.subjectExam['id'], widget.studentId);
    });
  }
}
