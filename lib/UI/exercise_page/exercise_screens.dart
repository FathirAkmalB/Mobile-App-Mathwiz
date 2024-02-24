import 'package:consume_api/UI/qr_scanner/scanner.dart';
import 'package:consume_api/data/data.dart';
import 'package:consume_api/methods/api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ExerciseScreens extends StatefulWidget {
  final String exerciseId;
  final studentId;

  const ExerciseScreens(
      {super.key,
      required this.exerciseId,
      required this.studentId});

  @override
  State<ExerciseScreens> createState() => _ExerciseScreensState();
}

class _ExerciseScreensState extends State<ExerciseScreens> {
  Map<String, dynamic>? exerciseData;
  Map<int, String> submittedAnswers = {};
  bool? isVisible;
  bool detailBool = false;
  bool has_attempt = false;
  

  @override
  initState(){
    super.initState();
    checkIfStudentAttemptedExercise();
    print('Student: ${widget.studentId}');
    print('ExerciseId: ${widget.exerciseId}');
  }


  Future<Map<String, dynamic>> checkIfStudentAttemptedExercise() async{
     final response = await API().getRequest(route: '/checkAttemptForExercise/${widget.exerciseId}/${widget.studentId}');
     print('status: ${response.statusCode}');
    if (response.statusCode == 200) {
      print('Successfully fetched Exercises');
        final data = json.decode(response.body);
        print('Check Data: $data');
       if (data['has_attempt'] == false) {
        print('Belum Dikerjakan.');
          setState(() {
          exerciseData = data;
          // isVisible = false;
          has_attempt = false;
        });

       }else if(data['has_attempt'] == true){
        print('Sudah Dikerjakan.');
         setState(() {
          exerciseData = data;
          isVisible = true;
          has_attempt = true;
        });
       }
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }


  // Post Submitted Data Start
  Future<void> postExercise() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final studentId = prefs.getInt('student_id');
    print("StudentId: ${studentId}");
    if (studentId == null) {
      print('Student ID is null. Please make sure you have a valid ID in SharedPreferences.');
      return;
    }

    Map<String, String> submittedAnswersAsString = Map.from(submittedAnswers.map((key, value) => MapEntry(key.toString(), value)));

    final Map<String, dynamic> data = {
      'student_id': studentId,
      'submitted_answer': submittedAnswersAsString,
    };

    final response = await API().postRequest(
        route: '/takeExercise/${widget.exerciseId}', data: data);

    // Check the response status code.
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Exercise Submitted Successfully: $responseData');
      checkIfStudentAttemptedExercise();
    } else {
      // Handle the server error.
      print('Exercise Submission Failed. Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      // You can extract and display the server error message from the response, if available.
      final errorResponse = json.decode(response.body);
      if (errorResponse.containsKey('message')) {
        print('Server Error Message: ${errorResponse['message']}');
      }      
    }

    print('SubmittedAnswerss: ${submittedAnswers}');
  }
    void updateSubmittedAnswer(int question_id, String answer) {
    setState(() {
      submittedAnswers[question_id] = answer;
    });
  }
  // Post Submitted End

