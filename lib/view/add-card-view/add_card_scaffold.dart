import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:sky_seal/view/add-card-view/CardPreview.dart';

class AddCardScaffold extends StatefulWidget {
  final Function(String code) addCardCallback;

  AddCardScaffold({required this.addCardCallback});

  @override
  State<AddCardScaffold> createState() => _AddCardScaffoldState();
}

class _AddCardScaffoldState extends State<AddCardScaffold> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  List<CardPreview> _results = [];
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
      _performSearch();
    });
  }

  Future<void> _performSearch() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    //Simulates waiting for an API call
    final http.Response response = await http.get(Uri.parse(
        'https://api.pokemontcg.io/v2/cards?q=name:"${_searchController.text}"&pageSize=9&orderBy=-set.releaseDate'));

    // Put a sad face on the screen or something
    if (response.statusCode == 400) return;

    final Map<String, dynamic> data = json.decode(response.body);
    final List<Map<String, dynamic>> cardList =
        List<Map<String, dynamic>>.from(data['data']);
    final List<CardPreview> cards = cardList
        .map((card) =>
            CardPreview(code: card['id'], imgUrl: card['images']['large']))
        .toList();

    // await Future.delayed(const Duration(milliseconds: 1000));

    setState(() {
      _results = cards;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Container(
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
          child: GridView.count(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              crossAxisCount: 2,
              children: _results
                  .map((e) => GestureDetector(
                        onTap: () {
                          widget.addCardCallback(e.code);
                          Navigator.pop(context);
                        },
                        child: Image.network(e.imgUrl),
                      ))
                  .toList()),
        )
      ])))
    );
  }
}
