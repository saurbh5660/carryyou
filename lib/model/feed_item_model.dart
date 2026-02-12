import 'feed_media.dart';

class FeedItemModel {
  final String id;
  final String userName;
  final String location;
  final String profileImage;
  final List<FeedMedia> media;
  final String caption;

  FeedItemModel({
    required this.id,
    required this.userName,
    required this.location,
    required this.profileImage,
    required this.media,
    required this.caption,
  });
}
