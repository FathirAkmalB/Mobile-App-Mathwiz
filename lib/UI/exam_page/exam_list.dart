import 'package:consume_api/SideBar/Drawer.dart';
import 'package:consume_api/UI/modules/subject_list.dart';
import 'package:consume_api/UI/exercise_page/subject_list.dart';

import 'package:consume_api/UI/exam_page/exam_screens.dart';
import 'package:consume_api/UI/exam_page/result_exam.dart';
import 'package:consume_api/UI/remedial_page/subject_list.dart';
import 'package:consume_api/layout/mainlayout.dart';
import 'package:flutter/material.dart';
import 'package:consume_api/data/data.dart';
import 'package:consume_api/methods/api.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ListExamScreens extends StatefulWidget {
  final subjectExam;
  final studentId;
  const ListExamScreens(
      {super.key, this.subjectExam, this.studentId});

  @override
  State<ListExamScreens> createState() => _ListExamScreensState();
}

class _ListExamScreensState extends State<ListExamScreens> {
  int _currentIndex = 2;
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

  String _searchQuery = '';

  List<dynamic> filterData(List<dynamic> data, String query) {
    return data.where((item) {
      final title = item['title'];
      
      bool matchesQuery = title.toLowerCase().contains(query.toLowerCase());
      ;
      return matchesQuery;
    }).toList();
  }

