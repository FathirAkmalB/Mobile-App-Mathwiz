import 'dart:convert';

import 'package:consume_api/UI/article_page/article_screens.dart';
import 'package:consume_api/UI/exam_page/result_exam.dart';
import 'package:consume_api/UI/exercise_page/exercise_list.dart';
import 'package:consume_api/UI/exercise_page/exercise_screens.dart';
import 'package:consume_api/UI/modules/sub_chapter_screens.dart';
import 'package:consume_api/methods/api.dart';
import 'package:flutter/material.dart';
import 'package:consume_api/data/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreens extends StatefulWidget {
  const HistoryScreens({super.key});

  @override
  State<HistoryScreens> createState() => _HistoryScreensState();
}

class _HistoryScreensState extends State<HistoryScreens> {
  Future? historyList;

  Future<void> _refreshData() async {
    setState(() {
      historyList = fetchHistory();
    });
  }

  String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    final DateFormat formatter = DateFormat('d/M/y, HH:mm');
    String formattedDate = formatter.format(dateTime);

    // Ubah timezone ke WIB (Waktu Indonesia Barat)
    formattedDate += ' WIB';
    return formattedDate;
  }

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  var currentIndex = 0;

  List<dynamic> dataHistory = []; // Isi dengan data yang Anda terima dari API

  List dataHistoryExam = [];
  List dataHistoryExercise = [];
  List dataHistoryArticle = [];
  List dataHistorySubChapter = [];

  dynamic studentID;

  Future<void> fetchHistory() async {
    final preference = await SharedPreferences.getInstance();
    final studentId = preference.getInt('student_id');
    final response = await API().getRequest(route: '/getHistory/$studentId');
    print('${response.statusCode}');

    if (response.statusCode == 200) {
      setState(() {
        dataHistory = jsonDecode(response.body);
        studentID = studentId;
        
        dataHistoryExam.clear();
        dataHistoryArticle.clear();
        dataHistorySubChapter.clear();
        dataHistoryExercise.clear();


        for (var data in dataHistory) {
          if (data['type'] == 'exam') {
            dataHistoryExam.clear();
            dataHistoryExam.add(data);
          } else if (data['type'] == 'exercise') {
            dataHistoryExercise.add(data);
          } else if (data['type'] == 'article') {
            dataHistoryArticle.add(data);
          } else if (data['type'] == 'subChapter') {
            dataHistorySubChapter.add(data);
          }
        }
      });
    } else {
      print('Fail');
      throw Exception('Failed to load history');
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    double font12 = widthScreen * 0.035;
    double font14 = widthScreen * 0.043;
    double font16 = widthScreen * 0.045;
    double font22 = widthScreen * 0.055;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SafeArea(
            child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/img/bg-blueCircle.png'),
                  fit: BoxFit.cover),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: widthScreen * 0.8,
                  padding: EdgeInsets.only(top: widthScreen * 0.1),
                  margin: EdgeInsets.symmetric(horizontal: widthScreen * 0.08),
                  child: Text(
                    'Riwayat Aktifitas',
                    style: GoogleFonts.mulish(
                        fontSize: font22,
                        fontWeight: textExtra,
                        color: whiteText),
                  ),
                ),
                SizedBox(height: widthScreen * 0.02),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: widthScreen * 0.08),
                  child: Text(
                    'Semester Ganjil',
                    style: GoogleFonts.mulish(
                        fontSize: font16,
                        fontWeight: textMedium,
                        color: whiteText),
                  ),
                ),
                SizedBox(height: heightScreen * 0.05),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: widthScreen * 0.04),
                  width: widthScreen,
                  height: heightScreen,
                  decoration: BoxDecoration(
                      color: whiteText,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(widthScreen * 0.08),
                          topRight: Radius.circular(widthScreen * 0.08))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          currentIndex == 0
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      currentIndex = 0;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        top: widthScreen * 0.06),
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 4),
                                    height: widthScreen * 0.08,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        border: Border.all(
                                            width: 1.5, color: greenSolid)),
                                    child: Text(
                                      'Ujian',
                                      style: GoogleFonts.mulish(
                                          color: greenSolid,
                                          fontSize: font12,
                                          fontWeight: textBold),
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      currentIndex = 0;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        top: widthScreen * 0.06),
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 4),
                                    height: widthScreen * 0.08,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        // border: Border.all(width: 1.5, color: inputLogin)
                                        color: inputLogin),
                                    child: Text(
                                      'Ujian',
                                      style: GoogleFonts.mulish(
                                          color: placeHolder,
                                          fontSize: font12,
                                          fontWeight: textBold),
                                    ),
                                  ),
                                ),
                          SizedBox(width: widthScreen * 0.02),
                          currentIndex == 1
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      currentIndex = 1;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        top: widthScreen * 0.06),
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 4),
                                    height: widthScreen * 0.08,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        border: Border.all(
                                            width: 1.5, color: greenSolid)),
                                    child: Text(
                                      'Latihan',
                                      style: GoogleFonts.mulish(
                                          color: greenSolid,
                                          fontSize: font12,
                                          fontWeight: textBold),
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      currentIndex = 1;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        top: widthScreen * 0.06),
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 4),
                                    height: widthScreen * 0.08,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        color: inputLogin),
                                    child: Text(
                                      'Latihan',
                                      style: GoogleFonts.mulish(
                                          color: placeHolder,
                                          fontSize: font12,
                                          fontWeight: textBold),
                                    ),
                                  ),
                                ),
                          SizedBox(width: widthScreen * 0.02),
                          currentIndex == 2
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      currentIndex = 2;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        top: widthScreen * 0.06),
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 4),
                                    height: widthScreen * 0.08,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        border: Border.all(
                                            width: 1.5, color: greenSolid)),
                                    child: Text(
                                      'Artikel',
                                      style: GoogleFonts.mulish(
                                          color: greenSolid,
                                          fontSize: font12,
                                          fontWeight: textBold),
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      currentIndex = 2;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        top: widthScreen * 0.06),
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 4),
                                    height: widthScreen * 0.08,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        // border: Border.all(width: 1.5, color: inputLogin)
                                        color: inputLogin),
                                    child: Text(
                                      'Artikel',
                                      style: GoogleFonts.mulish(
                                          color: placeHolder,
                                          fontSize: font12,
                                          fontWeight: textBold),
                                    ),
                                  ),
                                ),
                          SizedBox(width: widthScreen * 0.02),
                          currentIndex == 3
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      currentIndex = 3;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        top: widthScreen * 0.06),
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 4),
                                    height: widthScreen * 0.08,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        border: Border.all(
                                            width: 1.5, color: greenSolid)),
                                    child: Text(
                                      'Materi',
                                      style: GoogleFonts.mulish(
                                          color: greenSolid,
                                          fontSize: font12,
                                          fontWeight: textBold),
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      currentIndex = 3;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        top: widthScreen * 0.06),
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 4),
                                    height: widthScreen * 0.08,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        color: inputLogin),
                                    child: Text(
                                      'Materi',
                                      style: GoogleFonts.mulish(
                                          color: placeHolder,
                                          fontSize: font12,
                                          fontWeight: textBold),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      SizedBox(
                        height: widthScreen * 0.06,
                      ),
                      Text(
                        'Daftar Riwayat',
                        style: GoogleFonts.mulish(
                          fontSize: font16,
                          fontWeight: textBold,
                        ),
                      ),
                      SizedBox(
                        height: widthScreen * 0.04,
                      ),
                      Expanded(
                          child: Container(
                              padding:
                                  EdgeInsets.only(bottom: widthScreen * 0.2),
                              alignment: Alignment.center,
                              child: currentIndex == 0 && dataHistoryExam.isNotEmpty
                                  ? // exam view
                                  ListView.builder(
                                      itemCount: dataHistoryExam.length,
                                      itemBuilder: (context, index) {
                                        final dataIndex =
                                            dataHistoryExam[index];
                                        final titleExam =
                                            dataIndex['exam_title'];
                                        final durationExam =
                                            dataIndex['exam_duration'];
                                        final completedAt =
                                            dataIndex['completed_at'];
                                        String formattedDateTime =
                                            formatDateTime(completedAt);

                                        final examID = dataIndex['exam_id'];

                                        return GestureDetector(
                                          child: Container(
                                            width: widthScreen * 0.9,
                                            margin: const EdgeInsets.only(
                                                bottom: 20),
                                            height: widthScreen * 0.3,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 18),
                                            decoration: BoxDecoration(
                                              color: searchBar,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  alignment: Alignment.center,
                                                  width: widthScreen * 0.14,
                                                  height: widthScreen * 0.14,
                                                  decoration:
                                                      const BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/img/UjianIcon.png'),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: widthScreen * 0.02,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            width: widthScreen *
                                                                0.44,
                                                            child: Text(
                                                              '$titleExam',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: GoogleFonts
                                                                  .mulish(
                                                                fontWeight:
                                                                    textExtra,
                                                                fontSize:
                                                                    font12,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            '$durationExam Menit',
                                                            style: GoogleFonts
                                                                .mulish(
                                                              fontWeight:
                                                                  textBold,
                                                              fontSize: font12,
                                                              color: redSolid,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        formattedDateTime,
                                                        style:
                                                            GoogleFonts.mulish(
                                                          fontWeight:
                                                              textMedium,
                                                          fontSize: font12,
                                                        ),
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) =>
                                                                    ResultExam(
                                                                        examID:
                                                                            examID,
                                                                        studentId:
                                                                            studentID),
                                                              ),
                                                            );
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                width: 35,
                                                                height: 35,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  horizontal: 6,
                                                                  vertical: 8,
                                                                ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      greenSolid,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                ),
                                                                child: Center(
                                                                  child: Icon(
                                                                    Icons
                                                                        .remove_red_eye,
                                                                    color:
                                                                        whiteText,
                                                                    size: 20,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width:
                                                                      widthScreen *
                                                                          0.025),
                                                              Text(
                                                                'Lihat Hasil',
                                                                style:
                                                                    GoogleFonts
                                                                        .mulish(
                                                                  fontSize:
                                                                      font12,
                                                                  color:
                                                                      greenSolid,
                                                                  fontWeight:
                                                                      textBold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : currentIndex == 0 && dataHistoryExam.isEmpty
                                      ? Center(
                                          child: Column(
                                          children: [
                                            Container(
                                              width: widthScreen * 0.6,
                                              height: widthScreen * 0.6,
                                              decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/statuscode/NoData-1.png'))),
                                            ),
                                            Text(
                                              'Kamu belum memiliki riwayat apapun',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.mulish(
                                                  fontWeight: textMedium,
                                                  fontSize: font14,
                                                  color: subTitle),
                                            )
                                          ],
                                        ))
                                      : currentIndex == 1 &&
                                              dataHistoryExercise.isNotEmpty
                                          ? ListView.builder(
                                              itemCount:
                                                  dataHistoryExercise.length,
                                              itemBuilder: (context, index) {
                                                final indexData =
                                                    dataHistoryExercise[index];
                                                final titleExercise =
                                                    indexData['exercise_title'];
                                                final exerciseSubChapter =
                                                    indexData[
                                                        'exercise_sub_chapter'];
                                                final exerciseId =
                                                    indexData['exercise_id']
                                                        .toString();
                                                final completedAt =
                                                    indexData['completed_at'];
                                                String formattedDateTime =
                                                    formatDateTime(completedAt);

                                                final accuracy =
                                                    indexData['accuracy'];

                                                return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ExerciseScreens(
                                                                  exerciseId:
                                                                      exerciseId,
                                                                  studentId:
                                                                      studentID),
                                                        ));
                                                  },
                                                  child: Container(
                                                    height: widthScreen * 0.28,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16,
                                                        vertical: 20),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 20),
                                                    decoration: BoxDecoration(
                                                      color: searchBar,
                                                      border: Border.all(
                                                          width: 2,
                                                          color: searchBar),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: widthScreen *
                                                              0.14,
                                                          height: widthScreen *
                                                              0.14,
                                                          decoration:
                                                              const BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                              image: AssetImage(
                                                                  'assets/img/circleExercise.png'),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: widthScreen *
                                                              0.05,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              '$titleExercise',
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: GoogleFonts
                                                                  .mulish(
                                                                color:
                                                                    blackText,
                                                                fontWeight:
                                                                    textBold,
                                                                fontSize:
                                                                    font12,
                                                              ),
                                                            ),
                                                            Container(
                                                              width:
                                                                  widthScreen *
                                                                      0.5,
                                                              child: Text(
                                                                '$exerciseSubChapter',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    GoogleFonts
                                                                        .mulish(
                                                                  fontSize:
                                                                      font12,
                                                                  fontWeight:
                                                                      textMedium,
                                                                  color:
                                                                      subTitle,
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              width:
                                                                  widthScreen *
                                                                      0.62,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                      width:
                                                                          widthScreen *
                                                                              0.4,
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .symmetric(
                                                                        vertical:
                                                                            4,
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        formattedDateTime,
                                                                        style: GoogleFonts
                                                                            .mulish(
                                                                          color:
                                                                              blackText,
                                                                          fontSize:
                                                                              font12,
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      )),
                                                                  Container(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .symmetric(
                                                                        horizontal:
                                                                            4,
                                                                        vertical:
                                                                            4,
                                                                      ),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color:
                                                                            placeHolder,
                                                                        borderRadius:
                                                                            BorderRadius.circular(4),
                                                                      ),
                                                                      child: Text(
                                                                          'Akurasi $accuracy',
                                                                          style:
                                                                              GoogleFonts.mulish(
                                                                            color:
                                                                                whiteText,
                                                                            fontSize:
                                                                                font12,
                                                                          ))),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            )
                                          : currentIndex == 1 &&
                                                  dataHistoryExercise.isEmpty
                                              ? Center(
                                                  child: Column(
                                                  children: [
                                                    Container(
                                                      width: widthScreen * 0.6,
                                                      height: widthScreen * 0.6,
                                                      decoration: const BoxDecoration(
                                                          image: DecorationImage(
                                                              image: AssetImage(
                                                                  'assets/statuscode/NoData-1.png'))),
                                                    ),
                                                    Text(
                                                      'Kamu belum memiliki riwayat apapun',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: GoogleFonts.mulish(
                                                          fontWeight:
                                                              textMedium,
                                                          fontSize: font14,
                                                          color: subTitle),
                                                    )
                                                  ],
                                                ))
                                              : currentIndex == 2 &&
                                                      dataHistoryArticle.isNotEmpty
                                                  ? ListView.builder(
                                                      itemCount:
                                                          dataHistoryArticle
                                                              .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        final indexData =
                                                            dataHistoryArticle[
                                                                index];
                                                        final articleId =
                                                            indexData[
                                                                'article_id'];
                                                        final titleArticle =
                                                            indexData[
                                                                'article_title'];
                                                        final subject =
                                                            indexData[
                                                                'subject'];
                                                        final author =
                                                            indexData['author'];
                                                        final completedAt =
                                                            indexData[
                                                                'completed_at'];
                                                        final formattedDateTime =
                                                            formatDateTime(
                                                                completedAt);
                                                        return GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) {
                                                              return Article_Screens(
                                                                  articleData:
                                                                      articleId);
                                                            }));
                                                          },
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        12),
                                                            padding: EdgeInsets.symmetric(
                                                                horizontal:
                                                                    widthScreen *
                                                                        0.05,
                                                                vertical:
                                                                    widthScreen *
                                                                        0.02),
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    searchBar,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            14)),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  width:
                                                                      widthScreen *
                                                                          0.14,
                                                                  height:
                                                                      widthScreen *
                                                                          0.14,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            40),
                                                                    image:
                                                                        const DecorationImage(
                                                                      image: AssetImage(
                                                                          'assets/img/ArticleIcon.png'),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width:
                                                                      widthScreen *
                                                                          0.02,
                                                                ),
                                                                Container(
                                                                  width:
                                                                      widthScreen *
                                                                          0.6,
                                                                  height:
                                                                      widthScreen *
                                                                          0.25,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      Text(
                                                                        '$titleArticle',
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: GoogleFonts
                                                                            .mulish(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              textBold,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        'Author: $author',
                                                                        // maxLines: 3,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        style: GoogleFonts
                                                                            .mulish(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              subTitle,
                                                                          fontWeight:
                                                                              textBold,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '$formattedDateTime',
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        style: GoogleFonts
                                                                            .mulish(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              subTitle,
                                                                          fontWeight:
                                                                              textMedium,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    )
                                                  : currentIndex == 2 &&
                                                          dataHistoryArticle.isEmpty
                                                      ? Center(
                                                          child: Column(
                                                          children: [
                                                            Container(
                                                              width:
                                                                  widthScreen *
                                                                      0.6,
                                                              height:
                                                                  widthScreen *
                                                                      0.6,
                                                              decoration: const BoxDecoration(
                                                                  image: DecorationImage(
                                                                      image: AssetImage(
                                                                          'assets/statuscode/NoData-1.png'))),
                                                            ),
                                                            Text(
                                                              'Kamu belum memiliki riwayat apapun',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts.mulish(
                                                                  fontWeight:
                                                                      textMedium,
                                                                  fontSize:
                                                                      font14,
                                                                  color:
                                                                      subTitle),
                                                            )
                                                          ],
                                                        ))
                                                      : currentIndex == 3 &&
                                                              dataHistorySubChapter.isNotEmpty
                                                          ? ListView.builder(
                                                              itemCount:
                                                                  dataHistorySubChapter
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                final indexData =
                                                                    dataHistorySubChapter[
                                                                        index];
                                                                final subChapterId =
                                                                    indexData[
                                                                        'subChapter_id'];
                                                                final titleSubChapter =
                                                                    indexData[
                                                                        'subChapter_title'];
                                                                final chapter =
                                                                    indexData[
                                                                        'chapter'];
                                                                final completedAt =
                                                                    indexData[
                                                                        'completed_at'];
                                                                String
                                                                    formattedDateTime =
                                                                    formatDateTime(
                                                                        completedAt);

                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(builder:
                                                                            (context) {
                                                                      return SubChapterScreen(
                                                                        studentId:
                                                                            studentID,
                                                                        subChapterId:
                                                                            subChapterId,
                                                                      );
                                                                    }));
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    margin: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            12),
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            widthScreen *
                                                                                0.05,
                                                                        vertical:
                                                                            widthScreen *
                                                                                0.01),
                                                                    decoration: BoxDecoration(
                                                                        color:
                                                                            searchBar,
                                                                        borderRadius:
                                                                            BorderRadius.circular(14)),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Container(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          width:
                                                                              widthScreen * 0.14,
                                                                          height:
                                                                              widthScreen * 0.14,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(40),
                                                                            image:
                                                                                const DecorationImage(
                                                                              image: AssetImage('assets/img/SubChapterIcon.png'),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              widthScreen * 0.02,
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              widthScreen * 0.6,
                                                                          height:
                                                                              widthScreen * 0.25,
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              Text(
                                                                                '$titleSubChapter',
                                                                                maxLines: 2,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: GoogleFonts.mulish(
                                                                                  fontSize: 14,
                                                                                  fontWeight: textBold,
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                'Bab: $chapter',
                                                                                // maxLines: 3,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                textAlign: TextAlign.left,
                                                                                style: GoogleFonts.mulish(
                                                                                  fontSize: 12,
                                                                                  color: subTitle,
                                                                                  fontWeight: textBold,
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                formattedDateTime,
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                textAlign: TextAlign.left,
                                                                                style: GoogleFonts.mulish(
                                                                                  fontSize: 12,
                                                                                  color: subTitle,
                                                                                  fontWeight: textMedium,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            )
                                                          : Center(
                                                              child: Column(
                                                              children: [
                                                                Container(
                                                                  width:
                                                                      widthScreen *
                                                                          0.6,
                                                                  height:
                                                                      widthScreen *
                                                                          0.6,
                                                                  decoration: const BoxDecoration(
                                                                      image: DecorationImage(
                                                                          image:
                                                                              AssetImage('assets/statuscode/NoData-1.png'))),
                                                                ),
                                                                Text(
                                                                  'Kamu belum memiliki riwayat apapun',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: GoogleFonts.mulish(
                                                                      fontWeight:
                                                                          textMedium,
                                                                      fontSize:
                                                                          font14,
                                                                      color:
                                                                          subTitle),
                                                                )
                                                              ],
                                                            ))))
                    ],
                  ),
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}
