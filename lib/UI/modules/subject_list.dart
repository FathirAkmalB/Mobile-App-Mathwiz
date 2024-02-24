import 'package:consume_api/UI/exercise_page/subject_list.dart';
import 'package:consume_api/UI/remedial_page/subject_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:consume_api/methods/api.dart';
import 'package:consume_api/data/data.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../SideBar/Drawer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'dart:convert';
import 'dart:core';

import 'package:consume_api/UI/modules/chapter_list.dart';
import 'package:consume_api/layout/mainlayout.dart';


class ListSubjectModules extends StatefulWidget {
  const ListSubjectModules({super.key});

  @override
  State<ListSubjectModules> createState() => _ListSubjectModulesState();
}

class _ListSubjectModulesState extends State<ListSubjectModules> {
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



//  fetch api subjects
  String _searchQuery = "";
  Future<Map> fetchSubjects({String? filter}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final student_id = prefs.getInt('student_id');
    final response = await API().getRequest(route: '/getSubject/$student_id');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final totalSubjects = data['total_subjects'];
      final dataSubjects = data['dataSubjects'];


      if (filter != null && filter.isNotEmpty) {
        final filteredData = filterData(dataSubjects, filter);
        final lengthData = filteredData.length;
        return {
          'totalSubjects': lengthData,
          'dataSubjects': filteredData,
        };
      } else {
        return {
         'totalSubjects': totalSubjects,
         'dataSubjects': dataSubjects,
        };
      }
       
    } else {
      throw Exception('Failed fetch API ${response.statusCode}');
    }
  }
  

  List<dynamic> filterData(List<dynamic> data, String query){
    return data.where((item) {
      final title = item['title'];
      final lecturer = item['lecturer'];
      bool matchesQuery = title.toLowerCase().contains(query.toLowerCase()) || lecturer.toLowerCase().contains(query.toLowerCase());
      
      return matchesQuery;
    }).toList();
  }



  Widget build(BuildContext context) {

    // Variables for this UI
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    double font12 = widthScreen * 0.03;
    double font14 = widthScreen * 0.038;
    double font16 = widthScreen * 0.043;
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
                // App Bar Mata Kuliah Start
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  toolbarHeight: heightScreen * 0.1,
                  title: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Mata Kuliah',
                      style: GoogleFonts.mulish(
                          fontWeight: textExtra, fontSize: font22),
                    ),
                  ),

                  leading: IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return const MainLayout(initialIndex: 0,);
                      }));
                    },
                    icon: const Icon(Icons.keyboard_arrow_left_rounded),
                  ),
                 
                  // SideBar Feature Start
                  actions: [
                    IconButton(
                      icon: const Icon(LucideIcons.alignRight),
                      onPressed: () {
                        _openEndDrawer();
                      },
                    ),
                  ],
                  // SideBar Feature End
                ),
                // App Bar Mata Kuliah End

                SizedBox(
                  height: widthScreen * 0.02,
                ),

                // Search Bar Subject Start
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
                        const SizedBox(width: 6,),
                        Expanded(
                          child: TextField(
                            onSubmitted: (value){
                              setState(() {
                                _searchQuery = value;
                                fetchSubjects(filter: _searchQuery);
                              });
                            },
                            decoration: InputDecoration(
                              hintText: "Cari",
                              border: InputBorder.none,
                              hintStyle: GoogleFonts.mulish(color: subTitle),
                            ),
                          ),
                        ),
                      ],
                    )),
                // Search Bar Subject End

                SizedBox(
                  height: widthScreen * 0.08,
                ),

                // List Subject Start
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: widthScreen * 0.06),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(36),
                            topRight: Radius.circular(36))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Headline Subject.
                        FutureBuilder(
                          future: fetchSubjects(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                width: widthScreen * 0.9,
                                margin: EdgeInsets.only(top: widthScreen * 0.05),
                                alignment: Alignment.topLeft,
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!, // Warna latar belakang shimmer
                                  highlightColor: Colors.grey[100]!, // Warna highlight shimmer
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Buku
                                      Container(
                                        alignment: Alignment.topCenter,
                                        child: Stack(
                                          alignment: Alignment.bottomCenter,
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              width: widthScreen * 0.27,
                                              height: widthScreen * 0.18,
                                              decoration: BoxDecoration(
                                                color: greenSolid,
                                                borderRadius: const BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  topRight: Radius.circular(8),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.bottomCenter,
                                              width: widthScreen * 0.24,
                                              height: widthScreen * 0.35,
                                              decoration: BoxDecoration(
                                                color: greenSolid, // Warna latar belakang shimmer
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.bottomCenter,
                                              width: widthScreen * 0.32,
                                              height: widthScreen * 0.06,
                                              decoration: BoxDecoration(
                                                color: greenSolid,
                                                borderRadius: const BorderRadius.only(
                                                  bottomLeft: Radius.circular(12),
                                                  bottomRight: Radius.circular(12),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: widthScreen * 0.04),
                                      // Title Materi
                                      Container(
                                        alignment: Alignment.topLeft,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: widthScreen * 0.4,
                                              decoration: BoxDecoration(
                                                  color: goldText,
                                                  borderRadius: BorderRadius.circular(2)),
                                              height: widthScreen * 0.04,
                                            ),
                                            SizedBox(
                                                height: heightScreen * 0.02),
                                            Container(
                                              width: widthScreen * 0.48,
                                              height: widthScreen * 0.035,
                                              decoration: BoxDecoration(
                                                  color: goldText,
                                                  borderRadius: BorderRadius.circular(2)),
                                            ),
                                            SizedBox(height: heightScreen * 0.01),
                                            Container(
                                              width: widthScreen * 0.48,
                                              height: widthScreen * 0.035,
                                              decoration: BoxDecoration(
                                                  color: goldText,
                                                  borderRadius: BorderRadius.circular(2)),
                                            ),
                                            SizedBox(height: heightScreen * 0.01),
                                            Container(
                                              width: widthScreen * 0.48,
                                              height: widthScreen * 0.035,
                                              decoration: BoxDecoration(
                                                  color: goldText,
                                                  borderRadius: BorderRadius.circular(2)),
                                            ),
                                            SizedBox(
                                                height: heightScreen * 0.01),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error.toString()}'));
                            } else if (snapshot.hasData) {
                              final data = snapshot.data;
                              final semesterText = data!['dataSubjects'].isNotEmpty
                                      ? data['dataSubjects'][0]['semester']
                                      : "Genap";
                              final cover = data['dataSubjects'].isNotEmpty
                                  ? data['dataSubjects'][0]['cover']
                                  : null;

                              return Container(
                                width: widthScreen * 0.9,
                                margin: EdgeInsets.only(top: widthScreen * 0.05),
                                alignment: Alignment.topLeft,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Buku (Ini adalah bagian kode buku yang Anda miliki)
                                    Container(
                                      alignment: Alignment.topCenter,
                                      child: Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            width: widthScreen * 0.27,
                                            height: widthScreen * 0.18,
                                            decoration: BoxDecoration(
                                                color: greenSolid,
                                                borderRadius: const BorderRadius
                                                    .only(
                                                    topLeft: Radius.circular(8),
                                                    topRight:
                                                        Radius.circular(8))),
                                          ),
                                          Container(
                                            alignment: Alignment.bottomCenter,
                                            width: widthScreen * 0.24,
                                            height: widthScreen * 0.35,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: cover != null
                                                        ? NetworkImage(
                                                            '${ApiURL.apiUrl}/storage/$cover')
                                                        : const AssetImage(
                                                                'assets/img/DefaultCoverBook.png')
                                                            as ImageProvider,
                                                    fit: BoxFit.cover)),
                                          ),
                                          Container(
                                            alignment: Alignment.bottomCenter,
                                            width: widthScreen * 0.32,
                                            height: widthScreen * 0.06,
                                            decoration: BoxDecoration(
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.black,
                                                    offset: Offset(0,
                                                        -1), // Y-offset of -2
                                                    blurRadius:
                                                        2, // Optional blur radius
                                                    spreadRadius:
                                                        0, // Optional spread radius
                                                  ),
                                                ],
                                                color: greenSolid,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(12),
                                                        bottomRight:
                                                            Radius.circular(
                                                                12))),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            // semester
                                            'Semester ' + semesterText,
                                            maxLines: 1,
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.mulish(
                                              color: greenSolid,
                                              fontWeight: textBold,
                                              fontSize: font16,
                                            ),
                                          ),
                                          SizedBox(
                                            height: heightScreen * 0.01,
                                          ),
                                          InkWell(
                                            child: Container(
                                            width: widthScreen * 0.48,
                                            child: RichText(
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 6,
                                              text: TextSpan(
                                                text:
                                                    'Seluruh mata kuliah dalam lingkup semester genap sudah tersedia, anda dapat mencari dan mengaksesnya kembali sekarang.',
                                                style: GoogleFonts.mulish(
                                                  color: subTitle,
                                                  fontSize: font12,
                                                ),
                                              ),
                                            ),
                                          ),
                                          ),
                                          SizedBox(
                                            height: heightScreen * 0.01,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return const Text('Gagal mendapatkan data');
                            }
                          },
                        ),

                        SizedBox(
                          height: heightScreen * 0.04,
                        ),

                        FutureBuilder(
                            future: _searchQuery.isNotEmpty ? fetchSubjects(filter: _searchQuery) : fetchSubjects(),
                            builder: ((context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: widthScreen * 0.45,
                                        height: widthScreen * 0.08,
                                        decoration: BoxDecoration(
                                            color: goldText,
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                      ),
                                      Container(
                                        width: widthScreen * 0.2,
                                        height: widthScreen * 0.05,
                                        decoration: BoxDecoration(
                                            color: goldText,
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                      ),
                                    ],
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text(
                                      'Error ${snapshot.error.hashCode.toString()}'),
                                );
                              } else if (snapshot.hasData) {
                                final data = snapshot.data;
                                final totalSubjects = data!['totalSubjects'];
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Daftar Mata Kuliah',
                                      style: GoogleFonts.mulish(
                                          fontSize: font18,
                                          fontWeight: textBold,
                                          color: blackText),
                                    ),
                                    Text(
                                      '($totalSubjects Matkul)',
                                      style: GoogleFonts.mulish(
                                          fontSize: font14,
                                          fontWeight: textBold,
                                          color: greenSolid),
                                    ),
                                  ],
                                );
                              } else {
                                return Center(
                                  child: Text(
                                      'Error ${snapshot.error.hashCode.toString()}'),
                                );
                              }
                            })),

                        SizedBox(
                          height: heightScreen * 0.018,
                        ),

                        // List Bab
                        Expanded(
                          child: FutureBuilder(
                            future: _searchQuery.isNotEmpty ? fetchSubjects(filter: _searchQuery) : fetchSubjects(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: ListView(
                                    children: [
                                      Container(
                                          margin: const EdgeInsets.only(bottom: 20),
                                          height: heightScreen * 0.15,
                                          padding: const EdgeInsets.only(
                                              left: 18,
                                              right: 0,
                                              bottom: 12,
                                              top: 12),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular( widthScreen * 0.03 ),
                                            color: goldText
                                          ),
                                        ),
                                      Container(
                                          margin: const EdgeInsets.only(bottom: 20),
                                          height: heightScreen * 0.15,
                                          padding: const EdgeInsets.only(
                                              left: 18,
                                              right: 0,
                                              bottom: 12,
                                              top: 12),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular( widthScreen * 0.03 ),
                                            color: goldText
                                          ),
                                        ),
                                      Container(
                                          margin: const EdgeInsets.only(bottom: 20),
                                          height: heightScreen * 0.15,
                                          padding: const EdgeInsets.only(
                                              left: 18,
                                              right: 0,
                                              bottom: 12,
                                              top: 12),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular( widthScreen * 0.03 ),
                                            color: goldText
                                          ),
                                        ),

                                    ],
                                  ), 
                                  );
                              } else if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error.toString()}'));
                              } else if (snapshot.hasData) {
                                final data = snapshot.data;
                                final subjects = data!['dataSubjects'];
                                final totalSubjects = data['totalSubjects'];
                                if (totalSubjects == 0) {
                                  return Center(
                                    child: Container(
                                      width: widthScreen * 0.6,
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/statuscode/NoData-1.png'))),
                                    ),
                                  );
                                }else if(subjects == 0){
                                  return Center(
                                    child: Container(
                                      width: widthScreen * 0.6,
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/statuscode/NoData-1.png'))),
                                    ),
                                  );
                                }else {
                                  return ListView.builder(
                                    itemCount: subjects.length ?? 0,
                                    itemBuilder: (context, index) {
                                      var subject = subjects[index]; // menampilkan data berdasarkan index data yang di dapat.
                                      final totalChapters = subject['total_chapters'];
                                      final totalSubChapters = subject['total_sub_chapters'];
                                      final totalSubChaptersHasRead = subject['total_sub_chapters_has_read'];
                                      final coverBook = subject['cover'];

                                      double decimal = totalSubChaptersHasRead/totalSubChapters;
                                      double percentase = decimal * 100;
                                      String percent = percentase.toStringAsFixed(0);

                                      return GestureDetector( // Navigasi untuk membuka detail
                                        onTap: () async {
                                          SharedPreferences pref = await SharedPreferences.getInstance();
                                          final studentId = pref.getInt('student_id');
                                          // ignore: use_build_context_synchronously
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => ListChapterModules( subject: subject, studentId: studentId )));
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(bottom: 20),
                                          height: heightScreen * 0.2,
                                          padding: const EdgeInsets.only(
                                              left: 18,
                                              right: 0,
                                              bottom: 12,
                                              top: 12),

                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular( widthScreen * 0.03 ),
                                            border: Border.all( width: 2, color: inputLogin ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Buku
                                              Container(
                                                alignment: Alignment.center,
                                                child: Stack(
                                                  alignment: Alignment.bottomCenter,
                                                  children: [
                                                    Container(
                                                      alignment: Alignment.center,
                                                      width: widthScreen * 0.18,
                                                      height: widthScreen * 0.12,
                                                      decoration: BoxDecoration(
                                                        color: greenSolid,
                                                        borderRadius: const BorderRadius .only(
                                                          topLeft: Radius.circular(8),
                                                          topRight: Radius.circular(8),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment: Alignment.bottomCenter,
                                                      width: widthScreen * 0.16,
                                                      height: widthScreen * 0.24,
                                                      decoration:  BoxDecoration(
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
                                                      alignment: Alignment.bottomCenter,
                                                      width: widthScreen * 0.20,
                                                      height: widthScreen * 0.04,
                                                      decoration: BoxDecoration(
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color: Colors.black,
                                                            offset: Offset(0, -1),
                                                            blurRadius: 2,
                                                            spreadRadius: 0,
                                                          ),
                                                        ],
                                                        color: greenSolid,
                                                        borderRadius: const BorderRadius.only(
                                                          bottomLeft: Radius.circular(6),
                                                          bottomRight: Radius.circular(6),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              SizedBox(
                                                width: widthScreen * 0.04,
                                              ),

                                              // Judul Materi
                                              Container(
                                                alignment: Alignment.topLeft,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text( 
                                                      subject['title'] as String,
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
                                                      alignment: Alignment.topLeft,
                                                      child: Text(
                                                        subject['lecturer'] as String,
                                                        style: GoogleFonts.mulish(
                                                          color: greenSolid,
                                                          fontWeight: textBold,
                                                          fontSize: font12,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment: Alignment.topLeft,
                                                      child: Text('($totalChapters Bab)'.toString(),
                                                        style: GoogleFonts.mulish(
                                                          color: outlineInput,
                                                          fontWeight: textBold,
                                                          fontSize: font12,
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        LinearPercentIndicator( 
                                                          width: widthScreen * 0.48,
                                                          lineHeight: 12,
                                                          percent: decimal.isNaN ? 0 : decimal, 
                                                          progressColor: totalSubChapters != totalSubChaptersHasRead ? yellowText : totalSubChaptersHasRead == 0 ? yellowText : totalSubChapters == totalSubChaptersHasRead ? blueText : yellowText,
                                                          backgroundColor: progressBar,
                                                        ),
                                                         Text(decimal.isNaN ? '0%' :'${percent}%',
                                                         style: GoogleFonts.mulish(
                                                            fontWeight: textBold,
                                                            fontSize: 12,
                                                          ),
                                                        ), 
                                                      ],
                                                    ),
                                                    Container(
                                                      alignment: Alignment.topLeft,
                                                      child: Text(
                                                        totalSubChaptersHasRead == 0 ? 'Belum di kerjakan' : totalSubChaptersHasRead != totalSubChapters ? 'Dalam Proses Pengerjaan' : 'Sudah dikerjakan',
                                                        style: GoogleFonts.mulish(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: font12,
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
                                return const Center(
                                    child: Text('Tidak ada data.'));
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                )
                // List Subject End


              ],
            )),
      ),
      endDrawer: CommonDrawer(
        currentIndex: _currentIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}
