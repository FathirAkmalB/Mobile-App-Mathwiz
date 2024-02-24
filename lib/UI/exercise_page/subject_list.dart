import 'package:consume_api/SideBar/Drawer.dart';
import 'package:consume_api/UI/modules/subject_list.dart';
import 'package:consume_api/UI/exercise_page/chapter_list.dart';
import 'package:consume_api/UI/exam_page/subject_list.dart';
import 'package:consume_api/UI/remedial_page/subject_list.dart';
import 'package:consume_api/layout/mainlayout.dart';
import 'package:flutter/material.dart';
import 'package:consume_api/data/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:consume_api/methods/api.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ListSubjectExercise extends StatefulWidget {
  const ListSubjectExercise({super.key});

  @override
  State<ListSubjectExercise> createState() => _ListSubjectExerciseState();
}

class _ListSubjectExerciseState extends State<ListSubjectExercise> {
  String _searchQuery = '';

//  Mengambil data Subjects
  Future<Map> fetchSubjects({String? filter}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final studentId = pref.getInt('student_id');
    final response =
        await API().getRequest(route: '/getAllDataExercise/$studentId');

    try {
      if (response.statusCode == 200) {
        print('Successfully get subject exercise data');
        final data = jsonDecode(response.body);
        final totalSubjects = data['total_subjects'];
        final dataSubjects = data['dataSubjects'];

        if (filter != null && filter.isNotEmpty) {
          final filteredData = filterData(dataSubjects, filter);
          final lengthData = filteredData.length;
          
          return {
            'totalSubjects': lengthData,
            'dataSubjects': filteredData,
            'student_id': studentId,
          };
        } else {
          return {
            'totalSubjects': totalSubjects,
            'dataSubjects': dataSubjects,
            'student_id': studentId,
          };
        }
      } else {
        throw Exception('Gagal mengambil data dari API ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Periksa koneksi data dari API ${response.statusCode}');
    }
  }

  List<dynamic> filterData(List<dynamic> data, String query) {
    return data.where((item) {
      final title = item['title'];
      
      final lecturer = item['lecturer'];
      bool matchesQuery = title.toLowerCase().contains(query.toLowerCase()) ||
          lecturer.toLowerCase().contains(query.toLowerCase());
      return matchesQuery;
    }).toList();
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
                builder: (context) => const ListSubjectExam()));
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
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  toolbarHeight: heightScreen * 0.1,
                  title: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Latihan Soal',
                      style: GoogleFonts.mulish(
                          fontWeight: textExtra, fontSize: font22),
                    ),
                  ),
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return const MainLayout(
                          initialIndex: 0,
                        );
                      }));
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

                SizedBox(
                  height: widthScreen * 0.02,
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
                            onSubmitted: (value) {
                              setState(() {
                                _searchQuery = value;
                                print(_searchQuery);
                                fetchSubjects(filter: _searchQuery);
                              });
                            },
                            decoration: InputDecoration(
                              hintText: "Cari Mata Kuliah",
                              border: InputBorder.none,
                              hintStyle: GoogleFonts.mulish(color: subTitle),
                            ),
                          ),
                        ),
                      ],
                    )),

                // list view
                SizedBox(
                  height: widthScreen * 0.08,
                ),

                Expanded(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: widthScreen * 0.06),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(36),
                            topRight: Radius.circular(36))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: heightScreen * 0.025,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Daftar Mata Kuliah',
                              style: GoogleFonts.mulish(
                                  fontSize: font18,
                                  fontWeight: textBold,
                                  color: blackText),
                            ),
                            FutureBuilder(
                                future: _searchQuery != null &&
                                        _searchQuery.isNotEmpty
                                    ? fetchSubjects(filter: _searchQuery)
                                    : fetchSubjects(),
                                builder: ((context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Text(
                                      '(0 Matkul)',
                                      style: GoogleFonts.mulish(
                                          fontSize: font14,
                                          fontWeight: textBold,
                                          color: greenSolid),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text(
                                      '(0 Matkul)',
                                      style: GoogleFonts.mulish(
                                          fontSize: font14,
                                          fontWeight: textBold,
                                          color: greenSolid),
                                    );
                                  } else if (snapshot.hasData) {
                                    final data = snapshot.data;
                                    final totalSubjects =
                                        data!['totalSubjects'];
                                    return Text(
                                      '($totalSubjects Matkul)',
                                      style: GoogleFonts.mulish(
                                          fontSize: font14,
                                          fontWeight: textBold,
                                          color: greenSolid),
                                    );
                                  } else {
                                    return Text(
                                      '(0 Matkul)',
                                      style: GoogleFonts.mulish(
                                          fontSize: font14,
                                          fontWeight: textBold,
                                          color: greenSolid),
                                    );
                                  }
                                }))
                          ],
                        ),
                        SizedBox(
                          height: heightScreen * 0.012,
                        ),

                        // List Bab
                        Expanded(
                          child: FutureBuilder(
                            future:
                                _searchQuery != null && _searchQuery.isNotEmpty
                                    ? fetchSubjects(filter: _searchQuery)
                                    : fetchSubjects(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 14),
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
                                          child: Text(
                                            'Refresh',
                                            style: GoogleFonts.mulish(
                                                fontWeight: textBold,
                                                fontSize: font14,
                                                color: whiteText),
                                          ))
                                    ],
                                  ),
                                );
                              } else if (snapshot.hasData) {
                                final data = snapshot.data;
                                final totalSubjects = data!['totalSubjects'];
                                final dataSubjects = data['dataSubjects'];
                                if (totalSubjects < 1) {
                                  return Center(
                                    child: Container(
                                      width: widthScreen * 0.6,
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/statuscode/NoData-1.png'))),
                                    ),
                                  );
                                } else {
                                  return ListView.builder(
                                    itemCount: dataSubjects.length,
                                    itemBuilder: (context, index) {
                                      var subject = dataSubjects[index];
                                      final totalChapters = subject[
                                          'total_chapters']; // Total Chapter
                                      final totalExercises = subject[
                                          'total_exercises_by_subject']; // Total Exercise
                                      final totalChapterAttempted = subject[
                                          'total_attempted_exercises_by_subject']; // Total Chapter yang telah diselesaikan
                                      double decimal = (totalChapterAttempted /
                                          totalExercises); // Menghitung Persentase
                                      double toPercent = decimal * 100;
                                      String percent = toPercent
                                          .toStringAsFixed(0); // Persentase
                                      final studentId =
                                          snapshot.data!['student_id'];

                                      final coverBook = subject['cover'];

                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ListChapterExercise(
                                                          subjectExam: subject,
                                                          studentId:
                                                              studentId)));
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 20),
                                          height: heightScreen * 0.2,
                                          padding: const EdgeInsets.only(
                                              left: 18,
                                              right: 0,
                                              bottom: 12,
                                              top: 12),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                widthScreen * 0.03),
                                            border: Border.all(
                                                width: 2, color: inputLogin),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Buku
                                              Container(
                                                alignment: Alignment.center,
                                                child: Stack(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  children: [
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: widthScreen * 0.18,
                                                      height:
                                                          widthScreen * 0.12,
                                                      decoration: BoxDecoration(
                                                        color: greenSolid,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  8),
                                                          topRight:
                                                              Radius.circular(
                                                                  8),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      width: widthScreen * 0.16,
                                                      height:
                                                          widthScreen * 0.24,
                                                      decoration:
                                                        BoxDecoration(
                                                        image: DecorationImage(
                                                          image: coverBook != null
                                                        ? NetworkImage(
                                                            '${ApiURL.apiUrl}/storage/$coverBook')
                                                        : const AssetImage(
                                                                'assets/img/DefaultCoverBook.png')
                                                            as ImageProvider,
                                                    fit: BoxFit.cover)),
                                                    ),
                                                    Container(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      width: widthScreen * 0.20,
                                                      height:
                                                          widthScreen * 0.04,
                                                      decoration: BoxDecoration(
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color: Colors.black,
                                                            offset:
                                                                Offset(0, -1),
                                                            blurRadius: 2,
                                                            spreadRadius: 0,
                                                          ),
                                                        ],
                                                        color: greenSolid,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  6),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  6),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: widthScreen * 0.04,
                                              ),
                                              // Title Materi
                                              Container(
                                                alignment: Alignment.topLeft,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // title
                                                    Text(
                                                      subject['title']
                                                          .toString(),
                                                      maxLines: 1,
                                                      textAlign: TextAlign.left,
                                                      style: GoogleFonts.mulish(
                                                        color: Colors.black,
                                                        fontWeight: textBold,
                                                        fontSize: font14,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: widthScreen * 0.55,
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        // lecturer
                                                        subject['lecturer']
                                                            .toString(),
                                                        style:
                                                            GoogleFonts.mulish(
                                                          color: greenSolid,
                                                          fontWeight: textBold,
                                                          fontSize: font12,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        // total_bab
                                                        '($totalChapters Bab)'
                                                            .toString(),
                                                        style:
                                                            GoogleFonts.mulish(
                                                          color: outlineInput,
                                                          fontWeight: textBold,
                                                          fontSize: font12,
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        LinearPercentIndicator(
                                                          width: widthScreen *
                                                              0.45,
                                                          lineHeight: 12,
                                                          percent: decimal.isNaN
                                                              ? 0
                                                              : decimal,
                                                          progressColor: totalChapterAttempted !=
                                                                  totalExercises
                                                              ? yellowText
                                                              : totalExercises ==
                                                                      0
                                                                  ? yellowText
                                                                  : totalChapterAttempted ==
                                                                          totalExercises
                                                                      ? blueText
                                                                      : yellowText,
                                                          backgroundColor:
                                                              progressBar,
                                                        ),
                                                        Text(decimal.isNaN
                                                            ? '0%'
                                                            : '$percent%'),
                                                      ],
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        totalChapterAttempted ==
                                                                0
                                                            ? 'Belum dikerjakan'
                                                            : totalChapterAttempted ==
                                                                    totalSubjects
                                                                ? 'Sudah dikerjakan'
                                                                : 'Dalam proses pengerjaan',
                                                        style:
                                                            GoogleFonts.mulish(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 10,
                                                          color: outlineInput,
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
                                }
                              } else {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 14),
                                        child: Text(
                                          'Periksa Koneksi anda...',
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
                                          child: Text(
                                            'Refresh',
                                            style: GoogleFonts.mulish(
                                                fontWeight: textBold,
                                                fontSize: font14,
                                                color: whiteText),
                                          ))
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        )
                      ],
                    ),
                    // child: ,
                  ),
                )
              ],
            )),
      ),
      endDrawer: CommonDrawer(
        currentIndex: _currentIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }

  Future? ExerciseList;

  Future<void> _refreshData() async {
    setState(() {
      ExerciseList = fetchSubjects();
    });
  }
}