  // Fetch List of Exam Data
  Future<Map> getExamBySubject({String? filter}) async {
    final response = await API().getRequest(
        route:
            '/getExamBySubject/${widget.subjectExam['id']}/${widget.studentId}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final totalExam = data['total_exam'];
      final totalExamHasAttempted = data['total_attempted_exam'];
      final dataExam = data['dataExam'];

      if (filter != null && filter.isNotEmpty) {
        final filteredData = filterData(dataExam, filter);
        final lengthData = filteredData.length;
        return {
          'totalExam': lengthData,
          'dataExam': filteredData,
          'totalExamHasAttempted': totalExamHasAttempted,
          'studentId': widget.studentId,
        };
      } else {
        return {
          'dataExam': dataExam,
          'totalExam': totalExam,
          'totalExamHasAttempted': totalExamHasAttempted,
        };
      }
    } else {
      throw Exception('Gagal mengambil data dari API Chapter');
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
              image: AssetImage('assets/img/bg-blueCircle.png'), fit: BoxFit.cover),
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
                  widget.subjectExam['title'],
                  style: GoogleFonts.mulish(
                      fontWeight: textExtra, fontSize: font22),
                ),
              ),
              // coming soon feature
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.keyboard_arrow_left_rounded),
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
            // search bar
            Container(
                width: widthScreen * 0.89,
                height: widthScreen * 0.14,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  color: searchBar,
                  borderRadius: BorderRadius.circular(widthScreen * 0.08),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: subTitle,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                            print(_searchQuery);
                            getExamBySubject(filter: _searchQuery);
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Search",
                          border: InputBorder.none,
                          hintStyle: GoogleFonts.mulish(color: subTitle),
                        ),
                      ),
                    ),
                  ],
                )),

            SizedBox(height: widthScreen * 0.1),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: widthScreen * 0.04),
                width: widthScreen,
                decoration: BoxDecoration(
                    color: whiteText,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(widthScreen * 0.08),
                        topRight: Radius.circular(widthScreen * 0.08))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: widthScreen * 0.06,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Daftar Ujian',
                          style: GoogleFonts.mulish(
                            fontSize: font18,
                            fontWeight: textBold,
                          ),
                        ),
                        FutureBuilder(
                          future:
                              _searchQuery != null && _searchQuery.isNotEmpty
                                  ? getExamBySubject(filter: _searchQuery)
                                  : getExamBySubject(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text(
                                '(0 Ujian)',
                                style: GoogleFonts.mulish(
                                    fontSize: font14,
                                    fontWeight: textBold,
                                    color: greenSolid),
                              );
                            } else if (snapshot.hasError) {
                              return Text(
                                '(0 Ujian)',
                                style: GoogleFonts.mulish(
                                    fontSize: font14,
                                    fontWeight: textBold,
                                    color: greenSolid),
                              );
                            } else if (snapshot.hasData) {
                              final totalExam = snapshot.data!['totalExam'];
                              return Text(
                                '($totalExam Ujian)',
                                style: GoogleFonts.mulish(
                                    fontSize: font14,
                                    fontWeight: textBold,
                                    color: greenSolid),
                              );
                            } else {
                              return Text(
                                '(0 Ujian)',
                                style: GoogleFonts.mulish(
                                    fontSize: font14,
                                    fontWeight: textBold,
                                    color: greenSolid),
                              );
                            }
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: widthScreen * 0.04,
                    ),
                    Expanded(
                      child: FutureBuilder(
                          future:
                              _searchQuery != null && _searchQuery.isNotEmpty
                                  ? getExamBySubject(filter: _searchQuery)
                                  : getExamBySubject(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: Text('Sedang memuat data...'),
                              );
                            } else if (snapshot.hasError) {
                              // print(snapshot);
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 14),
                                      child: Text(
                                        'Terjadi masalah..',
                                        style: GoogleFonts.mulish(
                                            fontSize: font14,
                                            color: placeHolder,
                                            fontWeight: textBold),
                                      ),
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          _refreshData();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: subTitle,
                                          foregroundColor: greenSolid,
                                        ),
                                        child: Text('Refresh',
                                            style: GoogleFonts.mulish(
                                                fontWeight: textBold,
                                                fontSize: font14,
                                                color: whiteText)))
                                  ],
                                ),
                              );
                            } else if (snapshot.hasData) {
                              final data = snapshot.data;
                              final examsData = data!['dataExam'];
                              final totalExam = data['totalExam'];


                              if (examsData.length > 0) {
                                return ListView.builder(
                                  itemCount: examsData.length,
                                  itemBuilder: (context, index) {
                                    var exam = examsData[index];
                                    var duration = exam['duration'];
                                    bool hasAttempt = exam['has_attempt'];
                          


                              double decimal = hasAttempt ? 1.0 : 0.0;
                              double percent = decimal * 100;
                              String result = percent.toStringAsFixed(0);

                                    return GestureDetector(
                                      child: Container(
                                        width: widthScreen * 0.9,
                                        margin:
                                            const EdgeInsets.only(bottom: 20),
                                        height: widthScreen * 0.4,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 18),
                                        decoration: BoxDecoration(
                                          color: searchBar,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              decoration: const BoxDecoration(
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
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        width:
                                                            widthScreen * 0.44,
                                                        child: Text(
                                                          exam['title'],
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: GoogleFonts
                                                              .mulish(
                                                            fontWeight:
                                                                textExtra,
                                                            fontSize: font14,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        ' $duration Menit',
                                                        style:
                                                            GoogleFonts.mulish(
                                                          fontWeight:
                                                              textMedium,
                                                          fontSize: font14,
                                                          color: redSolid,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    DateFormat('d, MMMM y',
                                                                'id_ID')
                                                            .format(DateTime
                                                                .parse(exam[
                                                                    'expired_time'])) +
                                                        DateFormat('HH:mm').format(
                                                            DateTime.parse(exam[
                                                                'expired_time'])),
                                                    style: GoogleFonts.mulish(
                                                      fontWeight: textMedium,
                                                      fontSize: font14,
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      LinearPercentIndicator(
                                                        width:
                                                            widthScreen * 0.56,
                                                        lineHeight: 12,
                                                        percent: decimal,
                                                        progressColor: blueText,
                                                        backgroundColor:
                                                            progressBar,
                                                      ),
                                                      SizedBox(
                                                          width: widthScreen *
                                                              0.02),
                                                      Text(
                                                        '$result%',
                                                        style:
                                                            GoogleFonts.mulish(
                                                          fontSize: font12,
                                                          color: blackText,
                                                          fontWeight: textBold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: InkWell(
                                                      onTap: !hasAttempt
                                                          ? () {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                      exam[
                                                                          'title'],
                                                                      style: GoogleFonts.mulish(
                                                                          color:
                                                                              greenSolid,
                                                                          fontWeight:
                                                                              textBold,
                                                                          fontSize:
                                                                              font22),
                                                                    ),
                                                                    content:
                                                                        const Text(
                                                                            'Mulai ujian sekarang?'),
                                                                    titleTextStyle: GoogleFonts.mulish(
                                                                        color:
                                                                            subTitle,
                                                                        fontWeight:
                                                                            textMedium,
                                                                        fontSize:
                                                                            font12),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Batal',
                                                                          style: GoogleFonts.mulish(
                                                                              color: subTitle,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                      TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                            // ignore: use_build_context_synchronously
                                                                            Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: (context) => ExamScreens(
                                                                                        exam: exam,
                                                                                        studentId: widget.studentId,
                                                                                      )),
                                                                            );
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                const EdgeInsets.all(12),
                                                                            decoration:
                                                                                BoxDecoration(color: greenSolid, borderRadius: BorderRadius.circular(6)),
                                                                            child:
                                                                                Text(
                                                                              !hasAttempt ? 'Mulai' : 'Lihat Hasil',
                                                                              style: GoogleFonts.mulish(color: whiteText, fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ))
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            }
                                                          : () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => ResultExam(
                                                                      examID:
                                                                          exam['id'],
                                                                      studentId:
                                                                          widget
                                                                              .studentId),
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
                                                              color: greenSolid,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                            child: Center(
                                                              child: Icon(
                                                                !hasAttempt ? Icons
                                                                    .play_arrow : Icons.remove_red_eye,
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
                                                            'Mulai Ujian',
                                                            style: GoogleFonts
                                                                .mulish(
                                                              fontSize: font14,
                                                              color: greenSolid,
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
                                );
                              } else if (totalExam == 0) {
                                return Center(
                                  child: Container(
                                    width: widthScreen * 0.6,
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/statuscode/NoData-1.png'))),
                                  ),
                                );
                              }else{
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
                                        child: Text('Refresh', style: GoogleFonts.mulish(fontWeight: textBold,fontSize: font14, color: whiteText),)
                                      )
                                    ],
                                  ) ,
                                );
                              }
                            } else
                              return Center(
                                child: Text('Error'),
                              );
                          }),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )),
      endDrawer: CommonDrawer(
        currentIndex: _currentIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }

  Future? exerciseList;

  Future<void> _refreshData() async {
    setState(() {
      exerciseList = getExamBySubject();
    });
  }
}