  // Get API Exercises
  Future<void> getExercisesById(String exercises_id, String student_id) async {
    final response = await API().getRequest(route: '/getExerciseById/$exercises_id');

    try {
     if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('cekcuy: $data');
        setState(() {
          exerciseData = data;
          isVisible = false;
          has_attempt = false;
        });
      }else{
        print('Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('error ${response.statusCode} $e');
    }
  } 

  // Get API Already Exists Start
    Future<void> fetchExerciseHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final studentId = prefs.getInt('student_id');
    final response = await API().getRequest(route: '/getHistoryExerciseById/${widget.exerciseId}/${studentId}');
    try {
      if (response.statusCode == 200) {
        final oldData = json.decode(response.body);
        setState(() {
          exerciseData = oldData;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
  // Get API Already Exists End

  


  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    double font11 = widthScreen * 0.028;
    double font12 = widthScreen * 0.033;
    double font14 = widthScreen * 0.043;
    double font16 = widthScreen * 0.043;
    double font25 = widthScreen * 0.058;
    double font22 = widthScreen * 0.055;

    return Scaffold(
      body: Container(
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
                  exerciseData?['subject'] ?? 'Latihan Soal',
                  style: GoogleFonts.mulish(
                    fontWeight: textExtra,
                    fontSize: font22,
                  ),
                ),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.keyboard_arrow_left_rounded),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert_rounded),
                )
              ],
            ),
            SizedBox(
              height: widthScreen * 0.02,
            ),
            Container(
              width: widthScreen * 0.9,
              height: widthScreen * 0.28,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: whiteText,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: widthScreen * 0.16,
                    height: widthScreen * 0.16,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/img/circleExercise.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: widthScreen * 0.05,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: widthScreen * 0.55,
                        child: Text(
                          exerciseData != null ? '${exerciseData?['exercise_title']}' : 'Soal Latihan',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.mulish(
                            color: blackText,
                            fontWeight: textBold,
                            fontSize: font14,
                          ),
                        ),
                      ),
                      Container(
                        width: widthScreen * 0.5,
                        child: Text(
                          exerciseData != null ? '${exerciseData?['sub_chapter']}' : 'Sub Chapter',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.mulish(
                            fontSize: font12,
                            fontWeight: textMedium,
                            color: subTitle,
                          ),
                        ),
                      ),
                      Container(
                        width: widthScreen * 0.5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: has_attempt ? greenSolid : yellowText,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: has_attempt ? Text(
                                'Sudah Dikerjakan',
                                style: GoogleFonts.mulish(
                                  color: whiteText,
                                  fontSize: font11,
                                ),
                              ) : Text(
                                'Belum Dikerjakan',
                                style: GoogleFonts.mulish(
                                  color: whiteText,
                                  fontSize: font11,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: placeHolder,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: has_attempt != true ?  Text(
                                '${exerciseData?['total_questions'].toString() ?? 'cek'} Soal',
                                style: GoogleFonts.mulish(
                                  color: whiteText,
                                  fontSize: font11,
                                  )
                                )
                                :  Text(
                                'Akurasi ${exerciseData!['total_corrects']}/${exerciseData!['total_questions']}',
                                style: GoogleFonts.mulish(
                                  color: whiteText,
                                  fontSize: font11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: heightScreen * 0.04,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: widthScreen * 0.04),
                decoration: BoxDecoration(
                  color: whiteText,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(widthScreen * 0.08),
                    topRight: Radius.circular(widthScreen * 0.08),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: widthScreen * 0.02,
                    ),
                    Expanded(
                      child: Form(
                        child: exerciseData != null
        ? (() {
            if (has_attempt == false && isVisible == false) { // Belum Dikerjakan
              // Fungsi getExerciseById
              return ListView.builder(
                itemCount: exerciseData!['dataQuestions'].length,
                itemBuilder: (context, index) {
                  final question = exerciseData!['dataQuestions'][index];
                  int questionNumber = index + 1;
                  final question_id = question['question_id'];
                  print('Question Id False: ${question_id}');
                  return ExerciseFormItem(
                    question: question,
                    detailBool: detailBool,
                    isVisible: isVisible,
                    has_attempt: has_attempt,
                    questionNumber: questionNumber,
                    question_id: question_id,
                    exerciseData: exerciseData,
                    total_questions: exerciseData!['total_questions'],
                    widthScreen: widthScreen,
                    onScanPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return QRScanner(
                            link: question['resource'],
                          );
                        },
                      ));
                    },
                    onAnswerChanged: (value) {
                      updateSubmittedAnswer(question_id, value);
                    },
                  );
                },
              );
            } else if (has_attempt == true && isVisible == true) { // Sudah Dikerjakan
              return ListView.builder(
                itemCount: exerciseData!['dataQuestions'].length ?? 0,
                itemBuilder: (context, index) {
                  final question = exerciseData!['dataQuestions'][index];
                  print('question dekk $question');
                  int questionNumber = index + 1;
                  final question_id = question['question_id'];
                  print('Question Id True: ${question_id}');
                  return ExerciseFormItem(
                    question: question,
                    isVisible: isVisible,
                    detailBool: detailBool,
                    has_attempt: has_attempt,
                    questionNumber: questionNumber,
                    question_id: question_id,
                    exerciseData: exerciseData,
                    total_questions: exerciseData!['total_questions'],
                    widthScreen: widthScreen,
                    onScanPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return QRScanner(
                            link: question['resource'],
                          );
                        },
                      ));
                    },
                    onAnswerChanged: (value) {
                      updateSubmittedAnswer(question_id, value);
                    },
                  );
                },
              );
            } else if (has_attempt == false && isVisible == null) {
              print('cek status : $has_attempt');
              return ListView.builder(
                itemCount: exerciseData!['dataQuestions'].length ?? 0,
                itemBuilder: (context, index) {
                  final question = exerciseData!['dataQuestions'][index];
                  int questionNumber = index + 1;
                  final question_id = question['question_id'];
                  return ExerciseFormItem(
                    question: question,
                    isVisible: isVisible,
                    detailBool: detailBool,
                    has_attempt: has_attempt,
                    questionNumber: questionNumber,
                    question_id: question_id,
                    exerciseData: exerciseData,
                    total_questions: exerciseData!['total_questions'],
                    widthScreen: widthScreen,
                    onScanPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return QRScanner(
                            link: question['resource'],
                          );
                        },
                      ));
                    },
                    onAnswerChanged: (value) {
                      updateSubmittedAnswer(question_id, value);
                    },
                  );
                },
              );
            }else{
              return Container();
            }
          })()
        : Center(
            child: CircularProgressIndicator(color: blueText),
          ),
                      ),
                    ),

                   has_attempt == false ? GestureDetector(
                      onTap: () {
                        postExercise();
                      },
                      child: Container(
                        width: widthScreen * 0.4,
                        height: widthScreen * 0.12,
                        margin: EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: blueText,
                          borderRadius: BorderRadius.circular(29),
                        ),
                        child: const Center(
                          child: Text(
                            'Kirim Jawaban',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: widthScreen * 0.4,
                        height: widthScreen * 0.12,
                        margin: EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: blueText,
                          borderRadius: BorderRadius.circular(29),
                        ),
                        child: const Center(
                          child: Text(
                            'Kembali',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        getExercisesById(widget.exerciseId.toString(), widget.studentId);
                      },
                      child: Container(
                        width: widthScreen * 0.4,
                        height: widthScreen * 0.12,
                        margin: EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: greenSolid,
                          borderRadius: BorderRadius.circular(29),
                        ),
                        child: const Center(
                          child: Text(
                            'Coba lagi',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ExerciseFormItem extends StatefulWidget {
  final dynamic question;
  final total_questions;
  final question_id;
  final isVisible;
  bool detailBool;
  final has_attempt;
  final exerciseData;
  final int questionNumber;
  final double widthScreen;
  final Function onScanPressed;
  final Function(String) onAnswerChanged; // Tambahkan callback ini

  ExerciseFormItem({
    required this.question,
    required this.total_questions,
    required this.question_id,
    required this.isVisible,
    required this.detailBool,
    required this.has_attempt,
    required this.exerciseData,
    required this.questionNumber,
    required this.widthScreen,
    required this.onScanPressed,
    required this.onAnswerChanged,
  });

  @override
  _ExerciseFormItemState createState() => _ExerciseFormItemState();
}

class _ExerciseFormItemState extends State<ExerciseFormItem> {
  TextEditingController answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        color: widget.question['is_correct'] == 'Correct' ? greenSolid : widget.question['is_correct'] == 'Not Correct' ? redSolid : blueText,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: widget.widthScreen * 0.04,
          vertical: widget.widthScreen * 0.06,
        ),
        decoration: BoxDecoration(
          color: inputLogin,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nomor ${widget.questionNumber} dari ${widget.total_questions} Soal',
                  style: GoogleFonts.mulish(
                    fontWeight: textExtra,
                    color: widget.question['is_correct'] == 'Correct' ? greenSolid : widget.question['is_correct'] == 'Not Correct' ? redSolid : blueText ,
                    fontSize: 14,
                  ),
                ),
    
               Visibility(
                visible: widget.has_attempt,
                child: widget.question['is_correct'] == 'Correct' ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 6,
                  ),
                  alignment: Alignment.center,
                  height: widget.widthScreen * 0.065,
                  decoration: BoxDecoration(
                    color: greenSolid,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'BENAR',
                    style: GoogleFonts.mulish(
                      fontSize: 12,
                      fontWeight: textBold,
                      color: whiteText,
                    ),
                  ),
                )
                : Container(
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 6,
                      vertical: 6,
                    ),
                    alignment: Alignment.center,
                    height: widget.widthScreen * 0.065,
                    decoration: BoxDecoration(
                      color: redSolid,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'SALAH',
                      style: GoogleFonts.mulish(
                        fontSize: 12,
                        fontWeight: textBold,
                        color: whiteText,
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: widget.widthScreen * 0.02,
            ),
            Container(
              width: widget.widthScreen * 0.75,
              child: HtmlWidget(
                widget.question['question_title'].toString(),
                textStyle: GoogleFonts.mulish(
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(
              height: widget.widthScreen * 0.02,
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 2),
              height: widget.widthScreen * 0.15,
              decoration: BoxDecoration(
                color: whiteText,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextFormField(
                enabled: !widget.has_attempt,
                controller: answerController,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  widget.has_attempt == true ? widget.exerciseData['submitted_answer'] : widget.onAnswerChanged(value);
                },
                decoration: InputDecoration(
                  hintText:widget.has_attempt == true ? widget.question['submitted_answer'] : 'Masukkan jawaban akhirmu...',
                  hintStyle: GoogleFonts.mulish(
                    fontSize: MediaQuery.of(context).size.width * 0.028,
                    fontWeight: FontWeight.w400,
                    color: blackText,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: widget.widthScreen * 0.04,
            ),
            widget.detailBool ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Penjelasan: '),
                  Container(
                    margin: EdgeInsets.only(top: widget.widthScreen * 0.04),
                    padding:const EdgeInsets.only(
                      left: 12
                    ),
                    child: HtmlWidget('${widget.question['explanation']}'),

                  )
                ],
            )
            : Container(),
            SizedBox(
              height: widget.widthScreen * 0.04,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.detailBool = true;
                });
              },
              onDoubleTap: (){
                widget.onScanPressed();
              },
              child: widget.has_attempt == true && widget.question['resource'] != null
              ? Container(
                  width: !widget.detailBool ? widget.widthScreen * 0.4 : widget.widthScreen * 0.5,
                  height: widget.widthScreen * 0.12,
                  decoration: BoxDecoration(
                    color: blueText,
                    borderRadius: BorderRadius.circular(29),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.remove_red_eye,
                        color: whiteText,
                      ),
                      SizedBox(
                        width: widget.widthScreen * 0.03,
                      ),
                      Text(
                        widget.detailBool ? 'Detail' : 'Penjelasan',
                        style: GoogleFonts.mulish(
                          color: whiteText,
                          fontSize: 14,
                          fontWeight: textMedium,
                        ),
                      ),
                    ],
                  ),
              )
              : Container()
            ),
          ],
        ),
      ),
    );
  }
}
