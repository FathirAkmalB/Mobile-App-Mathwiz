import 'dart:async';
import 'dart:convert';
import 'package:consume_api/UI/exam_page/result_exam.dart';
import 'package:consume_api/methods/api.dart';
import 'package:flutter/material.dart';
import 'package:consume_api/data/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExamScreens extends StatefulWidget {
  final studentId;
  final exam;
  const ExamScreens({super.key, required this.exam, required this.studentId});

  @override
  State<ExamScreens> createState() => _ExamScreens();
}

class _ExamScreens extends State<ExamScreens> {
  initState() {
    super.initState();
    checkAttempt(); // Check is user has attempt or not
    startCountdown(); // setelah variabel duration di re-value barulah countDown dimulai.

  }

  late Timer _timer; // define variable for timer param
  int duration = 0; // define variable for duration from api
  late int countdown = duration * 60; // define variable for counting duration from api

  void startCountdown() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (countdown < 1) {
          postExam();
          _timer.cancel(); // Countdown selesai, hentikan timer
        } else {
          countdown -= 1; // Kurangi satu detik dari countdown
        }
      });
    });
  }

  Map<int, String> submittedAnswers = {}; // Saving every answer

  String examTitle = '';

  List dataQuestions = []; // Data of Question
  int currentIndex = 0; // For knowing the current index
  bool limitIndex = false; // For controlling the button
  int totalQuestions = 0;

  Future<Map> checkAttempt() async {
    final response = await API().getRequest(route: '/checkAttemptForExam/${widget.exam['id']}/${widget.studentId}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final durationString = data['duration'];
      int minutes = durationString * 60;
      setState(() {
        duration = minutes;
        countdown = duration;
        examTitle = data['exam_title'];
        totalQuestions = data['total_questions'];
        dataQuestions = data['dataQuestions'];
      });      
      
      return {
        'duration': duration,
        'totalQuestions': totalQuestions,
        'dataQuestions': dataQuestions,
      };
    } else {
      throw Exception('Gagal mengambil data dari API Chapter');
    }
  }

  Future<void> postExam() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final studentId = pref.getInt('student_id');

    if (studentId == null) {
      print('Student ID is null. Please make sure you have a valid ID in SharedPreferences.');
      return;
    }

    Map<String, String> submittedAnswersAsString = Map.from(
        submittedAnswers.map((key, value) => MapEntry(key.toString(), value)));

    final Map<String, dynamic> data = {
      'student_id': studentId,
      'submitted_answer': submittedAnswersAsString,
    };

    final response = await API()
        .postRequest(route: '/takeExam/${widget.exam['id']}', data: data);

    // Check the response status code.
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Exam Submitted Successfully: $responseData');
   // ignore: use_build_context_synchronously
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ResultExam(examID: widget.exam['id'], studentId: studentId),
        ));
    } else {
      final errorResponse = json.decode(response.body);
      if (errorResponse.containsKey('message')) {
        print('Server Error Message: ${errorResponse['message']}');
      }
    }

    print('SubmittedAnswers: $submittedAnswers');

  }

  void updateSubmittedAnswer(int questionId, String answer) {
    setState(() {
      submittedAnswers[questionId] = answer;
    });
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    double font14 = widthScreen * 0.038;
    double font12 = widthScreen * 0.035;
    double font22 = widthScreen * 0.055;

    int hours = (countdown / 3600).floor();
    int minutes = ((countdown % 3600) / 60).floor();
    int seconds = countdown % 60;

    String formattedTime = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/img/bg-blueCircle.png'),
                  fit: BoxFit.cover),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  toolbarHeight: heightScreen * 0.1,
                  automaticallyImplyLeading: false,
                  leading: Container(),
                  title: Container(
                    alignment: Alignment.center,
                    child: Text(
                      examTitle,
                      style: GoogleFonts.mulish(
                          fontWeight: textExtra, fontSize: widthScreen * 0.055),
                    ),
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.notifications_active,
                          color: Colors.transparent,
                        ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        width: widthScreen * 0.25,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                            color: redSolid,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          formattedTime,
                          style: GoogleFonts.mulish(
                              fontSize: font14,
                              fontWeight: FontWeight.normal,
                              color: whiteText),
                        )),
                  ],
                ),
                SizedBox(height: widthScreen * 0.05),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: widthScreen * 0.08,
                    vertical: widthScreen * 0.08,
                  ),
                  decoration: BoxDecoration(
                    color: whiteText,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(widthScreen * 0.08),
                      topRight: Radius.circular(widthScreen * 0.08),
                    ),
                  ),
                  child: Column(children: [
                    Expanded(
                        child: ListView.builder(
                      itemCount: dataQuestions.length,
                      itemBuilder: (context, index) {
                        var questionNumber = index + 1;
                        var question = dataQuestions[index];
                        final questionId = question['question_id'];
                        final answerQuestion = submittedAnswers[questionId];
                        if (currentIndex == index) {
                          return ExamFormItem(
                            questionNumber: questionNumber,
                            totalQuestions: totalQuestions,
                            answerQuestion: answerQuestion,
                            question: question,
                            onAnswerChanged: (value) {
                              updateSubmittedAnswer(questionId, value);
                            },
                          );
                        }
                        return SizedBox.shrink();
                      },
                    ))
                  ]),
                )),
                Container(
                  padding: const EdgeInsets.only(bottom: 30),
                  color: whiteText,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      currentIndex != 0
                          ? ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(blueText),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(90),
                                  ),
                                ),
                                padding: MaterialStateProperty.all<
                                        EdgeInsetsGeometry>(
                                    const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 4)),
                              ),
                              onPressed: () {
                                setState(() {
                                  if (currentIndex > 0) {
                                    currentIndex--;
                                    limitIndex = false;
                                  }
                                });
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.skip_previous_rounded),
                                  Text(limitIndex ? 'Sebelumnya' : ''),
                                ],
                              ))
                          : Container(),
                      const SizedBox(width: 10),
                      !(currentIndex == totalQuestions - 1)
                          ? ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(blueText),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(90),
                                  ),
                                ),
                                padding: MaterialStateProperty.all<
                                        EdgeInsetsGeometry>(
                                    const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 4)),
                              ),
                              onPressed: () {
                                setState(() {
                                  currentIndex++;
                                  if (currentIndex >= totalQuestions - 1) {
                                    setState(() {
                                      limitIndex = true;
                                    });
                                  }
                                });
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(limitIndex ? '' : 'Selanjutnya'),
                                  Icon(Icons.skip_next_rounded),
                                ],
                              ),
                            )
                          : ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        greenSolid),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(90),
                                  ),
                                ),
                                padding: MaterialStateProperty.all<
                                        EdgeInsetsGeometry>(
                                    const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 4)),
                              ),
                              onPressed: () {
                                submittedAnswers.length == dataQuestions.length
                                    ? showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                              'Kirim Sekarang?',
                                              style: GoogleFonts.mulish(
                                                  color: greenSolid,
                                                  fontWeight: textBold,
                                                  fontSize: font22),
                                            ),
                                            content: const Text(
                                                'Tenang, semua sudah terjawab!'),
                                            titleTextStyle: GoogleFonts.mulish(
                                                color: subTitle,
                                                fontWeight: textMedium,
                                                fontSize: font12),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  'Batal',
                                                  style: GoogleFonts.mulish(
                                                      color: subTitle,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              TextButton(
                                                  onPressed: () {
                                                    postExam();
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12),
                                                    decoration: BoxDecoration(
                                                        color: greenSolid,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6)),
                                                    child: Text(
                                                      'Kirim',
                                                      style: GoogleFonts.mulish(
                                                          color: whiteText,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ))
                                            ],
                                          );
                                        },
                                      )
                                    : submittedAnswers.isEmpty
                                        ? showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text(
                                                  'Gagal mengirim!',
                                                  style: GoogleFonts.mulish(
                                                      color: greenSolid,
                                                      fontWeight: textBold,
                                                      fontSize: font22),
                                                ),
                                                content: const Text(
                                                    'kamu belum mengisi apapun!'),
                                                titleTextStyle:
                                                    GoogleFonts.mulish(
                                                        color: subTitle,
                                                        fontWeight: textMedium,
                                                        fontSize: font12),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text(
                                                      'Lanjutkan',
                                                      style: GoogleFonts.mulish(
                                                          color: greenSolid,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          )
                                        : showDialog(
                                            context: context,
                                            builder: (context) {
                                              var questionEmpty =
                                                  dataQuestions.length -
                                                      submittedAnswers.length;

                                              return AlertDialog(
                                                title: Text(
                                                  'Kirim Sekarang?',
                                                  style: GoogleFonts.mulish(
                                                      color: greenSolid,
                                                      fontWeight: textBold,
                                                      fontSize: font22),
                                                ),
                                                content: Text(
                                                    'Ada $questionEmpty dari $totalQuestions soal yang belum dikerjakan. Apakah Yakin ingin mengakhiri?'),
                                                titleTextStyle:
                                                    GoogleFonts.mulish(
                                                        color: subTitle,
                                                        fontWeight: textMedium,
                                                        fontSize: font12),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text(
                                                      'Lanjutkan',
                                                      style: GoogleFonts.mulish(
                                                          color: greenSolid,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(!limitIndex ? '' : 'Kirim Jawaban'),
                                  Icon(
                                    Icons.send,
                                    size: font14,
                                  ),
                                ],
                              ),
                            )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        // Soal End
      ),
    );
  }
}

