import 'package:consume_api/UI/login_user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../data/data.dart';

class OnBoardingScreens extends StatefulWidget {
  const OnBoardingScreens({super.key});

  @override
  State<OnBoardingScreens> createState() => _OnBoardingScreensState();
}

class _OnBoardingScreensState extends State<OnBoardingScreens> {
// controller buat tracking onboarding
  final _controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth * 0.8;

    double screenHeight = MediaQuery.of(context).size.height;
    double containerHeight = screenHeight * 0.42;


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
            child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/bg-onboard.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.045),
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    _controller.jumpToPage(2);
                  },
                  child: Text(
                    'SKIP',
                    style: GoogleFonts.mulish(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        fontSize: 14),
                  ),
                ),
              ),
              Container(
                width: screenWidth * 0.6,
                height: screenWidth * 0.6,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/img/logo-mathwiz.png'))),
              ),
              Container(
                alignment: const Alignment(0, 0.75),
                width: containerWidth,
                height: containerHeight,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: MediaQuery.of(context).size.height * 0.055),
                decoration: BoxDecoration(
                  gradient: blueGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    SmoothPageIndicator(
                        controller: _controller,
                        count: 3,
                        effect: const ExpandingDotsEffect(
                          activeDotColor: Colors.green, // Warna dot aktif
                          dotColor: Colors.white, // Warna dot non-aktif
                          dotHeight: 10, // Tinggi dot
                          dotWidth: 10, // Lebar dot
                          spacing: 8, // Jarak antara dot
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: 
                         PageView(
                          controller: _controller,
                          onPageChanged: (index) {
                            setState(() {
                              onLastPage = (index == 2);
                              print("onPageChanged: $index, onLastPage: $onLastPage");
                            });
                          },
                          children: [
                            Container(
                                child: Column(
                              children: [
                                Text(
                                  'Selamat datang',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.mulish(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.03,
                                ),
                                Container(
                                  child: Text(
                                    'Selamat datang di aplikasi Mathwiz, Aplikasi Pembelajaran Mahasiswa Universitas Islam Nusantara',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.mulish(
                                      color: Colors.white,
                                      fontSize: MediaQuery.of(context).size.width * 0.04,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                            Container(
                                child: Column(
                              children: [
                                Text(
                                  'Registrasi',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.mulish(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.03,
                                ),
                                Container(
                                  child: Text(
                                    'Sebelum memulai pembelajaran daftarkan akunmu terlebih dahulu di menu Daftar pada tampilan Login',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.mulish(
                                      color: Colors.white,
                                      fontSize: MediaQuery.of(context).size.width * 0.04,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                            Container(
                                child: Column(
                              children: [
                                Text(
                                  'Login',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.mulish(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.03,
                                ),
                                Container(
                                  child: Text(
                                    'Jika sudah mendaftarkan akun, silahkan tunggu konfirmasi dari admin kampus untuk memberi akses Login ',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.mulish(
                                      color: Colors.white,
                                      fontSize: MediaQuery.of(context).size.width * 0.04,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                          ],
                        ),
                      ),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(40.0), // Radius 40
                            child: ElevatedButton(
                              onPressed: () {
                                if (onLastPage != false) {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const LoginScreen();
                                  }));
                                } else {
                                  _controller.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeIn,
                                  );
                                }
                              },
                               style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  onLastPage ? 'Selesai' : 'Selanjutnya',
                                  style: GoogleFonts.mulish(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                               const Icon(Icons.arrow_forward_ios_rounded),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        onLastPage = (_controller.page == 2);
      });
    });
  }
}
