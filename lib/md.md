PageView(
controller: \_controller,
children: [
Container(
// Page View
color: Color.fromARGB(255, 50, 145, 54),
),
Container(
color: Color.fromARGB(255, 83, 50, 145),
),
Container(
color: Color.fromARGB(255, 50, 67, 145),
),
Container(
color: Color.fromARGB(255, 145, 50, 50),
),
],
),
Positioned(
bottom: screenHeight \* 0.1, // Jarak dari bawah
left: (screenWidth - containerWidth) / 5, // Untuk posisi horizontal di tengah
child: Container(
width: containerWidth,
height: containerHeight,
margin: EdgeInsets.symmetric(horizontal: 20),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(16),
),
child: SmoothPageIndicator(controller: \_controller, count: 3),

                ),
        )



























        import 'package:flutter/material.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreeens extends StatefulWidget {
const OnBoardingScreeens({super.key});

@override
State<OnBoardingScreeens> createState() => \_OnBoardingScreeensState();
}

class \_OnBoardingScreeensState extends State<OnBoardingScreeens> {
// controller buat tracking onboarding
final PageController \_controller = PageController();

@override
Widget build(BuildContext context) {
double screenWidth = MediaQuery.of(context).size.width;
double containerWidth = screenWidth \* 0.8;

    double screenHeight = MediaQuery.of(context).size.height;
    double containerHeight = screenHeight * 0.45;

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Stack(
            children: <Widget>[
              // Konten lainnya di sini
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.green,
                // child: Image.asset('img/vectorr36.png')
              ),
              Positioned(
                bottom: screenHeight * 0.1, // Jarak dari bawah
                left: (screenWidth - containerWidth) /
                    5, // Untuk posisi horizontal di tengah
                child: Container(
                  width: containerWidth,
                  height: containerHeight,
                  padding: EdgeInsets.symmetric(vertical: 65),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      // Sesuaikan jumlah halaman dengan PageView
                      SmoothPageIndicator(
                        controller: _controller,
                        count: 3, // Sesuaikan dengan jumlah halaman
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        // Biarkan PageView mengisi tinggi yang tersedia
                        child: PageView(
                          controller: _controller,
                          children: [
                            Container(
                              // Tinggi konten akan disesuaikan oleh PageView
                              child: Column(
                                children: [
                                  Text(
                                    'Onboarding',
                                    style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 25,),
                                  Text(
                                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sit adipiscing sit enim enim id iaculis tristique. ',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              // Tinggi konten akan disesuaikan oleh PageView
                              child: Column(
                                children: [
                                  Text(
                                    'Onboarding',
                                    style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 25,),
                                  Text(
                                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sit adipiscing sit enim enim id iaculis tristique. ',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              // Tinggi konten akan disesuaikan oleh PageView
                              child: Column(
                                children: [
                                  Text(
                                    'Onboarding',
                                    style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 25,),
                                  Text(
                                    'Paragraf 3',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(onPressed: (){}, child: Text('Next'))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

}
}

TextFormField(
style: GoogleFonts.lato(
fontSize: MediaQuery.of(context).size.width _ 0.039,
),
decoration: InputDecoration(
hintText: 'Masukkan nama terakhir',
hintStyle: GoogleFonts.lato(
fontSize:
MediaQuery.of(context).size.width _ 0.028,
color: hintText,
),
enabledBorder: OutlineInputBorder(
borderSide: const BorderSide(
color: Color(0xFFE2E2E2),
width: 1,
),
borderRadius: BorderRadius.circular(
MediaQuery.of(context).size.width _ 0.022),
),
focusedBorder: OutlineInputBorder(
borderSide: const BorderSide(
color: Color.fromARGB(255, 155, 155, 155),
width: 1,
),
borderRadius: BorderRadius.circular(
MediaQuery.of(context).size.width _ 0.022),
),

                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 17,
                                vertical: 17), // Atur tinggi input teks di sini
                          ),
                        ),









































                        title: Text(subject['title'] as String), // Menggunakan kunci yang sesuai
              subtitle: Text(subject['description'] as String),









                      Container(
                      padding: EdgeInsets.only(left: 12),
                      height: widthScreen * 0.4,
                      width: widthScreen,
                      decoration: BoxDecoration(
                          color: blueText,
                          borderRadius: BorderRadius.circular(16)),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: widthScreen * 0.04,
                            vertical: widthScreen * 0.02),
                        decoration: BoxDecoration(
                            color: inputLogin,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(16),
                                bottomRight: Radius.circular(16))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.subject['title'].toString()} - Bab 1',
                              style: GoogleFonts.mulish(
                                  fontWeight: textExtra, fontSize: 14),
                            ),
                            Text(
                              '4 Sub Topik',
                              style: GoogleFonts.mulish(
                                  fontWeight: textExtra, fontSize: 14),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                LinearPercentIndicator(
                                  width: widthScreen * 0.65,
                                  lineHeight: 12,
                                  percent: 0.5,
                                  progressColor: blueText,
                                  backgroundColor: progressBar,
                                ),
                                SizedBox(
                                  width: widthScreen * 0.02,
                                ),
                                Text('50%')
                              ],
                            ),
                            Container(
                                alignment: Alignment.topLeft,
                                child: InkWell(
                                    onTap: () {},
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 35,
                                          height: 35,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 8),
                                          decoration: BoxDecoration(
                                              color: greenSolid,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Center(
                                            child: Icon(
                                              Icons.play_arrow,
                                              color: whiteText,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: widthScreen * 0.025,
                                        ),
                                        Text(
                                          'Lihat Penjelasan',
                                          style: GoogleFonts.mulish(
                                              fontSize: 14,
                                              color: greenSolid,
                                              fontWeight: textBold),
                                        )
                                      ],
                                    )
                                    // child: ,
                                    )),
                          ],
                        ),
                      )),



                  ${(chapter['progress'] * 100).toStringAsFixed(0)}

                  ${chapter['chapter'].length} Sub Topik

                  ${chapter['title'].toString()} - Bab ${chapter['bab'].toString()}



















                    // Future uploadAvatar(File imageFile) async {

// var stream =
// new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
// var length = await imageFile.length();
// var uri = Uri.parse(
// 'https://6283-180-245-53-221.ngrok-free.app/api/registerStudent');

// var request = http.MultipartRequest("POST", uri);
// var multipartFile =
// http.MultipartFile("avatar", stream, length, filename: imageFile.path);

// request.files.add(multipartFile);
// var response = await request.send();
// if (response.statusCode == 200) {
// print('uploaded');
// }else{
// print('failed');
// }
// }

final data = snapshot.data;
final semesterEnum =
data?[0]['semester'];
String semesterText = '';

                                          if (semesterEnum == 'ganjil') {
                                            semesterText = 'Semester Ganjil';
                                          } else if (semesterEnum == 'genap') {
                                            semesterText = 'Semester Genap';
                                          }

                                          return Text(
                                            semesterText,
                                            maxLines: 1,
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.mulish(
                                              color: greenSolid,
                                              fontWeight: textBold,
                                              fontSize: 16,
                                            ),
                                          );

final data = snapshot.data;
final description =
data?[0]['description'];
return Text(
description,
style: GoogleFonts.mulish(
color: subTitle,
fontSize: 12),
);

                                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  height: widthScreen * 0.35,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2, color: outlineInput),
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Row(
                                    children: [
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
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  8),
                                                          topRight:
                                                              Radius.circular(
                                                                  8))),
                                            ),
                                            Container(
                                              alignment: Alignment.bottomCenter,
                                              width: widthScreen * 0.16,
                                              height: widthScreen * 0.24,
                                              decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/img/coverBook.png'),
                                                      fit: BoxFit.cover)),
                                            ),
                                            Container(
                                              alignment: Alignment.bottomCenter,
                                              width: widthScreen * 0.20,
                                              height: widthScreen * 0.045,
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
                                                              Radius.circular(
                                                                  8),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  8))),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: widthScreen * 0.04),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            'Geometry',
                                            style: GoogleFonts.mulish(
                                              fontSize: font16,
                                              fontWeight: textExtra,
                                              color: blackText,
                                            ),
                                          ),
                                          Text(
                                            'Dr. Dosen Doktor S.Pd',
                                            style: GoogleFonts.mulish(
                                                fontSize: font12,
                                                fontWeight: textBold,
                                                color: greenSolid),
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.assignment_outlined,
                                                size: 20,
                                                color: blueText,
                                              ),
                                              SizedBox(
                                                width: widthScreen * 0.01,
                                              ),
                                              Text(
                                                '(3 Paket Soal Ujian)',
                                                style: GoogleFonts.mulish(
                                                    fontWeight: textMedium,
                                                    fontSize: 12,
                                                    color: outlineInput),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_month_outlined,
                                                size: 20,
                                                color: blueText,
                                              ),
                                              SizedBox(
                                                width: widthScreen * 0.01,
                                              ),
                                              Text(
                                                '30 Oktober 2023',
                                                style: GoogleFonts.mulish(
                                                    fontWeight: textMedium,
                                                    fontSize: 12,
                                                    color: outlineInput),
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: heightScreen * 0.02,
                                );










  GestureDetector(
                                child: Container(
                                    width: widthScreen * 0.9,
                                    margin: const EdgeInsets.only(bottom: 20),
                                    height: widthScreen * 0.4,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 18),
                                    decoration: BoxDecoration(
                                      color: searchBar,
                                      borderRadius: BorderRadius.circular(16),
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
                                                      'assets/img/UjianIcon.png'))),
                                        ),
                                        SizedBox(
                                          width: widthScreen * 0.02,
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    width: widthScreen * 0.44,
                                                    child: Text(
                                                      'Numeracy and Arithmetic',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.mulish(
                                                        fontWeight: textExtra,
                                                        fontSize: font14,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    ' Ujian hari ini',
                                                    style: GoogleFonts.mulish(
                                                        fontWeight: textMedium,
                                                        fontSize: 14,
                                                        color: redSolid),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                'Tenggat',
                                                style: GoogleFonts.mulish(
                                                  fontWeight: textMedium,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  LinearPercentIndicator(
                                                    width: widthScreen * 0.58,
                                                    lineHeight: 12,
                                                    percent:
                                                        0.25, // Ganti dengan data persentase jika tersedia
                                                    progressColor: blueText,
                                                    backgroundColor:
                                                        progressBar,
                                                  ),
                                                  SizedBox(
                                                      width:
                                                          widthScreen * 0.02),
                                                  Text(
                                                    '20%',
                                                    style: GoogleFonts.mulish(
                                                        fontSize: font12,
                                                        color: blackText,
                                                        fontWeight: textBold),
                                                  )
                                                ],
                                              ),
                                              Container(
                                                alignment: Alignment.topLeft,
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                Ujian_Screens(
                                                                    // chapter: chapter,
                                                                    )));
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
                                                                  .circular(20),
                                                        ),
                                                        child: Center(
                                                          child: Icon(
                                                            Icons.play_arrow,
                                                            color: whiteText,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          width: widthScreen *
                                                              0.025),
                                                      Text(
                                                        'Mulai Materi',
                                                        style:
                                                            GoogleFonts.mulish(
                                                          fontSize: 14,
                                                          color: greenSolid,
                                                          fontWeight: textBold,
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
                                    )),
                              ),
                             


