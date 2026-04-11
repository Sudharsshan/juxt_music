import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:juxt_music/models/audius_model.dart';
import 'package:juxt_music/models/genre_model.dart';
import 'package:juxt_music/models/mood/mood_model.dart';
import 'package:juxt_music/pages/controller/page_controller_custom.dart';
import 'package:juxt_music/service/trending_service.dart';
import 'package:juxt_music/widgets/app_bar/app_bar_blur.dart';
import 'package:juxt_music/widgets/app_bar/app_bar_main.dart';
import 'package:juxt_music/widgets/app_bar/front_and_back.dart';
import 'package:juxt_music/widgets/app_bar/icons_map.dart';
import 'package:juxt_music/widgets/glass/glass_anim.dart';

class Sub extends StatefulWidget {
  const Sub({super.key});

  @override
  State<Sub> createState() => _SubState();
}

class _SubState extends State<Sub> {
  ValueNotifier<int> pageNotifier = ValueNotifier(0);
  int limit = 50;
  ValueNotifier<int> offsetNotifier = ValueNotifier(0);
  late List<dynamic> response;
  late List<AudiusModel> trackDetails;
  bool isDetailsReady = false;
  late MoodModel moodModel;
  late GenreModel genreModel;

  @override
  void initState() {
    super.initState();

    updateTrends();
  }

  void updateTrends() async {
    // obtain the JSON data from api
    TrendingService trendingService = TrendingService();
    response = await trendingService.fetchTrendingTracks(
      limit: limit,
      offset: offsetNotifier.value,
    );
    if (kDebugMode) print("Response Ready.");

    parseJSON();

    setState(() {
      isDetailsReady = true;
    });
  }

  void parseJSON() async {
    // parse the JSON data obtained from API
    trackDetails = response.map((json) => AudiusModel.fromJson(json)).toList();
    // if (kDebugMode) print("Track details:\n${trackDetails[0].mood}");
  }

  // if (kDebugMode) print("Response data:\n$response");

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: AlignmentGeometry.center,
        children: [
          // Page controller custom
          isDetailsReady
              ? PageControllerCustom(
                  pageNotifier: pageNotifier,
                  trackDetails: trackDetails,
                  isDataReady: isDetailsReady,
                )
              : CircularProgressIndicator.adaptive(),

          // App Bar
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: AppBarBlur(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: [
                  const FrontAndBack(),

                  const SizedBox(width: 20),

                  Center(
                    child: GlassAnim(
                      animationDirection: Axis.horizontal,
                      child: AppBarMain(
                        pageNotifier: pageNotifier,
                        children: IconsMap.barIcons,
                        requiredWidth: 50, // good value for just icons
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),

                  const Visibility(visible: false, child: FrontAndBack()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
