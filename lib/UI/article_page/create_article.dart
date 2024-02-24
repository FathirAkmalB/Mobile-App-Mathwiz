import 'dart:convert';
import 'dart:io';

import 'package:consume_api/UI/article_page/user_article.dart';
import 'package:consume_api/methods/api.dart';
import 'package:http/http.dart' as http;
import 'package:consume_api/data/data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateArticle extends StatefulWidget {
  const CreateArticle({super.key});

  @override
  State<CreateArticle> createState() => _CreateArticleState();
}

class SubjectOption {
  final int id;
  final String title;

  SubjectOption(this.id, this.title);
}

class _CreateArticleState extends State<CreateArticle> {
  TextEditingController titleController = TextEditingController();
  QuillEditorController bodyController = QuillEditorController();
  String selectedSubjectId = ''; // Store the selected subject_id
  File? selectedImage; // Store the selected image file

  String? _avatar;
  FilePickerResult? _pickedFile;

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg'],
        allowMultiple: false);

    if (result != null) {
      File file = File(result.files.single.path!);

      setState(() {
        _pickedFile = result;
        _avatar = result.files.first.name;
        selectedImage = file;
      });
      
    } else {
      // User canceled the picker
    }
  }

  @override
  void initState() {
    super.initState();
    getSubject();
  }


  
  List<SubjectOption> subjectList = [];
  List<String> subjectOptions = [];
  List subjectId = [];
  String selectedSubject = "";
  

