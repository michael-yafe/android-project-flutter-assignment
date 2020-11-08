import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../UserFavorites.dart';
import '../common/them.dart';
class FavoritesScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    UserFavorites userFavorites = context.watch<UserFavorites>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Suggestions'),
      ),
      body: Builder(
          builder: (context) =>
              ListView(children: _getDividedListTile(context,userFavorites))),
    );
  }
  List<Widget> _getDividedListTile(BuildContext context, UserFavorites userFavorites) {

    final tiles = userFavorites.favorites.map(
          (name) {
        return ListTile(
            title: Text(
              name,
              style: biggerFont,
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: darkRed,
              ),
              onPressed: () {
                userFavorites.removeFavorite(name);
              },
            ));
      },
    );
    return ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();
  }
}

