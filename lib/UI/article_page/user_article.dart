import 'dart:convert';

import 'package:consume_api/UI/article_page/preview_article.dart';
import 'package:consume_api/methods/api.dart';
import 'package:flutter/material.dart';
import 'package:consume_api/data/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserArticle extends StatefulWidget {
  const UserArticle({super.key});

  @override
  State<UserArticle> createState() => UserArticleState();
}

class UserArticleState extends State<UserArticle> {
  int indexTab = 0;
  late int userId = 0;
  List dataArticles = [];
  
  List publishedArticles = [];
  List takeDownArticles = [];
  List rejectedArticles = [];
  List pendingArticles = [];

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  Future<List<dynamic>> fetchArticles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final idUser = prefs.getInt('id');
    print('cek $idUser');
    final response =
        await API().getRequest(route: '/getArticleByUserId/$idUser');

    if (response.statusCode == 200) {
      setState(() {
        dataArticles = jsonDecode(response.body);
        userId = idUser!;

        for (var data in dataArticles) {
          if (data['status'] == 'allowed') {
            publishedArticles.add(data);
          } else if (data['status'] == 'pending') {
            pendingArticles.add(data);
          } else if (data['status'] == 'takeDown') {
            takeDownArticles.add(data);
          }else if (data['status'] == 'rejected') {
            rejectedArticles.add(data);
          }
        }
      });
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load articles');
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    double font14 = widthScreen * 0.043;
    double font12 = widthScreen * 0.038;
    double font16 = widthScreen * 0.045;
    double font18 = widthScreen * 0.048;
    double font22 = widthScreen * 0.055;

    return Scaffold(
      backgroundColor: whiteText,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              // Appbar
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                toolbarHeight: heightScreen * 0.1,
                title: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Artikel Anda',
                    style: GoogleFonts.mulish(
                        fontWeight: textExtra,
                        color: Colors.black,
                        fontSize: widthScreen * 0.055),
                  ),
                ),
                leading: Container(
                    margin: const EdgeInsets.only(left: 6),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 30,
                      ),
                      color: blueText,
                    )),
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 6),
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.assignment,
                          size: 30,
                          color: Colors.transparent,
                        )),
                  )
                ],
              ),

              Container(
                width: widthScreen,
                height: 1,
                decoration: const BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(30, 0, 0, 0),
                    offset: Offset(2, 4), // Y-offset of -2
                    blurRadius: 1, // Optional blur radius
                    spreadRadius: 0,
                  ),
                ]),
              ),

              SizedBox(
                height: widthScreen * 0.06,
              ),

              Container(
                height: widthScreen * 0.1,
                margin: EdgeInsets.symmetric(horizontal: widthScreen * 0.04),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    indexTab == 0
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                indexTab = 0;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: widthScreen * 0.3,
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                  border:
                                      Border.all(color: greenSolid, width: 2)),
                              child: Text(
                                'Dipublish',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.mulish(
                                    color: greenSolid,
                                    fontWeight: textBold,
                                    fontSize: font12),
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              setState(() {
                                indexTab = 0;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: widthScreen * 0.3,
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                  color: searchBar,
                                  borderRadius: BorderRadius.circular(20),
                                  border:
                                      Border.all(color: searchBar, width: 2)),
                              child: Text(
                                'Dipublish',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.mulish(
                                    color: subTitle,
                                    fontWeight: textBold,
                                    fontSize: font12),
                              ),
                            ),
                          ),
                    const SizedBox(
                      width: 12,
                    ),
                    indexTab != 1
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                indexTab = 1;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: widthScreen * 0.3,
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                  color: searchBar,
                                  borderRadius: BorderRadius.circular(20),
                                  border:
                                      Border.all(color: searchBar, width: 2)),
                              child: Text(
                                'Diajukan',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.mulish(
                                    color: subTitle,
                                    fontWeight: textBold,
                                    fontSize: font12),
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              setState(() {
                                indexTab = 1;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: widthScreen * 0.3,
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                  border:
                                      Border.all(color: greenSolid, width: 2)),
                              child: Text(
                                'Diajukan',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.mulish(
                                    color: greenSolid,
                                    fontWeight: textBold,
                                    fontSize: font12),
                              ),
                            ),
                          ),
                    const SizedBox(
                      width: 12,
                    ),
                    indexTab != 2
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                indexTab = 2;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: widthScreen * 0.3,
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                  color: searchBar,
                                  borderRadius: BorderRadius.circular(20),
                                  border:
                                      Border.all(color: searchBar, width: 2)),
                              child: Text(
                                'Take Down',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.mulish(
                                    color: subTitle,
                                    fontWeight: textBold,
                                    fontSize: font12),
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              setState(() {
                                indexTab = 2;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: widthScreen * 0.3,
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                  border:
                                      Border.all(color: greenSolid, width: 2)),
                              child: Text(
                                'Take Down',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.mulish(
                                    color: greenSolid,
                                    fontWeight: textBold,
                                    fontSize: font12),
                              ),
                            ),
                          ),
                    const SizedBox(
                      width: 12,
                    ),
                    indexTab != 3
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                indexTab = 3;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: widthScreen * 0.3,
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                  color: searchBar,
                                  borderRadius: BorderRadius.circular(20),
                                  border:
                                      Border.all(color: searchBar, width: 2)),
                              child: Text(
                                'Tertolak',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.mulish(
                                    color: subTitle,
                                    fontWeight: textBold,
                                    fontSize: font12),
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              setState(() {
                                indexTab = 3;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: widthScreen * 0.3,
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                  border:
                                      Border.all(color: greenSolid, width: 2)),
                              child: Text(
                                'Tertolak',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.mulish(
                                    color: greenSolid,
                                    fontWeight: textBold,
                                    fontSize: font12),
                              ),
                            ),
                          )
                  ],
                ),
              ),

              SizedBox(
                height: widthScreen * 0.06,
              ),

              Expanded(
                child: indexTab == 0 && publishedArticles.isNotEmpty
                    ? ListView.builder(
                        itemCount: publishedArticles!.length,
                        itemBuilder: (context, index) {
                          final item = publishedArticles[index];
                          final title = item['title'];
                          final updateAt = item['updated_at'];
                          final cover = item['cover'];
                          final status = item['status'];
                          String originalDateTime = updateAt;
                          String formattedDateTime =
                              formatDateTime(originalDateTime);
                          if (status == 'allowed') {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return PreviewArticle(articleId: item['id']);
                                }));
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: widthScreen * 0.04,
                                    vertical: widthScreen * 0.02),
                                width: widthScreen * 0.9,
                                padding: EdgeInsets.symmetric(
                                    horizontal: widthScreen * 0.04,
                                    vertical: widthScreen * 0.04),
                                decoration: BoxDecoration(
                                    color: searchBar,
                                    borderRadius: BorderRadius.circular(14)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: widthScreen * 0.25,
                                      height: widthScreen * 0.25,
                                      decoration: BoxDecoration(
                                        color: whiteText,
                                        image: DecorationImage(
                                            image: cover != null
                                                ? NetworkImage(
                                                    '${ApiURL.apiUrl}/storage/$cover')
                                                : const AssetImage(
                                                        'assets/img/articleDefaultCover.jpg')
                                                    as ImageProvider,
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromARGB(30, 4, 0, 0),
                                            offset:
                                                Offset(0, 2), // Y-offset of -2
                                            blurRadius:
                                                2, // Optional blur radius
                                            spreadRadius:
                                                0, // Optional spread radius
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: widthScreen * 0.45,
                                      height: widthScreen * 0.25,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            '$title',
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.mulish(
                                              fontSize: 14,
                                              fontWeight: textExtra,
                                            ),
                                          ),
                                          Text(
                                            '$formattedDateTime',
                                            // maxLines: 3,
                                            // overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.mulish(
                                              fontSize: 12,
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
                          }
                        },
                      )
                    : indexTab == 0 && publishedArticles.isEmpty
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
                                'Belum ada article yang Dipublish',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.mulish(
                                    fontWeight: textMedium,
                                    fontSize: font14,
                                    color: subTitle),
                              )
                            ],
                          ))
                        : indexTab == 1 && pendingArticles.isNotEmpty ? ListView.builder(
                            itemCount: pendingArticles.length,
                            itemBuilder: (context, index) {
                              final item = pendingArticles[index];
                              final title = item['title'];
                              final updateAt = item['updated_at'];
                              final cover = item['cover'];
                              final status = item['status'];
                              String originalDateTime = updateAt;
                              String formattedDateTime =
                                  formatDateTime(originalDateTime);
                              if (status == 'pending') {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return PreviewArticle(
                                          articleId: item['id']);
                                    }));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: widthScreen * 0.04,
                                        vertical: widthScreen * 0.02),
                                    width: widthScreen * 0.9,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: widthScreen * 0.04,
                                        vertical: widthScreen * 0.04),
                                    decoration: BoxDecoration(
                                        color: searchBar,
                                        borderRadius:
                                            BorderRadius.circular(14)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: widthScreen * 0.25,
                                          height: widthScreen * 0.25,
                                          decoration: BoxDecoration(
                                            color: whiteText,
                                            image: DecorationImage(
                                                image: cover != null
                                                    ? NetworkImage(
                                                        '${ApiURL.apiUrl}/storage/$cover')
                                                    : const AssetImage(
                                                            'assets/img/articleDefaultCover.jpg')
                                                        as ImageProvider,
                                                fit: BoxFit.cover),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: const [
                                              BoxShadow(
                                                color:
                                                    Color.fromARGB(30, 4, 0, 0),
                                                offset: Offset(
                                                    0, 2), // Y-offset of -2
                                                blurRadius:
                                                    2, // Optional blur radius
                                                spreadRadius:
                                                    0, // Optional spread radius
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: widthScreen * 0.45,
                                          height: widthScreen * 0.25,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                '$title',
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.mulish(
                                                  fontSize: 14,
                                                  fontWeight: textExtra,
                                                ),
                                              ),
                                              
                                              Text(
                                                'Upload at                                    $formattedDateTime',
                                                maxLines: 2,
                                                // overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.mulish(
                                                  fontSize: 12,
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
                              }
                            },
                          )
                          : indexTab == 1 && pendingArticles.isEmpty ? Center(
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
                                'Belum ada article yang Diajukan',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.mulish(
                                    fontWeight: textMedium,
                                    fontSize: font14,
                                    color: subTitle),
                              )
                            ],
                          )) : indexTab == 2 && takeDownArticles.isNotEmpty ? ListView.builder(
                            itemCount: takeDownArticles.length,
                            itemBuilder: (context, index) {
                              final item = takeDownArticles[index];
                              final title = item['title'];
                              final updateAt = item['updated_at'];
                              final cover = item['cover'];
                              final status = item['status'];
                              String originalDateTime = updateAt;
                              String formattedDateTime = formatDateTime(originalDateTime);
                              if (status == 'takeDown') {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return PreviewArticle(
                                          articleId: item['id']);
                                    }));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: widthScreen * 0.04,
                                        vertical: widthScreen * 0.02),
                                    width: widthScreen * 0.9,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: widthScreen * 0.04,
                                        vertical: widthScreen * 0.04),
                                    decoration: BoxDecoration(
                                        color: searchBar,
                                        borderRadius:
                                            BorderRadius.circular(14)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: widthScreen * 0.25,
                                          height: widthScreen * 0.25,
                                          decoration: BoxDecoration(
                                            color: whiteText,
                                            image: DecorationImage(
                                                image: cover != null
                                                    ? NetworkImage(
                                                        '${ApiURL.apiUrl}/storage/$cover')
                                                    : const AssetImage(
                                                            'assets/img/articleDefaultCover.jpg')
                                                        as ImageProvider,
                                                fit: BoxFit.cover),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: const [
                                              BoxShadow(
                                                color:
                                                    Color.fromARGB(30, 4, 0, 0),
                                                offset: Offset(
                                                    0, 2), // Y-offset of -2
                                                blurRadius:
                                                    2, // Optional blur radius
                                                spreadRadius:
                                                    0, // Optional spread radius
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: widthScreen * 0.45,
                                          height: widthScreen * 0.25,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                '$title',
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.mulish(
                                                  fontSize: 14,
                                                  fontWeight: textExtra,
                                                ),
                                              ),
                                              Text(
                                                'Take Down',
                                                style: GoogleFonts.mulish(
                                                  fontSize: 12,
                                                  color: redSolid,
                                                  fontWeight: textExtra,
                                                ),
                                              ),
                                              Text(
                                                '$formattedDateTime',
                                                // maxLines: 3,
                                                // overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.mulish(
                                                  fontSize: 12,
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
                              }
                            },
                          ) : indexTab == 2 && takeDownArticles.isEmpty ?  Center(
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
                                'Belum ada article yang Diajukan',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.mulish(
                                    fontWeight: textMedium,
                                    fontSize: font14,
                                    color: subTitle),
                              )
                            ],
                          )) : indexTab == 3 && rejectedArticles.isNotEmpty ? ListView.builder(
                            itemCount: rejectedArticles.length,
                            itemBuilder: (context, index) {
                              final item = rejectedArticles[index];
                              final title = item['title'];
                              final updateAt = item['updated_at'];
                              final cover = item['cover'];
                              final status = item['status'];
                              String originalDateTime = updateAt;
                              String formattedDateTime =
                                  formatDateTime(originalDateTime);
                              if (status == 'rejected') {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return PreviewArticle(
                                          articleId: item['id']);
                                    }));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: widthScreen * 0.04,
                                        vertical: widthScreen * 0.02),
                                    width: widthScreen * 0.9,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: widthScreen * 0.04,
                                        vertical: widthScreen * 0.04),
                                    decoration: BoxDecoration(
                                        color: searchBar,
                                        borderRadius:
                                            BorderRadius.circular(14)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: widthScreen * 0.25,
                                          height: widthScreen * 0.25,
                                          decoration: BoxDecoration(
                                            color: whiteText,
                                            image: DecorationImage(
                                                image: cover != null
                                                    ? NetworkImage(
                                                        '${ApiURL.apiUrl}/storage/$cover')
                                                    : const AssetImage(
                                                            'assets/img/articleDefaultCover.jpg')
                                                        as ImageProvider,
                                                fit: BoxFit.cover),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: const [
                                              BoxShadow(
                                                color:
                                                    Color.fromARGB(30, 4, 0, 0),
                                                offset: Offset(
                                                    0, 2), // Y-offset of -2
                                                blurRadius:
                                                    2, // Optional blur radius
                                                spreadRadius:
                                                    0, // Optional spread radius
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: widthScreen * 0.45,
                                          height: widthScreen * 0.25,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                '$title',
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.mulish(
                                                  fontSize: 14,
                                                  fontWeight: textExtra,
                                                ),
                                              ),
                                              Text(
                                                '$formattedDateTime',
                                                // maxLines: 3,
                                                // overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.mulish(
                                                  fontSize: 12,
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
                              }
                            },
                          ) : indexTab == 3 && rejectedArticles.isEmpty ? Center(
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
                                'Belum ada article yang Diajukan',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.mulish(
                                    fontWeight: textMedium,
                                    fontSize: font14,
                                    color: subTitle),
                              )
                            ],
                          )) : const Text('Something went wrong')
              )
            ],
          ),
        ),
      ),
    );
  }

  Future? articleList;

  Future<void> _refreshData() async {
    setState(() {
      articleList = fetchArticles();
    });
  }
}
