import 'package:get/get.dart';

import '../generated/assets.dart';
import '../model/feed_item_model.dart';
import '../model/feed_media.dart';

class FeedController extends GetxController {
  final pageIndex = 0.obs;
  RxList<FeedItemModel> feedList = RxList();

  void onPageChanged(int index) {
    pageIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    feedList.clear();
    feedList.addAll([
      FeedItemModel(
        id: "1",
        userName: "Katy",
        location: "New York City",
        profileImage: Assets.iconsProfileIcon,
        caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
        media: [
          FeedMedia(url: Assets.imagesDummyImage, type: MediaType.image),
          FeedMedia(url: Assets.imagesImage1, type: MediaType.image),
        ],
      ),
      FeedItemModel(
        id: "2",
        userName: "Katy",
        location: "New York City",
        profileImage: Assets.iconsProfileIcon,
        caption: "Mauris road lorem ipsum dolor sit amet.",
        media: [
          FeedMedia(url: Assets.imagesDummyImage, type: MediaType.image),
          FeedMedia(url: Assets.imagesImage1, type: MediaType.image),
        ],
      ),
      FeedItemModel(
        id: "3",
        userName: "Katy",
        location: "New York City",
        profileImage: Assets.iconsProfileIcon,
        caption: "Mauris road lorem ipsum dolor sit amet.",
        media: [
          FeedMedia(url: Assets.imagesDummyImage, type: MediaType.image),
          FeedMedia(url: Assets.imagesImage1, type: MediaType.image),
        ],
      ),
      FeedItemModel(
        id: "4",
        userName: "Katy",
        location: "New York City",
        profileImage: Assets.iconsProfileIcon,
        caption: "Mauris road lorem ipsum dolor sit amet.",
        media: [
          FeedMedia(url: Assets.imagesDummyImage, type: MediaType.image),
          FeedMedia(url: Assets.imagesImage1, type: MediaType.image),
        ],
      ),
      FeedItemModel(
        id: "5",
        userName: "Katy",
        location: "New York City",
        profileImage: Assets.iconsProfileIcon,
        caption: "Mauris road lorem ipsum dolor sit amet.",
        media: [
          FeedMedia(url: Assets.imagesDummyImage, type: MediaType.image),
          FeedMedia(url: Assets.imagesImage1, type: MediaType.image),
          // FeedMedia(url: "video_url_here", type: MediaType.image),
        ],
      ),
    ]);
  }
}
