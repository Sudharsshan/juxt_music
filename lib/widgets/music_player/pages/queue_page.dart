import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:juxt_music/states/music_que_state.dart';

class QueuePage extends StatelessWidget {
  const QueuePage({super.key, required this.musicQueState});

  final MusicQueState musicQueState;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background blur matching the player style
        Positioned.fill(
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(color: Colors.white.withAlpha(25)),
            ),
          ),
        ),
        // Queue list
        ListenableBuilder(
          listenable: musicQueState,
          builder: (context, child) {
            final tracks = musicQueState.currentList;
            final currentIndex = musicQueState.currentIndex;

            return ListView.builder(
              padding: const EdgeInsets.only(top: 110, bottom: 20),
              itemCount: tracks.length,
              itemBuilder: (context, index) {
                final track = tracks[index];
                final isPlaying = index == currentIndex;

                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child:
                        (track.preferredArtwork != null &&
                            track.preferredArtwork!.startsWith('http'))
                        ? Image.network(
                            track.preferredArtwork!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.music_note, size: 50),
                          )
                        : const Icon(Icons.music_note, size: 50),
                  ),
                  title: Text(
                    track.title,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 12,
                      fontWeight: isPlaying
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isPlaying
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    track.artistName,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 12,
                      color: isPlaying
                          ? Theme.of(context).primaryColor.withAlpha(200)
                          : Theme.of(context).textTheme.titleMedium?.color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isPlaying)
                        Icon(
                          Icons.volume_up,
                          color: Theme.of(context).primaryColor,
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.star_border,
                            color: Theme.of(
                              context,
                            ).textTheme.titleMedium!.color,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.more_vert,
                          color: Theme.of(context).textTheme.titleMedium!.color,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    musicQueState.playTrackById(track.preview.id);
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }
}
