import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vas/screens/dashboard_page.dart';
import '../theme.dart';
import '../widgets/side_menu.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _checkFirstTimeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      // First-time user, call the API
      // await _fetchAndSaveData();

      // Mark user as NOT first-time
      await prefs.setBool('isFirstTime', false);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkFirstTimeUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      appBar: AppBar(
        // excludeHeaderSemantics: true,
        backgroundColor:  AppThemes.light.primaryColor,

        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const Text(
              "1962 - ",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "MVU APP",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      drawer: const SideMenu(),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
                DashboardPage(),
                // const Center(child: Text("Page 2")),
                // const Center(child: Text("Page 3")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
