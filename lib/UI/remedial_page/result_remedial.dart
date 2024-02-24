import 'dart:convert';

import 'package:consume_api/UI/exam_page/subject_list.dart';
import 'package:consume_api/UI/remedial_page/subject_list.dart';
import 'package:consume_api/data/data.dart';
import 'package:consume_api/methods/api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultRemedial extends StatefulWidget {
  final examID;
  final studentId;
  const ResultRemedial({super.key, required this.studentId, this.examID});

  @override
  State<ResultRemedial> createState() => _ResultRemedialState();
}

class _ResultRemedialState extends State<ResultRemedial> {
  initState() {
    super.initState();
    checkAttempt();
  }

  String? nameStudent;
  String remedialTitle = '';
  List dataQuestions = [];
  int totalQuestions = 0;
  int totalPoints = 0;
  int totalCorrect = 0;

  Future<Map> checkAttempt() async {
    final response = await API().getRequest(
        route:
            '/checkAttemptForRemedial/${widget.examID}/${widget.studentId}');
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? name = pref.getString('first_name');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        remedialTitle = data['remedial_title'];
        totalPoints = data['total_points'];
        totalQuestions = data['total_questions'];
        totalCorrect = data['total_corrects'];
        dataQuestions = data['dataQuestions'];
        nameStudent = name;
      });

      return {
        'totalQuestions': totalQuestions,
        'dataQuestions': dataQuestions,
      };
    } else {
      throw Exception('Gagal mengambil data dari API Chapter');
    }
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    double font12 = widthScreen * 0.035;
    double font14 = widthScreen * 0.038;
    double font16 = widthScreen * 0.043;
    double font22 = widthScreen * 0.055;

    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            body: SafeArea(
                child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/img/hasilExam.png'),
                          fit: BoxFit.cover),
                    ),
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
                                'Hasil Remedial',
                                style: GoogleFonts.mulish(
                                    fontWeight: textExtra,
                                    fontSize: widthScreen * 0.055),
                              ),
                            ),
                            leading: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.keyboard_arrow_left_rounded,
                                color: Colors.transparent,
                              ),
                            ),
                            actions: [
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.notifications_active,
                                    color: Colors.transparent,
                                  ))
                            ],
                          ),

                          SizedBox(height: widthScreen * 0.05),

                          // Tab Buttons Start
                          Container(
                              width: widthScreen * 0.85,
                              height: widthScreen * 0.13,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(90),
                                  color: const Color(0xFF0791BD)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedIndex = 0;
                                        print('selected: $_selectedIndex');
                                      });
                                    },
                                    child: _selectedIndex == 0
                                        ? Container(
                                            width: widthScreen * 0.4,
                                            height: widthScreen * 0.1,
                                            decoration: BoxDecoration(
                                              color: blueText,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Status',
                                                style: GoogleFonts.mulish(
                                                    fontSize: font14,
                                                    fontWeight: textBold,
                                                    color: whiteText),
                                              ),
                                            ))
                                        : Container(
                                            width: widthScreen * 0.4,
                                            height: widthScreen * 0.1,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF0791BD),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Status',
                                                style: GoogleFonts.mulish(
                                                    fontSize: font14,
                                                    fontWeight: textBold,
                                                    color: whiteText),
                                              ),
                                            )),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedIndex = 1;
                                        print('selected: $_selectedIndex');
                                      });
                                    },
                                    child: _selectedIndex == 0
                                        ? Container(
                                            width: widthScreen * 0.4,
                                            height: widthScreen * 0.1,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Hasil',
                                                style: GoogleFonts.mulish(
                                                    fontSize: font14,
                                                    fontWeight: textBold,
                                                    color: whiteText),
                                              ),
                                            ))
                                        : Container(
                                            width: widthScreen * 0.4,
                                            height: widthScreen * 0.1,
                                            decoration: BoxDecoration(
                                              color: blueText,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Hasil',
                                                style: GoogleFonts.mulish(
                                                    fontSize: font14,
                                                    fontWeight: textBold,
                                                    color: whiteText),
                                              ),
                                            )),
                                  ),
                                ],
                              )),
                          // Tab Buttons End

                          SizedBox(
                            height: widthScreen * 0.15,
                          ),

                          _selectedIndex == 0
                              ? Container(
                                  width: widthScreen * 0.8,
                                  height: heightScreen * 0.45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(35),
                                    image: const DecorationImage(
                                        image: AssetImage(
                                            'assets/img/bgPiala.png'),
                                        fit: BoxFit.cover),
                                    color: whiteText,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: widthScreen * 0.3,
                                      ),
                                      Text(
                                        'Selamat $nameStudent',
                                        style: GoogleFonts.mulish(
                                          fontSize: font22,
                                          color: greenSolid,
                                          fontWeight: textExtra,
                                        ),
                                      ),
                                      SizedBox(
                                        height: widthScreen * 0.02,
                                      ),
                                      Text(
                                        'Anda telah menyelesaikan Remedial:',
                                        style: GoogleFonts.mulish(
                                          fontWeight: textBold,
                                          fontSize: font12,
                                          color: subTitle,
                                        ),
                                      ),
                                      SizedBox(
                                        height: widthScreen * 0.02,
                                      ),
                                      Text(
                                        '“$remedialTitle”',
                                        style: GoogleFonts.mulish(
                                            color: darkBlue,
                                            fontWeight: textBold,
                                            fontSize: font16),
                                      ),
                                      SizedBox(
                                        height: widthScreen * 0.025,
                                      ),
                                      Text('Dengan perolehan:',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.mulish(
                                            fontSize: font12,
                                            fontWeight: textMedium,
                                            color: subTitle,
                                          )),
                                      SizedBox(
                                        height: widthScreen * 0.025,
                                      ),
                                      Text(
                                        '$totalCorrect/$totalQuestions',
                                        style: GoogleFonts.mulish(
                                          fontWeight: textExtra,
                                          fontSize: font22,
                                          color: goldText,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  width: widthScreen * 0.8,
                                  height: heightScreen * 0.45,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 30),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(35),
                                    image: const DecorationImage(
                                        image:
                                            AssetImage('assets/img/splash.png'),
                                        fit: BoxFit.cover),
                                    color: whiteText,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Kamu mendapatkan:',
                                        style: GoogleFonts.mulish(
                                          color: examResult,
                                          fontSize: font16,
                                          fontWeight: textBold,
                                        ),
                                      ),
                                      Text(
                                        '$totalPoints',
                                        style: GoogleFonts.mulish(
                                          color: totalPoints > 70
                                              ? yellowText
                                              : totalPoints > 80
                                                  ? greenSolid
                                                  : totalPoints > 90
                                                      ? blueText
                                                      : redSolid,
                                          fontSize: font22 * 4,
                                          fontWeight: textBold,
                                        ),
                                      ),
                                      Text(
                                        'Point',
                                        style: GoogleFonts.mulish(
                                          color: blackText,
                                          fontSize: font22,
                                          fontWeight: textBold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: widthScreen * 0.05,
                                      ),
                                      Text(
                                        'dengan Akurasi:',
                                        style: GoogleFonts.mulish(
                                          color: examResult,
                                          fontSize: font16,
                                          fontWeight: textBold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: widthScreen * 0.02,
                                      ),
                                      Text(
                                        '$totalCorrect/$totalQuestions',
                                        style: GoogleFonts.mulish(
                                          color: yellowText,
                                          fontSize: widthScreen * 0.085,
                                          fontWeight: textBold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: widthScreen * 0.02,
                                      ),
                                      Text(
                                        'Kamu menjawab soal dengan benar $totalCorrect dari $totalQuestions soal',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.mulish(
                                          color: blackText,
                                          fontSize: font14,
                                          fontWeight: textBold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          SizedBox(
                            height: widthScreen * 0.04,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SubjectRemedial(),
                                  ));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: widthScreen * 0.3,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 8),
                              decoration: BoxDecoration(
                                  color: greenSolid,
                                  borderRadius: BorderRadius.circular(6)),
                              child: Text(
                                'Kembali',
                                style: GoogleFonts.mulish(
                                    color: whiteText,
                                    fontWeight: textBold,
                                    fontSize: font14),
                              ),
                            ),
                          )
                        ])))));
  }
}
