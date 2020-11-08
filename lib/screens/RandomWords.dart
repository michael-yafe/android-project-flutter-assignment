import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:hello_me/screens/FavoritesScreen.dart';
import 'LogInScreen.dart';
import '../UserFavorites.dart';
import '../UserState.dart';
import 'package:provider/provider.dart';

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final List<WordPair> _suggestions = <WordPair>[];
  final TextStyle _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    UserState userState = context.watch<UserState>();
    var loggingIcon =
        userState.isAuthenticated() ? Icons.exit_to_app : Icons.login;
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
          IconButton(
              icon: Icon(loggingIcon), onPressed: () => _pushLogin(userState))
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (BuildContext _context, int i) {
          if (i.isOdd) {
            return Divider();
          }
          final int index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index].asPascalCase);
        });
  }

  Widget _buildRow(String name) {
    return Consumer<UserFavorites>(builder: (context, userFavorites, _) {
      final alreadySaved = userFavorites.isFavorite(name);
      return ListTile(
        title: Text(
          name,
          style: _biggerFont,
        ),
        trailing: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
        ),
        onTap: () {
          setState(() {
            if (alreadySaved) {
              userFavorites.removeFavorite(name);
            } else {
              userFavorites.addFavorite(name);
            }
          });
        },
      );
    });
  }

  void _pushLogin(UserState userState) {
    if (userState.isAuthenticated()) {
      userState.singOut();
      Provider.of<UserFavorites>(context, listen: false).clear();
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (BuildContext context) {
        return LogInScreen();
      }));
    }
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return FavoritesScreen();
        }, // ...to here.
      ),
    );
  }
}
