class DeckPreviewMetadata {
  String id;
  String name;
  late String featuredCardImgUrl;

  DeckPreviewMetadata({required this.id, required this.name}) {
    featuredCardImgUrl = 'https://images.pokemontcg.io/sv2/61_hires.png';
  }
}
