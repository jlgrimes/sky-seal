import 'package:concealed/util/sets.dart';

class DeckPreviewMetadata {
  String id;
  String name;
  String featuredCard;
  late String featuredCardImgUrl;

  DeckPreviewMetadata(
      {required this.id, required this.name, required this.featuredCard}) {
    featuredCardImgUrl = convertSetCodeToImageUrl(featuredCard);
  }
}