class ExamFormItem extends StatefulWidget {
  final dynamic questionNumber;
  final dynamic totalQuestions;
  final dynamic question;
  final answerQuestion;
  final Function(String) onAnswerChanged;

  ExamFormItem({
    required this.questionNumber,
    required this.answerQuestion,
    required this.totalQuestions,
    required this.question,
    required this.onAnswerChanged,
  });

  @override
  _ExamFormItemState createState() => _ExamFormItemState();
}

class _ExamFormItemState extends State<ExamFormItem> {
  TextEditingController answerController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    double font12 = widthScreen * 0.035;
    double font22 = widthScreen * 0.055;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Soal Nomor ${widget.questionNumber} dari ${widget.totalQuestions}',
            style: GoogleFonts.mulish(
              fontWeight: textBold,
              fontSize: font22,
              color: blackText,
            ),
          ),
          SizedBox(height: heightScreen * 0.02),
          HtmlWidget(widget.question['question_title']),
          SizedBox(height: heightScreen * 0.025),
          Text(
            '*Masukkan jawaban akhir.',
            style: GoogleFonts.mulish(
              fontSize: font12,
              color: redSolid,
              fontWeight: textMedium,
            ),
          ),
          SizedBox(height: heightScreen * 0.01),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            height: widthScreen * 0.18,
            decoration: BoxDecoration(
              color: whiteText,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 2, color: hintText),
            ),
            child: TextFormField(
              enabled: true,
              controller: answerController,
              keyboardType: TextInputType.text,
              onChanged: (value) {
                widget.onAnswerChanged(value);
              },
              style: GoogleFonts.mulish(
                color: blackText,
                fontSize: 14,
                fontWeight: textMedium,
              ),
              decoration: InputDecoration(
                hintText: widget.answerQuestion != null
                    ? '${widget.answerQuestion}'
                    : 'Masukkan jawaban mu disini...',
                hintStyle: GoogleFonts.mulish(
                  fontSize: font12,
                  fontWeight: FontWeight.w400,
                  color: blackText,
                ),
                filled: true,
                fillColor: Colors.transparent,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
