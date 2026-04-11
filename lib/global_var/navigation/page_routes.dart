import 'package:juxt_music/global_var/navigation/page_id.dart';

class PageRoutes {

  static final Map<PageId, int> route = {
    PageId.home : 0,
    PageId.trending : 1,
    PageId.forYou : 2,
    PageId.library: 3,
    PageId.search : 4
  };
}