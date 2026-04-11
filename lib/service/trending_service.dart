import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:juxt_music/global_var/api_constants.dart';

class TrendingService {
  final String apiEndpoint = ApiConstants.apiEndpoint;
  /// Fetches trending tracks with a specific limit and offset.
  /// Returns a List of Maps (the "data" array from the Audius response).
  Future<List<dynamic>> fetchTrendingTracks({
    required int limit,
    required int offset,
  }) async {
    // Construct the URL precisely
    final String url = "$apiEndpoint/v1/tracks/trending?limit=$limit&offset=$offset";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Audius returns a JSON object where the tracks are inside the "data" key
        final Map<String, dynamic> decodedData = json.decode(response.body);
        
        // We return only the list of tracks
        return decodedData['data'] as List<dynamic>;
      } else {
        // No sugar-coating: if the API fails, we need to know why.
        throw Exception("Failed to load tracks: Status ${response.statusCode}");
      }
    } catch (e) {
      // In a personal project, print the error so you can debug CORS or Network issues easily
      if (kDebugMode) {
        print("Audius Service Error: $e");
      }
      return [];
    }
  }
}