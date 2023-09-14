String convertSetCodeToImageUrl(String setCode) {
  if (!setCode.contains('-')) return '';

  if (setCode.contains('swshp')) {
    final setInfo = setCode.split('-');
    return 'https://images.pokemontcg.io/${setInfo[0]}/SWSH${setInfo[1]}_hires.png';
  }

  return 'https://images.pokemontcg.io/${setCode.replaceAll('-', '/')}_hires.png';
}
