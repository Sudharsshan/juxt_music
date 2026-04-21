import 'package:juxt_music/service/fetch_live_nodes.dart';

/// [MirrorProvider] service returns the stream URL from an active URL endpoint
/// for the given track id.
class MirrorProvider {
  List<String>? cached;
  DateTime? fetchedAt;

  Future<List<String>> getMirrors() async{
    if(cached != null && fetchedAt != null && DateTime.now().difference(fetchedAt!) < const Duration(minutes: 30)){
      return cached!;
    }

    cached = await FetchLiveNodes().fetchHealthyMirrors();
    fetchedAt = DateTime.now();
    return cached!;
  }

  Future<String> buildStreamUrl(String trackId) async{
    final mirrors = await getMirrors();
    return mirrors.isEmpty ? '' : '${mirrors.first}/v1/tracks/$trackId/stream';
  }
}