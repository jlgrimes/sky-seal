import 'package:supabase_flutter/supabase_flutter.dart';

class DeckPermissions {
  String ownerOfDeck;
  late String currentUser;

  DeckPermissions({required this.ownerOfDeck}) {
    final currentUser = Supabase.instance.client.auth.currentUser?.id;

    if (currentUser == null) throw 'User not logged in';

    this.currentUser = currentUser;
  }

  canEdit() {
    return ownerOfDeck == currentUser;
  }
}