Container(
                          width: widthScreen * 0.9,
                          margin: EdgeInsets.only(top: widthScreen * 0.05),
                          alignment: Alignment.topLeft,
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
                                              topRight: Radius.circular(8))),
                                    ),
                                    Container(
                                      alignment: Alignment.bottomCenter,
                                      width: widthScreen * 0.24,
                                      height: widthScreen * 0.35,
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/img/coverBook.png'),
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
                                              offset: Offset(
                                                  0, -1), // Y-offset of -2
                                              blurRadius:
                                                  2, // Optional blur radius
                                              spreadRadius:
                                                  0, // Optional spread radius
                                            ),
                                          ],
                                          color: greenSolid,
                                          borderRadius: const BorderRadius.only(
                                              bottomLeft: Radius.circular(12),
                                              bottomRight:
                                                  Radius.circular(12))),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: widthScreen * 0.04,
                              ),

                              // Title Materi
                              FutureBuilder(
                                  future: fetchSubjects(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Center(
                                          child: Text(
                                              'Error: ${snapshot.error.toString()}'));
                                    } else if (snapshot.hasData) {
                                      final data = snapshot.data as Map<String, dynamic>;
                                      final semesterText = data['dataSubjects']['semester'];
                                      final description = data['dataSubjects']['description'];
                                      final cover = data['dataSubjects']['cover'];
                                      return Container(
                                        alignment: Alignment.topLeft,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              // semester
                                              semesterText,
                                              maxLines: 1,
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.mulish(
                                                  color: greenSolid,
                                                  fontWeight: textBold,
                                                  fontSize: 16),
                                            ),
                                            SizedBox(
                                              height: heightScreen * 0.01,
                                            ),
                                            Container(
                                              width: widthScreen * 0.48,
                                              child: RichText(
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 6,
                                                text: TextSpan(
                                                  text: description,
                                                  style: GoogleFonts.mulish(
                                                      color: subTitle,
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: heightScreen * 0.01,
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return Text('Gagal mendapatkan data');
                                    }
                                  })
                            ],
                          ),
                        ),














                           Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                'Soal Nomor 1',
                                style: GoogleFonts.mulish(
                                    fontWeight: textBold,
                                    fontSize: font22,
                                    color: blackText),
                              ),
                            ),
                            SizedBox(
                              height: heightScreen * 0.02,
                            ),
                            Container(
                              child: HtmlWidget('halo'),
                            ),
                            SizedBox(
                              height: heightScreen * 0.02,
                            ),
                            Container(
                                child: Text(
                              '*Silakan diisi hanya jawaban terakhirnya saja.',
                              style: GoogleFonts.mulish(
                                  fontSize: font12,
                                  color: redSolid,
                                  fontWeight: textMedium),
                            )),
                            SizedBox(
                              height: heightScreen * 0.02,
                            ),
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 2),
                              height: widthScreen * 0.2,
                              decoration: BoxDecoration(
                                  color: whiteText,
                                  borderRadius: BorderRadius.circular(14),
                                  border:
                                      Border.all(width: 2, color: hintText)),
                              child: TextFormField(
                                style: GoogleFonts.mulish(
                                  color: blackText,
                                  fontSize: 14,
                                  fontWeight: textMedium,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Masukkan jawaban mu disini...',
                                  hintStyle: GoogleFonts.mulish(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.028,
                                      fontWeight: FontWeight.w400,
                                      color: blackText),
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent)),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  