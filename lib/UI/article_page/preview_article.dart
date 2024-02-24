import 'dart:convert';

import 'package:consume_api/UI/article_page/update_article.dart';
import 'package:consume_api/data/data.dart';
import 'package:consume_api/methods/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreviewArticle extends StatefulWidget {
  final articleId;
  const PreviewArticle({super.key, required this.articleId});

  @override
  State<PreviewArticle> createState() => _PreviewArticleState();
}

String formatDateTime(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  final DateFormat formatter = DateFormat('dd MMMM yyyy, HH:mm');
  String formattedDate = formatter.format(dateTime);

  // Ubah timezone ke WIB (Waktu Indonesia Barat)
  formattedDate += ' WIB';
  return formattedDate;
}

class _PreviewArticleState extends State<PreviewArticle> {
  Future<List> fetchArticleById() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final userId = pref.getInt('id');
    final response = await API().getRequest(
      route: '/previewArticleByUserId/${widget.articleId}/$userId',
    );

    if (response.statusCode == 200) {
      final articles = json.decode(response.body);
      print('cekl $articles');
      return articles;
    } else {
      // Jika terjadi masalah saat mengambil data
      throw Exception('Failed to load article user');
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    double font12 = widthScreen * 0.03;
    double font14 = widthScreen * 0.038;
    double font16 = widthScreen * 0.043;
    double font18 = widthScreen * 0.048;
    double font22 = widthScreen * 0.055;
    return Scaffold(
        body: Stack(
      children: [
        FutureBuilder(
          future: fetchArticleById(),
          builder: (context, snapshot) {
            final data = snapshot.data;
            final cover = data?[0]['cover'];
            print('cover: $cover');
            return Container(
              width: widthScreen,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: cover != null
                          ? NetworkImage('${ApiURL.apiUrl}/storage/$cover')
                          : const AssetImage('assets/img/bg-blueCircle.png')
                              as ImageProvider,
                      fit: BoxFit.cover)),
            );
          },
        ),
        Column(children: [
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: heightScreen * 0.1,
            title: Container(
              alignment: Alignment.center,
              child: Text(
                'Artikel',
                style: GoogleFonts.mulish(
                    fontWeight: textExtra, fontSize: font22, color: whiteText),
              ),
            ),
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                (Icons.keyboard_arrow_left_rounded),
              ),
            ),
            actions: [
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(12)),
                child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert_rounded)),
              )
            ],
          ),
          SizedBox(
            height: heightScreen * 0.05,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: widthScreen * 0.04),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: whiteText,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(40, 0, 0, 20),
                    offset: Offset(0, -4), // Y-offset of -2
                    blurRadius: 2, // Optional blur radius
                    spreadRadius: 0, // Optional spread radius
                  ),
                ],
              ),
              child: FutureBuilder(
                future: fetchArticleById(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Text('Sedang memuat artikel'));
                  } else if (snapshot.hasError) {
                    print(snapshot);
                    return const Center(
                      child: Text('Gagal memuat!'),
                    );
                  } else if (snapshot.hasData) {
                    final data = snapshot.data!;
                    final datas = data[0];
                    String title = datas['title'];
                    String subject = datas['subject'];
                    String body = datas['body'];
                    String created_at = datas['created_at'];
                    String message = datas['message'] ?? '';
                    String author = datas['author'];
                    String originalDateTime = created_at;
                    String formattedDateTime = formatDateTime(originalDateTime);
                    return ListView(
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.mulish(
                              height: 1,
                              fontWeight: textExtra,
                              fontSize: font22),
                        ),
                        SizedBox(
                          height: widthScreen * 0.04,
                        ),
                        Text(
                          'Author: ${author}',
                          style: GoogleFonts.mulish(
                              fontWeight: textMedium,
                              fontSize: font12,
                              color: blackText),
                        ),
                        SizedBox(
                          height: widthScreen * 0.02,
                        ),
                        Container(
                          child: Row(
                            children: [
                              Text(
                                '${subject} ',
                                style: GoogleFonts.mulish(
                                    fontWeight: textBold,
                                    fontSize: font12,
                                    color: blackText),
                              ),
                              Text(
                                '- $formattedDateTime',
                                style: GoogleFonts.mulish(
                                    fontWeight: textMedium,
                                    fontSize: font12,
                                    color: blackText),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: widthScreen * 0.02,
                        ),
                        ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context, 
                                  MaterialPageRoute(builder: (context) => UpdateArticle(articleData: datas),));
                                }, 
                                child: const Text('Edit')
                            ),
                        SizedBox(
                          height: widthScreen * 0.06,
                        ),
                        HtmlWidget(
                          '${body}',
                          textStyle: GoogleFonts.mulish(
                            height: 1.5,
                          ),
                        ),
                        SizedBox(
                          height: widthScreen * 0.02,
                        ),
                        Text(
                          'Respon Dosen: $subject' ?? '',
                          style: GoogleFonts.mulish(
                            color: outlineInput,
                            fontSize: font12,
                          ),
                        ),
                        Text('$message'),
                        SizedBox(
                          height: widthScreen * 0.2,
                        ),
                      ],
                    );
                  } else {
                    throw Exception('Error Connection');
                  }
                },
              ),
            ),
          )
        ]),
      ],
    ));
  }

  Future<void> _refreshData() async {
    await fetchArticleById();
  }
}
