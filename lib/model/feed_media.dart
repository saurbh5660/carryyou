enum MediaType { image, video }

class FeedMedia {
  final String url;
  final MediaType type;

  FeedMedia({
    required this.url,
    required this.type,
  });
}
