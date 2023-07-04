import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Models/user_model.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/screens/search_screen.dart';
import 'package:provider/provider.dart';
import '../colores.dart';
import '../screens/feed_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/upload_photo_screen.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _pages = 0;
  PageController _pageController = PageController();

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void NavigatePage(int page) {
    _pageController.jumpToPage(page);
  }

  void pageController(int page) {
    setState(() {
      _pages = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          FeedScreen(),
          SearchScreen(),
          UploadImageScreen(),
          Center(
            child: Text('Noti'),
          ),
          ProfileScreen(
            uid: user.uid!,
          ),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.home,
              color: _pages == 0 ? primaryColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search,
                color: _pages == 1 ? primaryColor : secondaryColor),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.add_circled,
                color: _pages == 2 ? primaryColor : secondaryColor),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.heart_solid,
                color: _pages == 3 ? primaryColor : secondaryColor),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.profile_circled,
                color: _pages == 4 ? primaryColor : secondaryColor),
            label: '',
            backgroundColor: primaryColor,
          ),
        ],
        onTap: NavigatePage,
      ),
    );
  }
}
