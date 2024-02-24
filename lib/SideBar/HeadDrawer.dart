import 'package:consume_api/data/data.dart';
import 'package:consume_api/methods/api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeaderDrawer extends StatefulWidget {
  const HeaderDrawer({super.key});

  @override
  State<HeaderDrawer> createState() => _HeaderDrawerState();
}


class _HeaderDrawerState extends State<HeaderDrawer> {

  Future<Map<String, dynamic>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  
    final String? avatar = prefs.getString('avatar');
    final String? name = prefs.getString('name');
    final String? role = prefs.getString('role');


    return {
      'name': name ?? 'no name',
      'avatar': avatar ?? 'no avatar',
      'role': role ?? 'no role',

    };
  }

  @override
  Widget build(BuildContext context) {

    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    double font12 = widthScreen * 0.035;
    double font14 = widthScreen * 0.043;
    double font16 = widthScreen * 0.05;
    double font25 = widthScreen * 0.058;
    double font22 = widthScreen * 0.055;
    double mtkSize = widthScreen * 0.05;

    return Container(
      color: blueText,
      margin: const EdgeInsets.only(bottom: 30),
      width: double.infinity,
      height: heightScreen * 0.24,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: FutureBuilder(
        future: getUserData(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const CircularProgressIndicator();
          }
          else if ( snapshot.hasError){
            return CircularProgressIndicator(color: redSolid,);
          }
          else if( snapshot.hasData){
            final data = snapshot.data;
            final name = data?['name'];
            final avatar = data?['avatar'];
            final role = data?['role'].toUpperCase();
            return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: widthScreen * 0.2,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: avatar != null
                                                        ? NetworkImage(
                                                            '${ApiURL.apiUrl}/storage/$avatar')
                                                        : const AssetImage(
                                                                'assets/img/DefaultProfile.png')
                                                            as ImageProvider),
                        ),
                      ),
                     Column(
                      children: [
                         Text('${name}', style: GoogleFonts.mulish(
                        fontSize: font16,
                        fontWeight: textBold,
                        color: whiteText
                      ),),
                      SizedBox(height: 6,),
                      Text(role.toLowerCase() == 'student' ? 'Mahasiswa': 'User', style: GoogleFonts.mulish(
                        fontSize: font12,
                        fontWeight: textMedium,
                        color: whiteText
                      ),),
                      ],
                     ),
                     Container(color: whiteText, height: 4, width: widthScreen * 0.12)
                    ],
                  );
          }else{
            throw Exception('Failed to Get User Data');
          }
        },
      )
    );
  }
}