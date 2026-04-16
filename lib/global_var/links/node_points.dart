/// NodePoints is a class which holds the default links for 
/// Streaming audio tracks from Audius servers
/// This class holds a set of default links which is a fallback
/// if the main function [FetchLiveNodes] class fails to find
/// active nodes from the server.
class NodePoints {
  static final List<String> audiusMirrors = [
    'https://audius-dp.host.com',
    'https://audius-metadata-2.cloudmos.io',
    'https://audius-discovery-10.cultur3stake.com',
  ];
}
