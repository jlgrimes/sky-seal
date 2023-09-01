import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class AddCardScaffold extends StatefulWidget {
  @override
  State<AddCardScaffold> createState() => _AddCardScaffoldState();
}

class _AddCardScaffoldState extends State<AddCardScaffold> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch();
    });
  }

  Future<void> _performSearch() async {
    setState(() {
      _isLoading = true;
    });

    //Simulates waiting for an API call
    final http.Response response = await http.get(Uri.parse(
        'https://api.pokemontcg.io/v2/cards?q=name:${_searchController.text}'));
    final data = response.body;
    debugPrint(data);

    // await Future.delayed(const Duration(milliseconds: 1000));

    // setState(() {
    //   _filteredData = _data
    //       .where((element) => element
    //           .toLowerCase()
    //           .contains(_searchController.text.toLowerCase()))
    //       .toList();
    //   _isLoading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                child: TextField(
      controller: _searchController,
    ))));
  }
}
