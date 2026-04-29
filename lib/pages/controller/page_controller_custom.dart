import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:juxt_music/models/track/track_preview.dart';
import 'package:juxt_music/pages/home_page.dart';
import 'package:juxt_music/pages/trending_page.dart';
import 'package:juxt_music/states/music_que_state.dart';

class PageControllerCustom extends StatefulWidget {
  const PageControllerCustom({
    super.key,
    required this.pageNotifier,
    required this.trackDetails,
    required this.isDataReady,
    required this.musicQueState,
  });

  final ValueNotifier<int> pageNotifier;
  final List<TrackPreview> trackDetails;
  final bool isDataReady;

  /// A notifier variable to notify the currently selected track queue
  final MusicQueState musicQueState;

  @override
  State<PageControllerCustom> createState() => _PageControllerSate();
}

class _PageControllerSate extends State<PageControllerCustom> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: 0);

    widget.pageNotifier.addListener(changePage);
  }

  @override
  void dispose() {
    widget.pageNotifier.removeListener(changePage);
    _pageController.dispose();
    super.dispose();
  }

  void changePage() {
    final page = widget.pageNotifier.value;
    if (kDebugMode) {
      print("Page change to : $page");
    }
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 400),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      pageSnapping: true,
      physics: NeverScrollableScrollPhysics(),
      controller: _pageController,
      children: [
        // HOME SCREEN
        widget.isDataReady
            ? HomePage(
                trackDetails: widget.trackDetails,
                musicQueState: widget.musicQueState,
              )
            : placeHolderForNoData(),

        // TRENDING SCREEN
        widget.isDataReady ? TrendingPage() : placeHolderForNoData(),

        // FOR YOU SCREEN [[UPDATE LATER]]
        widget.isDataReady ? placeHolderForNoData() : placeHolderForNoData(),

        // LIBRARY SCREEN
        placeHolderForNoData(), // UPDATE LATER
        // SEARCH SCREEN
        placeHolderForNoData(), //UPDATE LATER
      ],
    );
  }

  Widget placeHolderForNoData() {
    return Center(child: CircularProgressIndicator.adaptive());
  }
}
