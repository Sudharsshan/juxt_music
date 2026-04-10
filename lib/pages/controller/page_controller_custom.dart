import 'package:flutter/material.dart';
import 'package:juxt_music/pages/home_page.dart';

class PageControllerCustom extends StatefulWidget{
  const PageControllerCustom({super.key});

  @override
  State<PageControllerCustom> createState() => _PageControllerSate();
}

class _PageControllerSate extends State<PageControllerCustom>{

  late PageController _pageController;

  @override
  void initState(){
    super.initState();

    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose(){
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){

    return PageView(
      controller: _pageController,
      children: [
        // main screen
        HomePage()

        // trending screen

        // For you screen

        // library screen

        // search screen
      ],
    );
  }
}