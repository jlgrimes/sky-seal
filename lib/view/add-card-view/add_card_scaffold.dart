import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skeletonizer/skeletonizer.dart';
import 'package:concealed/structs/Card.dart';
import 'dart:async';

import 'package:concealed/view/add-card-view/CardPreview.dart';
import 'package:concealed/view/primatives/constants.dart';

class AddCardScaffold extends StatefulWidget {
  final Function(PokemonCard card) addCardCallback;

  AddCardScaffold({required this.addCardCallback});

  @override
  State<AddCardScaffold> createState() => _AddCardScaffoldState();
}

class _AddCardScaffoldState extends State<AddCardScaffold> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  List<PokemonCard> _results = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  _onSearchChanged() {
    if (_searchController.text.length < 3) return;

    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      setState(() {
        _isLoading = true;
      });

      _performSearch();
    });
  }

  Future<void> _performSearch() async {
    if (!mounted) return;

    //Simulates waiting for an API call
    final http.Response response = await http.get(Uri.parse(
        'https://api.pokemontcg.io/v2/cards?q=name:"${_searchController.text}"&pageSize=9&orderBy=-set.releaseDate'));

    // Put a sad face on the screen or something
    if (response.statusCode == 400) return;

    final Map<String, dynamic> data = json.decode(response.body);
    final List<Map<String, dynamic>> cardList =
        List<Map<String, dynamic>>.from(data['data']);
    final List<PokemonCard> cards = cardList
        .map((card) => PokemonCard(
            code: card['id'],
            supertype:
                card.containsKey('supertype') ? card['supertype'] : '_invalid',
            subtype: card.containsKey('subtype') ? card['subtype'] : '_invalid',
            rarity: card.containsKey('rarity') ? card['rarity'] : '_invalid',
            count: 1))
        .toList();

    // await Future.delayed(const Duration(milliseconds: 1000));
    for (final card in cards) {
      await card.preloadImage(context);
    }

    setState(() {
      _results = cards;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                child: Column(children: [
      TextField(
        controller: _searchController,
        autofocus: true,
        decoration: InputDecoration(
            suffixIcon: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context)),
            prefixIcon: const Icon(Icons.search)),
      ),
      Expanded(
        child: Skeletonizer(
            enabled: _isLoading,
            child: GridView.count(
                crossAxisCount: 3,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                childAspectRatio: cardAspectRatio,
                mainAxisSpacing: 6.0,
                crossAxisSpacing: 6.0,
                padding: const EdgeInsets.all(6.0),
                children: _isLoading
                    ? [
                        Image.network(
                            'https://images.pokemontcg.io/pop6/3_hires.png'),
                        Image.network(
                            'https://images.pokemontcg.io/pop6/3_hires.png'),
                        Image.network(
                            'https://images.pokemontcg.io/pop6/3_hires.png'),
                        Image.network(
                            'https://images.pokemontcg.io/pop6/3_hires.png'),
                        Image.network(
                            'https://images.pokemontcg.io/pop6/3_hires.png'),
                        Image.network(
                            'https://images.pokemontcg.io/pop6/3_hires.png'),
                        Image.network(
                            'https://images.pokemontcg.io/pop6/3_hires.png'),
                        Image.network(
                            'https://images.pokemontcg.io/pop6/3_hires.png'),
                        Image.network(
                            'https://images.pokemontcg.io/pop6/3_hires.png'),
                      ]
                    : _results
                        .map((e) => GestureDetector(
                              onTap: () {
                                widget.addCardCallback(e);
                                Navigator.pop(context);
                              },
                              child: e.image,
                            ))
                        .toList())),
      )
    ]))));
  }
}
