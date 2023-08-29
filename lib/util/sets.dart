String convertSetCodeToImageUrl(String setCode) {
  if (!setCode.contains('-')) return '';

  return 'https://images.pokemontcg.io/${setCode.replaceAll('-', '/')}_hires.png';
}
