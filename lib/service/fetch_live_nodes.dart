import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:juxt_music/global_var/links/node_points.dart';

/// A class which tests the API endpoints of Audius Server
/// If any node is nor working or couldn't find any
/// It returns the default node list
class FetchLiveNodes {

  /// This function fetches the live node links from the server
  /// If found none defaults to return of static links already predefined
  Future<List<String>> fetchHealthyMirrors() async {
    final response = await http.get(Uri.parse('https://api.audius.co'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.cast<String>();
    }
    return NodePoints.audiusMirrors; // Fallback to hardcoded list
  }
}