Future<List<SubjectOption>> getSubject() async {
  final response = await API().getRequest(route: '/getDataSubjects');

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);

    if (data.containsKey("getSubjects")) {
      final List<dynamic> subjects = data["getSubjects"];

      setState(() {
        subjectList = subjects.map((subject) {
          return SubjectOption(
            subject['id'] as int,
            subject['title'] as String,
          );
        }).toList();

        subjectOptions = subjectList.map((option) => option.title).toList();
        subjectId = subjectList.map((option) => option.id).toList();

        if (subjectOptions.isNotEmpty) {
          selectedSubject = subjectOptions.first;
          selectedSubjectId = subjectId.first.toString();
        }
      });

      print('sabjek: $subjectOptions');
      return subjectList;
    } else {
      throw Exception('Key "getSubjects" not found in the response data');
    }
  } else {
    throw Exception('Failed get Subject: ${response.statusCode}');
  }
}



  Future<void> _createArticle() async {
  final url = Uri.parse('${ApiURL.apiUrl}/api/article/create');
  SharedPreferences pref = await SharedPreferences.getInstance();
  final userId = pref.getInt('id');
  String bodyText = await bodyController.getText();

  try {
   final apiUrl = '${ApiURL.apiUrl}/api/article/create';
        var request = http.MultipartRequest("POST", Uri.parse(apiUrl));
        request.fields['subject_id'] = selectedSubjectId;
        request.fields['title'] = titleController.text;
        request.fields['body'] = bodyText;
        request.fields['user_id'] = userId.toString();

        if (_pickedFile != null && _pickedFile!.files.isNotEmpty) {
          print('Berhasil mendapatkan Gambar');
          request.files.add(await http.MultipartFile.fromPath(
            'cover',
            _pickedFile!.files.first.path!,
          ));
        }
    var response = await request.send();

    if (response.statusCode == 201) {
      // Berhasil
      print('Mahasiswa berhasil mengajukan artikel');
      Navigator.push(context, 
      MaterialPageRoute(builder: (context) => const UserArticle(),));
    } else {
      // Gagal
      print('Gagal mengajukan artikel');
      print(response.statusCode);
    }
  } catch (e) {
    // Tangani error
    print('Error: $e');
  }
}

  int currentIndex = 0; // For knowing the current index
  bool limitIndex = false; // For controlling the button


  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    double font14 = widthScreen * 0.043;
    double font12 = widthScreen * 0.038;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: heightScreen * 0.1,
              title: Container(
                alignment: Alignment.center,
                child: Text(
                  'Buat Artikel',
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
            currentIndex == 0
                ? Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: widthScreen * 0.85,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Judul Artikel:',
                              style: GoogleFonts.mulish(
                                color: blackText,
                                fontWeight: textBold,
                                fontSize: font12,
                              ),
                            ),
                            SizedBox(
                              height: widthScreen * 0.04,
                            ),
                            Container(
                              height: 60,
                              padding: EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 1.5, color: outlineInput)),
                              child: TextFormField(
                                controller: titleController,
                                style: GoogleFonts.mulish(
                                  color: Colors.black,
                                  fontSize: font12,
                                  fontWeight: FontWeight.w400,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: 'masukkan judul artikel',
                                  hintStyle: GoogleFonts.mulish(
                                      fontSize: font12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black45),
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
                            SizedBox(
                              height: widthScreen * 0.08,
                            ),
                            
                            Text('Mata Kuliah:',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.lato(
                                    fontWeight: textRegular, fontSize: font12)),
                            SizedBox(
                              height: widthScreen * 0.04,
                            ),
                            Container(
                              alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 17),
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 1.5, color: outlineInput)
                            ),
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true, // Mengurangi jarak di sekitar dropdown
                              ),
                              icon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: outlineInput,
                              ),
                              value: selectedSubject,
                              items: subjectList.map((SubjectOption option) {
                                return DropdownMenuItem<String>(
                                  value: option.title,
                                  child: Text(
                                    option.title,
                                    style: GoogleFonts.lato(
                                      fontSize: font12,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) async {
                                final selectedOption = subjectList.firstWhere((option) => option.title == newValue);
                                setState(() {
                                 selectedSubject = selectedOption.title;
                                 selectedSubjectId = selectedOption.id.toString();
                                });
                              },
                            ),
                          ),
                            SizedBox(
                              height: widthScreen * 0.08,
                            ),

                            Text('Artikel cover:',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.lato(
                                    fontWeight: textRegular, fontSize: font12)),
                            SizedBox(
                              height: widthScreen * 0.04,
                            ),
                            Container(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: widthScreen * 0.648,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(0),
                                        topRight: Radius.circular(0),
                                        bottomRight: Radius.circular(0),
                                      ),
                                      border: Border.all(
                                          width: 1.5, color: outlineInput)),
                                  padding: const EdgeInsets.all(15),
                                  child: Text(
                                    _avatar ?? 'choose file',
                                    overflow: TextOverflow.clip,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: font12,
                                        color: Colors.black45),
                                  ),
                                ),
                                ElevatedButton(
                                    onPressed: _pickImage,
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.022),
                                          bottomRight: const Radius.circular(0),
                                        ),
                                        side: const BorderSide(
                                          color: Colors.transparent,
                                          width: 1.0,
                                        ),
                                      ),
                                      primary: outlineInput,
                                      padding: const EdgeInsets.all(16),
                                      minimumSize: const Size(0, 60),
                                    ),
                                    child: const Text('Browse')),
                              ],
                            )),
                          ],
                        ),
                      ),
                      selectedImage == null
                          ? Container(
                              width: widthScreen * 0.85,
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12)),
                                border:
                                    Border.all(width: 2, color: outlineInput),
                              ),
                              child: Text(
                                'Pilih Gambar untuk sampul Artikel',
                                style: GoogleFonts.mulish(
                                    color: outlineInput,
                                    fontWeight: textMedium,
                                    fontSize: font12),
                              ),
                            )
                          : Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12)),
                                border:
                                    Border.all(width: 2, color: outlineInput),
                              ),
                              child: Image.file(
                                selectedImage!,
                                width: widthScreen * 0.81,
                              ),
                            ),
                    ],
                  )
                : Column(
                    children: [
                      Container(
                        width: widthScreen,
                        child: ToolBar(
                          toolBarColor: searchBar,
                          activeIconColor: blueText,
                          padding: const EdgeInsets.all(8),
                          iconSize: 20,
                          controller: bodyController,
                        ),
                      ),
                      QuillHtmlEditor(
                        text: "",
                        hintText: 'Hint text goes here',
                        controller: bodyController,
                        isEnabled: true,
                        minHeight: 300,
                        hintTextAlign: TextAlign.start,
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        hintTextPadding: EdgeInsets.zero,
                        backgroundColor: Colors.transparent,
                        onFocusChanged: (hasFocus) =>
                            debugPrint('has focus $hasFocus'),
                        onTextChanged: (text) =>
                            debugPrint('widget text change $text'),
                        onEditorCreated: () =>
                            debugPrint('Editor has been loaded'),
                        onEditingComplete: (s) =>
                            debugPrint('Editing completed $s'),
                        onEditorResized: (height) =>
                            debugPrint('Editor resized $height'),
                        onSelectionChanged: (sel) =>
                            debugPrint('${sel.index},${sel.length}'),
                        loadingBuilder: (context) {
                          return const Center(
                              child: CircularProgressIndicator(
                            strokeWidth: 0.4,
                          ));
                        },
                      ),
                    ],
                  ),
            Container(
              margin: EdgeInsets.only(top: widthScreen * 0.05),
              padding: const EdgeInsets.only(bottom: 30),
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  currentIndex != 0
                      ? ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(blueText),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(90),
                              ),
                            ),
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Icon(Icons.skip_previous_rounded),
                              Text(limitIndex ? 'Sebelumnya' : ''),
                            ],
                          ))
                      : Container(),
                  const SizedBox(width: 10),
                  !(currentIndex == 1)
                      ? ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(blueText),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(90),
                              ),
                            ),
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                                    const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 4)),
                          ),
                          onPressed: () {
                            setState(() {
                              currentIndex++;
                              if (currentIndex >= 1) {
                                setState(() {
                                  limitIndex = true;
                                });
                              }
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(limitIndex ? '' : 'Selanjutnya'),
                              const Icon(Icons.skip_next_rounded),
                            ],
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            _createArticle();
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(greenSolid),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(90),
                              ),
                            ),
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                                    const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 4)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(!limitIndex ? '' : 'Buat Artikel'),
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
        )),
      ),
    );
  }
}
