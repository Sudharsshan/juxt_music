import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:juxt_music/states/selected_track_state.dart';

class PlayerPlaybackState extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  bool isPlaying = false;
  double currentPosition = 0.0;
  double totalDuration = 0.0;
  SelectedTrackState? currentTrack;
  String? _loadedStreamUrl;

  PlayerPlaybackState() {
    // Listen to position changes
    _audioPlayer.positionStream.listen((position) {
      currentPosition = position.inSeconds.toDouble();
      notifyListeners();
    });

    // Listen to player state changes (playing, paused, completed)
    _audioPlayer.playerStateStream.listen((state) {
      isPlaying = state.playing;
      
      // If the track finished playing, pause and reset to start
      if (state.processingState == ProcessingState.completed) {
        isPlaying = false;
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.pause();
      }
      
      notifyListeners();
    });
    
    // Update total duration if the stream provides a more accurate one
    _audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        totalDuration = duration.inSeconds.toDouble();
        notifyListeners();
      }
    });
  }

  void playPause() {
    if (_audioPlayer.playing) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  void updatePosition(double position) {
    _audioPlayer.seek(Duration(seconds: position.toInt()));
  }

  Future<void> setTrack(SelectedTrackState track, {Function(String)? onError}) async {
    final isNewTrack = currentTrack?.preview.id != track.preview.id;

    if (isNewTrack) {
      _loadedStreamUrl = null;
      currentPosition = 0.0;
      isPlaying = true; // UI will show pause button while loading/playing
      await _audioPlayer.stop();
    }
    
    currentTrack = track;
    
    if (totalDuration == 0.0 || isNewTrack) {
      totalDuration = track.duration.toDouble();
    }
    
    notifyListeners();

    final streamUrls = track.detail?.streamUrls;
    if (streamUrls != null && streamUrls.isNotEmpty && !streamUrls.contains(_loadedStreamUrl)) {
      bool success = false;
      
      for (final url in streamUrls) {
        try {
          await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(url)));
          success = true;
          _loadedStreamUrl = url;
          if (isPlaying) {
            _audioPlayer.play();
          }
          break; // successfully loaded
        } catch (e) {
          if (kDebugMode) print("Error loading audio source from $url: $e");
        }
      }
      
      if (!success) {
        isPlaying = false;
        notifyListeners();
        if (onError != null) {
          onError("Cannot play the music. All servers are currently down.");
        }
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
