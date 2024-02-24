import 'dart:convert';

import 'package:consume_api/data/data.dart';
import 'package:consume_api/methods/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Article_Screens extends StatefulWidget {
  final articleData;
  const Article_Screens({super.key, required this.articleData});

  @override
  State<Article_Screens> createState() => _Article_ScreensState();
}

String formatDateTime(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  final DateFormat formatter = DateFormat('dd MMMM yyyy, HH:mm');
  String formattedDate = formatter.format(dateTime);

  // Ubah timezone ke WIB (Waktu Indonesia Barat)
  formattedDate += ' WIB';
  return formattedDate;
}

class _Article_ScreensState extends State<Article_Screens> {
  Future<List> fetchArticleById() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final studentId = pref.getInt('student_id');
    final response = await API().getRequest(
      route: '/getArticleById/${widget.articleData}?student_id=$studentId',
    );

    if (response.statusCode == 200) {
      final List<dynamic> articles = json.decode(response.body);
      return articles;
    } else {
      // Jika terjadi masalah saat mengambil data
      throw Exception('Failed to load article');
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
                          : const AssetImage('assets/img/tesImage (2).jpg')
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
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20) ),
                color: whiteText,
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
                        Row(
                          children: [
                            Text(
                              '${subject} ',
                              style: GoogleFonts.mulish(
                                  fontWeight: textBold,
                                  fontSize: font12,
                                  color: blackText),
                            ),
                            Text(
                              '- ${formattedDateTime}',
                              style: GoogleFonts.mulish(
                                  fontWeight: textMedium,
                                  fontSize: font12,
                                  color: blackText),
                            ),
                          ],
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
