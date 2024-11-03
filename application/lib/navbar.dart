import 'package:btk/home_page.dart';
import 'package:btk/profile_screen.dart';
import 'package:btk/second_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
      body: PersistentTabView(
        context,
        controller: controller.tabController,
        screens: controller.screens,
        items: [
          PersistentBottomNavBarItem(
            icon: Image.asset(
              'assets/Icons/home-agreement.png',
              width: 24, // Adjust width as needed
              height: 24, // Adjust height as needed
            ),
            title: "Home",
            activeColorPrimary: Colors.blueAccent,
            inactiveColorPrimary: Colors.grey,
          ),
          PersistentBottomNavBarItem(
            icon: Image.asset(
              'assets/Icons/artificial-intelligence.png',
              width: 24, // Adjust width as needed
              height: 24, // Adjust height as needed
            ),
            title: "AI",
            activeColorPrimary: Colors.blueAccent,
            inactiveColorPrimary: Colors.grey,
          ),
          PersistentBottomNavBarItem(
            icon: Image.asset(
              'assets/Icons/profile-candidate.png', // Updated icon path
              width: 24, // Adjust width as needed
              height: 24, // Adjust height as needed
            ),
            title: "Profile",
            activeColorPrimary: Colors.blueAccent,
            inactiveColorPrimary: Colors.grey,
          ),
        ],
        confineToSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        navBarHeight: 60, // Height of the navigation bar
        decoration: NavBarDecoration(
          colorBehindNavBar: Colors.white,
          border:
              Border(top: BorderSide(color: Colors.grey.shade300, width: 0.5)),
        ),
        onItemSelected: (index) {
          controller.selectedIndex.value = index;
        },
      ),
    );
  }
}

class NavigationController extends GetxController {
  final PersistentTabController tabController =
      PersistentTabController(initialIndex: 0);
  final Rx<int> selectedIndex = 0.obs;

  // Change the selected index and the corresponding screen
  void changeIndex(int index) {
    selectedIndex.value = index; // Update the selected index
    tabController.index =
        index; // Update the tab controller index to refresh the displayed screen
  }

  final List<Widget> screens = [
    HomePage(),
    SignUpScreen(),
    ProfilePage(), // Make sure SignUpScreen is imported correctly
  ];
}
