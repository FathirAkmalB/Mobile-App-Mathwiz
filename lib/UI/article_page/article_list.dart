import 'dart:convert';

import 'package:consume_api/UI/article_page/article_screens.dart';
import 'package:consume_api/UI/article_page/create_article.dart';
import 'package:consume_api/UI/article_page/user_article.dart';
import 'package:consume_api/methods/api.dart';
import 'package:flutter/material.dart';
import 'package:consume_api/data/data.dart';
import 'package:google_fonts/google_fonts.dart';

class ListArticle extends StatefulWidget {
  const ListArticle({super.key});

  @override
  State<ListArticle> createState() => ListArticleState();
}

class ListArticleState extends State<ListArticle> {
  @override
  void initState() {
    super.initState();
  }

  String _searchQuery = "";
  List<dynamic> filterData(List<dynamic> data, String query){
    return data.where((item) {
      final title = item['title'];
      final lecturer = item['lecturer'];
      bool matchesQuery = title.toLowerCase().contains(query.toLowerCase()) || lecturer.toLowerCase().contains(query.toLowerCase());
      
      return matchesQuery;
    }).toList();
  }

  Future<List<dynamic>> fetchArticles({String? filter}) async {
    final response = await API().getRequest(route: '/getAllArticle');
    final dataArticles = jsonDecode(response.body);


    if (response.statusCode == 200) {
       if (filter != null && filter.isNotEmpty) {
        final filteredData = filterData(dataArticles, filter);
        return filteredData;
      } else {
        return dataArticles;
      }
    } else {
      throw Exception('Failed to load articles');
    }
  }

    Future<void> _refresh() async {
      await fetchArticles();
    }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    double font14 = widthScreen * 0.043;
    double font12 = widthScreen * 0.03;
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
                      'Artikel',
                      style: GoogleFonts.mulish(
                          fontWeight: textExtra,
                          color: Colors.black,
                          fontSize: widthScreen * 0.055),
                    ),
                  ),
                  leading: const Icon(
                    Icons.abc,
                    color: Colors.transparent,
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: ((context) {
                            return const UserArticle();
                          })));
                        },
                        icon: Icon(
                          Icons.article,
                          size: 30,
                          color: yellowText,
                        ))
                  ],
                ),

                // Filter
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  decoration: BoxDecoration(
                    color: whiteText,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(17, 0, 0, 0),
                        offset: Offset(0, 2), // Y-offset of -2
                        blurRadius: 2, // Optional blur radius
                        spreadRadius: 0, // Optional spread radius
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: widthScreen * 0.949,
                          height: widthScreen * 0.14,
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          decoration: BoxDecoration(
                            color: searchBar,
                            borderRadius:
                                BorderRadius.circular(widthScreen * 0.08),
                          ),
                          child: Row(
                            children: [
                            const Icon(Icons.search),
                              const SizedBox(
                                width: 6,
                              ),
                              Expanded(
                                child: TextField(
                                  // keyboardType: TextInputType.text,
                                  onSubmitted: (value){
                                    setState(() {
                                      _searchQuery = value;
                                      fetchArticles(filter: _searchQuery);
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Search",
                                    border: InputBorder.none,
                                    hintStyle:
                                        GoogleFonts.mulish(color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      
                    ],
                  ),
                ),

                // Content
                SizedBox(
                  height: heightScreen * 0.03,
                ),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: widthScreen * 0.04),
                    child: Row(
                      children: [
                        Text(
                          'Daftar Artikel',
                          style: GoogleFonts.mulish(
                              color: blackText,
                              fontWeight: textBold,
                              fontSize: font16),
                        ),
                      ],
                    ),
                  ),

                SizedBox(
                  height: heightScreen * 0.02,
                ),
                
                Expanded(
                  child: FutureBuilder(
                    future: _searchQuery.isNotEmpty ? fetchArticles(filter: _searchQuery) : fetchArticles(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: greenSolid,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Column(
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
                        );
                      } else if (snapshot.hasData) {
                        final data = snapshot.data;
                        return RefreshIndicator(
                          onRefresh: _refresh,
                          child: ListView.builder(
                            itemCount: data!.length,
                            itemBuilder: (context, index) {
                              final item = data[index];
                              final title = item['title'];
                              final cover = item['cover'];
                              final subject = item['subject'];
                              final createdAt = item['created_at'];
                              String originalDateTime = createdAt;
                              String formattedDateTime = formatDateTime(originalDateTime);
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return Article_Screens(articleData: item['id']);
                                  }));
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: widthScreen * 0.04, vertical:  widthScreen * 0.02),
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
                                                image:  cover != null
                                                          ? NetworkImage(
                                                              '${ApiURL.apiUrl}/storage/$cover')
                                                          : const AssetImage(
                                                                  'assets/img/DefaultCoverBook.png')
                                                              as ImageProvider,fit: BoxFit.cover),
                                            borderRadius:
                                                BorderRadius.circular(8)),
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
                                              '$subject',
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
                                              '$formattedDateTime',
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
                          ),
                        );
                      } else {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 14),
                                child: Text(
                                  'Tidak menemukan article...',
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
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => const CreateArticle())));
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(greenSolid),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.all(4),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(90),
              ),
            ),
          ),
          child: Container(
            width: widthScreen * 0.35,
            height: widthScreen * 0.1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_circle_rounded),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Buat Artikel',
                  style: GoogleFonts.mulish(fontWeight: textBold),
                )
              ],
            ),
          ),
        ));
  }

  Future? articleList;

  Future<void> _refreshData() async {
    setState(() {
      articleList = fetchArticles();
    });
  }
}
