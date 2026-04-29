import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:juxt_music/global_var/links/api_constants.dart';
import 'package:juxt_music/models/track/track_detail.dart';
import 'package:juxt_music/models/track/track_preview.dart';
import 'package:juxt_music/service/mirror_provider.dart';

class TrendingService {
  final String apiEndpoint = ApiConstants.apiEndpoint;

  /// Fetches the trending feed and maps it directly to lightweight preview
  /// models so list UIs do not carry detail-only fields in memory.
  Future<List<TrackPreview>> fetchTrendingTracks({
    required int limit,
    required int offset,
  }) async {
    final String url = "$apiEndpoint/v1/tracks/trending?limit=$limit&offset=$offset";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = json.decode(response.body);
        final List<dynamic> rawTracks = decodedData['data'] as List<dynamic>? ?? [];

        return rawTracks
            .whereType<Map<String, dynamic>>()
            .map(TrackPreview.fromJson)
            .toList();
      } else {
        throw Exception("Failed to load tracks: Status ${response.statusCode}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Audius Service Error: $e");
      }
      return [];
    }
  }

  /// Fetches the richer payload for one track only when the user actually
  /// opens it, keeping list rendering cheap while still supporting player/detail
  /// screens.
  Future<TrackDetail?> fetchTrackDetail({
    required String trackId,
    required MirrorProvider mirrorProvider,
  }) async {
    final String url = "$apiEndpoint/v1/tracks/$trackId";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = json.decode(response.body);
        final Map<String, dynamic>? trackJson =
            decodedData['data'] as Map<String, dynamic>?;

        if (trackJson == null) return null;

        final List<String> streamUrls = await mirrorProvider.buildStreamUrls(trackId);
        return TrackDetail.fromJson(trackJson, streamUrls: streamUrls);
      } else {
        throw Exception(
          "Failed to load track detail: Status ${response.statusCode}",
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Audius Detail Error: $e");
      }
      return null;
    }
  }
}
