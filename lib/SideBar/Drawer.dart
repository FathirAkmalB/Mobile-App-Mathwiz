import 'package:consume_api/SideBar/HeadDrawer.dart';
import 'package:consume_api/data/data.dart';
import 'package:flutter/material.dart';

class CommonDrawer extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemSelected;

  const CommonDrawer({
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Your HeaderDrawer widget goes here
            const HeaderDrawer(),

            ListDrawer(currentIndex: currentIndex, onItemSelected: onItemSelected),
          ],
        ),
      ),
    );
  }
}

class ListDrawer extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemSelected;

  const ListDrawer({
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> titles = [
      'Materi',
      'Latihan',
      'Ujian',
      'Artikel',
      'Remedial',
      'Riwayat',
      'Profile',
    ];

    List<IconData> listOfIcons = [
      Icons.dashboard_outlined,
      Icons.checklist_sharp,
      Icons.fact_check_outlined,
      Icons.article_outlined,
      Icons.wrap_text_rounded,
      Icons.history,
      Icons.person_outline,
    ];

    return Container(
      child: Column(
        children: [
          // Generate menu items based on the _titles list
          for (var i = 0; i < titles.length; i++)
            menuItem(context, i, titles[i], listOfIcons[i], currentIndex == i, onItemSelected),
        ],
      ),
    );
  }

  Widget menuItem(BuildContext context, id, String title, IconData icon, bool selected, Function(int) onTapped) {
    double widthScreen = MediaQuery.of(context).size.width;
    double font16 = widthScreen * 0.05;
    double font25 = widthScreen * 0.06;
    return Material(
      color: selected ? blueText : Colors.transparent,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
        leading: Icon(
          icon,
          color: selected ? whiteText : subTitle,
          size: font25,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: selected ? whiteText : subTitle,
            fontSize: font16,
            fontWeight: FontWeight.w400
          ),
        ),
        onTap: () {
          onTapped(id);
        },
        selected: selected,
      ),
    );
  }
}
