import 'package:consume_api/SideBar/Drawer.dart';
import 'package:consume_api/UI/exercise_page/exercise_screens.dart';
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

import 'package:shared_preferences/shared_preferences.dart';

class ExerciseList extends StatefulWidget {
  final studentId;
  final subChapterId;
  const ExerciseList({super.key, this.subChapterId, required this.studentId});

  @override
  State<ExerciseList> createState() => _ExerciseListState();
}

@override
class _ExerciseListState extends State<ExerciseList> {
  @override
  void initState() {
    super.initState();
    getTitle();
  }

  String? subject;

  Future<void> getTitle() async{
    final response = await API().getRequest(route: '/getDataBySubChapter/${widget.subChapterId}/${widget.studentId}');
    final data = jsonDecode(response.body);
    setState(() {
      subject = data['subject'];
    });
  }

  

  Future<Map<String, dynamic>> getDataBySubChapter(String subChapterId, int studentId) async {
    final response = await API().getRequest(route: '/getDataBySubChapter/$subChapterId/$studentId');
    try {
      if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      Map<String, dynamic> data = jsonData;
      final chapter = data['chapter'];
      final subChapter = data['sub_chapter'];
      final totalExerciseBySubChapter = data['total_exercises_by_sub_chapter'];
      final totalAttemptedBySubChapter = data['total_attempted_exercises_by_sub_chapter'];
      List<dynamic> dataExercise = data['dataExercise'];
      
      dataExercise.forEach((exercise) {
        print('Exercise ID: ${exercise['id']}');
        print('Has Attempt: ${exercise['has_attempt']}');
      });
      return {
        'subject': subject,
        'chapter': chapter,
        'subChapter': subChapter,
        'totalExerciseBySubChapter': totalExerciseBySubChapter,
        'totalAttemptedBySubChapter': totalAttemptedBySubChapter,
        'dataExercise': dataExercise
      };
    } else {
      print('${response.statusCode}');
      throw Exception('Failed to fetch data'); // Throw an exception in case of an error
    }
    } catch (e) {
   throw Exception(e);   
    }
  }
  
  Future? ExerciseList;


  Future<void> _refreshData() async{
    setState(() {
     ExerciseList = getDataBySubChapter(widget.subChapterId.toString(), widget.studentId);
    });
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
    double font12 = widthScreen * 0.035;
    double font16 = widthScreen * 0.043;
    double font22 = widthScreen * 0.055;
    double font14 = widthScreen * 0.038;

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
              AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      toolbarHeight: heightScreen * 0.1,
                      title: Container(
                        alignment: Alignment.center,
                        child: Text(
                          '$subject - Latihan',
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
                    ),
              SizedBox(
                height: widthScreen * 0.02,
              ),
              FutureBuilder(
                future: getDataBySubChapter(widget.subChapterId.toString(), widget.studentId),
                builder: ((context, snapshot) {
                  if( snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator(color: greenSolid,),);
                  }else if(snapshot.hasError){
                    return Center(child: Text('Please Refresh this page'),);
                  }else if(snapshot.hasData){
                    final data = snapshot.data as Map<String, dynamic>;
                    final subChapter = data['subChapter'];
                    final totalExercise = data['totalExerciseBySubChapter'];
                    final totalAttempt = data['totalAttemptedBySubChapter'];
                    double decimal = (totalAttempt / totalExercise);
                    double percentase = decimal * 100;
                    String percent = percentase.toStringAsFixed(0);

                    return Container(
                        width: widthScreen * 0.85,
                        height: widthScreen * 0.3,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                                text: '$subChapter',
                                style: GoogleFonts.mulish(
                                  fontSize: font16,
                                  fontWeight: textExtra,
                                  color: blackText,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                LinearPercentIndicator(
                                  width: widthScreen * 0.6,
                                  lineHeight: 12,
                                  percent:  decimal.isNaN ? 0 : decimal, 
                                  progressColor: totalAttempt != totalExercise ? yellowText : totalAttempt == 0 ? yellowText : totalExercise == totalExercise ? blueText : yellowText,
                                  backgroundColor: progressBar,
                                ),
                                Text(
                                  decimal.isNaN ? '0%' :'${percent}%',
                                  style: GoogleFonts.mulish(
                                    fontWeight: textBold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Dalam Proses Pelatihan ($totalExercise Soal)',
                              style: GoogleFonts.mulish(
                                fontWeight: textBold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                  }else{
                    throw Exception('Error Please Check Your Connection');
                  }
                })
                ),
              SizedBox(
                height: heightScreen * 0.02,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: widthScreen * 0.08),
                  decoration: BoxDecoration(
                    color: whiteText,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: FutureBuilder(
                    future: getDataBySubChapter(widget.subChapterId.toString(), widget.studentId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text('Error : ${snapshot.error.toString()}'));
                      } else if (snapshot.hasData) {
                        final data = snapshot.data as Map<String, dynamic>;
                        if (data['totalExerciseBySubChapter'] == 0) {
                          return Center(
                            child: Column(
                              children: [
                                Container(
                                  width: widthScreen * 0.6,
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/statuscode/NoData-1.png'))),
                                ),
                              ],
                            ),
                          );
                        } else {
                          final dataExercise = data['dataExercise'];
                          return ListView.builder(
                            itemCount: dataExercise.length,
                            itemBuilder: (context, index) {
                              var exercise = dataExercise[index];
                              var has_attempt = dataExercise[index]['has_attempt'];
                              return GestureDetector(
                                onTap: has_attempt == false ? (){
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(exercise['title_exercise'], style: GoogleFonts.mulish(
                                          color: greenSolid,
                                          fontWeight: textBold,
                                          fontSize: font22
                                        ),),
                                        content: const Text('Kerjakan Soal Sekarang?'), titleTextStyle: GoogleFonts.mulish(
                                          color: subTitle,
                                          fontWeight: textMedium,
                                          fontSize: font12
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Batal', style: GoogleFonts.mulish(
                                              color: subTitle,
                                              fontWeight: FontWeight.bold
                                            ),),
                                          ),
                                          TextButton(
                                            onPressed: () async{
                                              SharedPreferences pref = await SharedPreferences.getInstance() ;
                                              String studentId = pref.getInt('student_id').toString();
                                              String exerciseId = exercise['id'].toString();
                                              Navigator.of(context).pop();
                                              // ignore: use_build_context_synchronously
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ExerciseScreens(
                                                     studentId: studentId, exerciseId: exerciseId,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                              color: greenSolid,
                                              borderRadius: BorderRadius.circular(6)
                                              ),
                                              child:  Text('Mulai', style: GoogleFonts.mulish(
                                              color: whiteText,
                                              fontWeight: FontWeight.bold
                                            ),),
                                            )
                                          )
                                        ],
                                      );
                                    },
                                  );
                                    }
                                    :() async{
                                         SharedPreferences pref = await SharedPreferences.getInstance() ;
                                          String studentId = pref.get('student_id').toString();
                                          String exerciseId = exercise['id'].toString();
                                          // ignore: use_build_context_synchronously
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ExerciseScreens(
                                                  studentId: studentId, exerciseId: exerciseId,
                                                ),
                                              ),
                                            );
                                       },
                                    
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  height: widthScreen * 0.22,
                                  padding: const EdgeInsets.only(left: 14),
                                  decoration: BoxDecoration(
                                    color: has_attempt ? blueText : yellowText,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                      ),
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
                                            SizedBox(
                                              width: widthScreen * 0.5,
                                              child: Text(
                                                exercise['title_exercise'],
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.mulish(
                                                  fontSize: 16,
                                                  fontWeight: textBold,
                                                  color: blackText,
                                                ),
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
                                                  width: widthScreen * 0.025,
                                                ),
                                                Text(
                                                  has_attempt ? 'Pelajari kembali' : 'Mulai Latihan',
                                                  style: GoogleFonts.mulish(
                                                    fontSize: 14,
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
                                              image: has_attempt
                                              ? 
                                              const AssetImage('assets/img/TrueCheck.png')
                                                  : 
                                                  const AssetImage('assets/img/FalseCheck.png')
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      } else {
                        throw Exception('Gagal Mengambil API subChapter');
                      }
                    },
                  ),
                ),
              ),
            ]),
          ),
        endDrawer: CommonDrawer(
          currentIndex: _currentIndex,
          onItemSelected: _onItemSelected,
        ),
        );
  }
  
}
