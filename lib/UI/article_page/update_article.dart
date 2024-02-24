import 'dart:async';
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

class UpdateArticle extends StatefulWidget {
  final articleData;
  const UpdateArticle({required this.articleData, super.key});

  @override
  State<UpdateArticle> createState() => _UpdateArticleState();
}

class SubjectOption {
  final int id;
  final String title;

  SubjectOption(this.id, this.title);
}

class _UpdateArticleState extends State<UpdateArticle> {
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
    titleController.text = widget.articleData['title'] ?? "";
  }

  Future<void> updateArticle() async {
    String bodyText = await bodyController.getText();

    try {
      final apiUrl =
          '${ApiURL.apiUrl}/api/updateArticle/${widget.articleData['id']}';
      var request = http.MultipartRequest("POST", Uri.parse(apiUrl));
      request.fields['title'] = titleController.text;
      request.fields['body'] = bodyText;
      request.fields['_method'] = 'PUT';
      var response = await request.send();

      if (response.statusCode == 200) {
        // Berhasil
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Berhasil menyimpan perubahan'),
              content: Text('Silahkan tunggu approval dosen!'),
            );
          },
        );
        Timer(const Duration(seconds: 2), () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const UserArticle(),
          ));
        });
      } else {
        // Gagal
        print('Gagal menyimpan perubahan artikel');
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
                  'Edit Artikel',
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
            Column(
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
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(width: 1.5, color: outlineInput)),
                        child: TextFormField(
                          style: GoogleFonts.mulish(
                            color: Colors.black,
                            fontSize: font12,
                            fontWeight: FontWeight.w400,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          controller: titleController,
                          decoration: InputDecoration(
                            hintStyle: GoogleFonts.mulish(
                                fontSize: font12,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
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
                    ],
                  ),
                ),
                Column(
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
                      text: "${widget.articleData['body']}",
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
              ],
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        'Simpan perubahan?',
                        style: GoogleFonts.mulish(
                            color: greenSolid,
                            fontWeight: textBold,
                            fontSize: font14),
                      ),
                      content: const Text('Perubahan kamu akan di approval kembali!'),
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
                                color: subTitle, fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              updateArticle();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: greenSolid,
                                  borderRadius: BorderRadius.circular(6)),
                              child: Text(
                                'Simpan',
                                style: GoogleFonts.mulish(
                                    color: whiteText,
                                    fontWeight: FontWeight.bold),
                              ),
                            ))
                      ],
                    );
                  },
                );
              },
              child: Text('Simpan perubahan'),
            )
          ],
        )),
      ),
    );
  }
}
