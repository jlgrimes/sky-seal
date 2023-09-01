import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sky_seal/view/add-card-view/add_card_scaffold.dart';
import 'package:sky_seal/view/deck-view/deck_view.dart';
import 'package:sky_seal/view/state/app_state_provider.dart';

class DeckBuilder extends StatefulWidget {
  @override
  State<DeckBuilder> createState() => _DeckBuilderState();
}

class _DeckBuilderState extends State<DeckBuilder> {
  @override
  Widget build(BuildContext context) {
    AppStateProvider appState =
        Provider.of<AppStateProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Deck builder'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[DeckView()],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddCardScaffold(
                        addCardCallback: appState.addCardToDeck,
                      )));
        },
        label: const Text('Add card'),
        icon: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: BottomAppBar(
            child: Row(
          children: [
            IconButton(
                onPressed: () => {}, icon: const Icon(Icons.save_outlined))
          ],
        )),
      ),
    );
  }
}
