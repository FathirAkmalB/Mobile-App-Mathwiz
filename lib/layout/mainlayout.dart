import 'package:consume_api/UI/article_page/article_list.dart';
import 'package:consume_api/UI/history_page.dart';
import 'package:consume_api/UI/home_page.dart';
import 'package:consume_api/UI/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// file
import '/data/data.dart';

class MainLayout extends StatefulWidget {
  final int initialIndex;
  const MainLayout({super.key, required this.initialIndex});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  int _currentIndex = 0;

  final List<String> _titles = [
    'Beranda',
    'Riwayat',
    'Artikel',
    'Profile',
  ];

  final List<Widget> _screens = [
    const HomePage(),
    const HistoryScreens(),
    const ListArticle(),
    const ProfileScreens()
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: PreferredSize(
        preferredSize: const Size.fromHeight(kBottomNavigationBarHeight + 5),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              showSelectedLabels:
                  true, // Set to true to display labels for selected items
              showUnselectedLabels:
                  false, // Set to true to display labels for unselected items
              selectedItemColor: Colors.green, // Color for the selected item
              unselectedItemColor: Colors.grey,
              selectedLabelStyle: GoogleFonts.mulish(
                color: greenSolid,
                fontSize: 12,
              ),
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              currentIndex: _currentIndex,
              items: List.generate(
                _screens.length,
                (index) {
                  return BottomNavigationBarItem(
                    icon: Icon(
                      listOfIcons[index],
                      color: _currentIndex == index ? greenSolid : Colors.grey,
                    ),
                    label: _titles[index],
                  );
                },
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(
                  milliseconds: 300), // Adjust duration as needed
              left: _currentIndex *
                      (MediaQuery.of(context).size.width / _screens.length) +
                  24.0, // Account for margin
              top: 0,
              child: Container(
                width: MediaQuery.of(context).size.width / _screens.length -
                    50.0, // Account for margin
                height: 2, // Height of the underline
                color: greenSolid, // Color of the underline
              ),
            ),
          ],
        ),
      ),
    );
  }
}
