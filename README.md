# Disclaimer

This project is an independent technical demonstration of Flutter rendering, UI composition, and music discovery flows. It is not affiliated with, endorsed by, or sponsored by Apple Inc.

# juxt_music

`juxt_music` is a Flutter music discovery app prototype built around the Audius API. The current implementation focuses on a polished browse experience: mood-driven discovery, genre grouping, cached artwork, blur/glass UI components, and a custom app-bar/page-navigation system.

The app is not a full streaming product yet. A few screens and interaction paths are still placeholders, but the project already has a clear architecture for fetching trending tracks, parsing Audius payloads into app models, and rendering reusable music-first widgets.

## What The App Currently Does

- Fetches trending track data from Audius.
- Resolves healthy Audius mirrors for track streaming URLs.
- Converts raw API payloads into `AudiusModel` objects.
- Extracts unique moods and genres from fetched tracks.
- Builds a home screen with `Find Your Mood` cards backed by local mood cover assets.
- Builds genre-based horizontal track shelves backed by Audius artwork.
- Uses custom widgets for glass / blur surfaces, app bar navigation, cover art rendering, and reusable track boxes.
- Supports dark mode by default through `ThemeController`.

## Current Screen Status

- `HomePage`: implemented and populated from live Audius data.
- `TrendingPage`: scaffolded, currently placeholder text.
- `For You`: placeholder.
- `Library`: placeholder.
- `Search`: placeholder.

## Data Flow

The main runtime flow in the codebase looks like this:

1. `main.dart` boots `MainApp`.
2. `MainApp` mounts `Sub`, which acts as the app shell/state bootstrapper.
3. `Sub.updateTrends()` calls `TrendingService.fetchTrendingTracks(...)`.
4. `Sub.parseJSON()` calls `FetchLiveNodes().fetchHealthyMirrors()`.
5. Raw Audius JSON is mapped into `List<AudiusModel> trackDetails`.
6. `PageControllerCustom` receives `trackDetails` and decides which page to render.
7. `HomePage` derives `MoodModel` and `GenreModel` from those tracks.
8. `FeaturedMain` and `BoxMain` render the actual browse shelves/cards.

## Directory Structure

Below is the meaningful app structure under `lib/`:

```text
lib/
  main.dart                          # App entrypoint, themes, MaterialApp
  sub.dart                           # Core bootstrap/state shell for data + page wiring

  assets/
    mood_covers/                     # Local mood artwork used in the mood shelf

  global_var/
    artwork_sizes/
      artwork_sizes.dart             # Artwork size enum used with Audius artwork maps
    credits/
      mood_attribution.dart          # Attribution-related constants/data
    links/
      api_constants.dart             # Base Audius API endpoint
      mood_covers.dart               # Mood -> local asset path map
      node_points.dart               # Fallback Audius mirror URLs
    navigation/
      page_id.dart                   # Page enum identifiers
      page_routes.dart               # Page enum -> page index mapping
    blur_radius.dart
    description_chart.dart           # Mood/genre descriptions for UI copy
    font_sizes.dart                  # Shared typography sizing
    glass_blur_value.dart            # Blur tuning values
    track_box_height.dart            # Shared shelf/card height

  models/
    audius_model.dart                # Main track model used by UI
    genre_model.dart                 # Genre extraction/filter helpers
    track_detail_model.dart          # Track detail parsing helpers
    mood/
      mood_model.dart                # Mood extraction/filter helpers

  pages/
    home_page.dart                   # Main browse screen
    trending_page.dart               # Placeholder trending screen
    controller/
      page_controller_custom.dart    # PageView wrapper controlled by notifier
      route_navigator.dart           # Navigation-related helper/scaffold

  service/
    fetch_live_nodes.dart            # Fetches healthy Audius mirrors
    gen_description.dart             # Fills mood/genre descriptions
    trending_service.dart            # Fetches trending tracks

  theme/
    theme_controller.dart            # Global theme mode notifier

  widgets/
    app_bar/                         # Custom top navigation components
    cover_art/                       # Artwork widget with cache/blur behavior
    featured_list/                   # Shelf-style section widget
    glass/                           # Glassmorphism widgets/animation
    music_box/                       # Reusable track card widget
```

## Core Terminology Used In This Codebase

This project already has its own vocabulary in comments, naming, and widget structure. If you continue building it, these are the terms the code already leans on:

- `Sub`: the main app shell under `main.dart`. It owns fetch/bootstrap behavior, notifiers, and top-level page composition.
- `trackDetails`: the parsed `List<AudiusModel>` used as the primary in-memory dataset for the UI.
- `pageNotifier`: a `ValueNotifier<int>` used to drive the current page in `PageControllerCustom`.
- `offsetNotifier`: a notifier intended for pagination/offset-based loading from the Audius endpoint.
- `isDetailsReady`: a simple readiness flag used before rendering pages that depend on fetched data.
- `TrendingService`: the service responsible for calling Audius trending endpoints and returning raw track payloads.
- `FetchLiveNodes`: the service that resolves healthy Audius mirrors and falls back to hardcoded `NodePoints` when needed.
- `AudiusModel`: the main domain model for a track. It holds IDs, artist/title metadata, popularity numbers, artwork map data, and available stream mirrors.
- `MoodModel`: a helper model used to extract, deduplicate, sort, and filter moods from track data.
- `GenreModel`: a helper model used to extract, deduplicate, sort, and filter genres from track data.
- `FeaturedMain`: a reusable section/shelf widget that renders a titled horizontal list.
- `BoxMain`: the reusable card used for mood tiles and track tiles.
- `CoverBoxMain`: the image widget responsible for artwork display, including local asset and network image handling.
- `GlassMain`, `GlassAnim`, `AppBarBlur`: visual building blocks for the blur/glass UI language used throughout the app shell.
- `NodePoints`: fallback mirror URLs for Audius streaming/discovery if live node fetching fails.
- `DescriptionChart`: shared description copy for moods and genres.

## Tech Stack

- Flutter
- Dart
- Audius API
- `http`
- `cached_network_image`
- `font_awesome_flutter`
- `gradient_blur`

## Running The Project

```bash
flutter pub get
flutter run
```

## Assets

The project currently registers local assets from:

```yaml
flutter:
  assets:
    - lib/assets/mood_covers/
```

Mood cards on the home screen depend on those local images and on the mapping inside `lib/global_var/links/mood_covers.dart`.

## Notes For Future Development

Based on the comments and TODOs currently in the code:

- Mood cards still need navigation to mood-specific track lists.
- Track cards still need a full playback / detail interaction path.
- `TrendingPage`, `For You`, `Library`, and `Search` are not built out yet.
- Pagination is partially implied by `limit` and `offsetNotifier`, but not yet expanded into a full loading flow.
- The UI architecture is already reusable enough to support dedicated mood pages, genre pages, and a player overlay/modal.

## Suggested Mental Model For Contributors

If you are working on this project, the simplest way to think about it is:

- `service/` gets raw data
- `models/` normalize it
- `sub.dart` bootstraps app state
- `pages/` decide screen composition
- `widgets/` render the reusable UI language
- `global_var/` stores shared constants, mappings, and tuning values

## Project Intent

This repository reads like a UI-first music product experiment: a sleek Flutter interface with Audius-powered content, strong emphasis on visual polish, and room to grow into richer discovery and playback flows.
