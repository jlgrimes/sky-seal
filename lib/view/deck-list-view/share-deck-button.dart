import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:concealed/view/state/app_state_provider.dart';

class ShareDeckButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = Provider.of<AppStateProvider>(context);

    return IconButton(
        onPressed: () {
          _dialogBuilder(context,
              'https://concealed.cards/${appState.deck.id.toString()}');
          // Share.share(
          //     'https://skyseal.app/${appState.deck.id.toString()}');
        },
        icon: Icon(Platform.isIOS ? Icons.ios_share : Icons.share));
  }

  Future<void> _dialogBuilder(BuildContext context, String shareUrl) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Share deck'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: 235,
                  height: 235,
                  child: QrImageView(
                    data: shareUrl,
                    size: 235.0,
                  ))
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
