import 'package:dismov_app/app/menu/screen/chat/chat.dart';
import 'package:dismov_app/app/menu/screen/menu_screen.dart';
import 'package:dismov_app/app/menu/screen/recommendations/recommendations_page.dart';
import 'package:dismov_app/app/menu/screen/userSettingsPage/user_settings_screen.dart';
import 'package:dismov_app/app/utils/animation_duration.dart';
import 'package:dismov_app/config/config.dart';
import 'package:dismov_app/shared/widgets/bottombar.dart';
import 'package:flutter/material.dart';
//Test

import 'package:dismov_app/app/menu/screen/Pet/shelters_page.dart';

import '../../../services/location_service.dart';

class RootApp extends StatefulWidget {
  const RootApp({super.key});

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> with TickerProviderStateMixin {

  int _activeTab = 0;

  final List barItems = [
    {
      "icon": "assets/icons/home-border.svg",
      "active_icon": "assets/icons/home.svg",
      "page": const MenuScreen(),
    },
    {
      "icon": "assets/icons/pet-border.svg",
      "active_icon": "assets/icons/pet.svg",
      "page": const ShelterScreen(),
    },
    {
      "icon": "assets/icons/chat-border.svg",
      "active_icon": "assets/icons/chat.svg",
      "page": const ChatPage(),
    },
    {
      "icon": "assets/icons/heart-border.svg",
      "active_icon": "assets/icons/heart.svg",
      "page": const RecommendationsPage(),
    },
    {
      "icon": "assets/icons/user-border.svg",
      "active_icon": "assets/icons/usuario.svg",
      "page": const UserSettingsScreen(),
    },
  ];

//====== set animation=====
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: animated),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  _buildAnimatedPage(page) {
    return FadeTransition(child: page, opacity: _animation);
  }

  void onPageChanged(int index) {
    _controller.reset();
    setState(() {
      _activeTab = index;
    });
    _controller.forward();
  }

//====== end set animation=====

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      body: _buildPage(),
      floatingActionButton: _buildBottomBar(),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }

  Widget _buildPage() {
    return IndexedStack(
      index: _activeTab,
      children: List.generate(
        barItems.length,
        (index) => _buildAnimatedPage(barItems[index]["page"]),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        decoration: BoxDecoration(
          color: AppColor.containerColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadowColor.withOpacity(0.1),
              blurRadius: 1,
              spreadRadius: 1,
              offset: const Offset(0, 1),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(
            barItems.length,
            (index) => BottomBarItem(
              _activeTab == index
                  ? barItems[index]["active_icon"]
                  : barItems[index]["icon"],
              isActive: _activeTab == index,
              activeColor: AppColor.primary,
              onTap: () => onPageChanged(index),
            ),
          ),
        ),
      ),
    );
  }
}
