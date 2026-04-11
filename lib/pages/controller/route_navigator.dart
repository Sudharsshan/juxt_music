import 'package:flutter/material.dart';
import 'package:juxt_music/global_var/navigation/page_routes.dart';

class RouteNavigator {
  const RouteNavigator({required this.pageNotifier});


  final ValueNotifier pageNotifier;

  void navigateToPage(Enum page){
    pageNotifier.value(PageRoutes.route[page] ?? 0);
  }
}