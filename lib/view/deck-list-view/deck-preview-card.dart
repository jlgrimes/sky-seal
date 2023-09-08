import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sky_seal/deck_builder.dart';
import 'package:sky_seal/view/deck-list-view/DeckPermissions.dart';
import 'package:sky_seal/view/deck-list-view/deck-preview-metadata.dart';
import 'package:sky_seal/view/state/app_state_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

class DeckPreviewCard extends StatelessWidget {
  DeckPreviewMetadata deckPreviewMetadata;
  DeckPermissions permissions;

  DeckPreviewCard(
      {required this.deckPreviewMetadata, required this.permissions});

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState =
        Provider.of<AppStateProvider>(context, listen: false);

    return GestureDetector(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DeckBuilder(
                      deckId: deckPreviewMetadata.id,
                      deckName: deckPreviewMetadata.name,
                      permissions: permissions)));
        },
        child: Card(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AspectRatio(
              aspectRatio: 2,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                    image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      alignment: FractionalOffset.fromOffsetAndSize(
                          const Offset(0, 90), const Size(500, 500)),
                      image:
                          NetworkImage(deckPreviewMetadata.featuredCardImgUrl),
                    )),
              )),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              deckPreviewMetadata.name,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          )
        ])));
  }
}
