class GenDescription {

  // This class generates description for the given mood or genre
  // During the call, both the mood/genre and their respective descriptions are
  // to be provided making it a single simple service class.

  static Map<String, String> fillDescription(
    List<String> moodOrGenre,
    Map<String, String> theirDescriptions,
  ) {
    return {
      for (var key in moodOrGenre) key: theirDescriptions[key] ?? "",
    };
  }
}
