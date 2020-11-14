import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:hello_me/common/them.dart';
import 'package:hello_me/screens/FavoritesScreen.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'LogInScreen.dart';
import '../UserFavorites.dart';
import '../UserState.dart';
import 'package:provider/provider.dart';

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  var _controller = SnappingSheetController();
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
                icon: Icon(loggingIcon),
                onPressed: () => _pushLoginOrLogOut(userState))
          ],
        ),
        body: userState.isAuthenticated()
            ? SnappingSheet(
                child: _buildSuggestions(),
                sheetBelow: SnappingSheetContent(
                  child: SheetContent(userState.useId),
                  heightBehavior: SnappingSheetHeight.fit(),
                ),
                snappingSheetController: _controller,
                grabbing: GestureDetector(
                  child: GrabSection(userState.useId),
                  onTap: () {
                    if (_controller.snapPositions.last !=
                        _controller.currentSnapPosition) {
                      _controller
                          .snapToPosition(_controller.snapPositions.last);
                    } else {
                      _controller
                          .snapToPosition(_controller.snapPositions.first);
                    }
                  },
                ),
                snapPositions: const [
                  SnapPosition(
                      positionFactor: 0,
                      snappingCurve: Curves.elasticOut,
                      snappingDuration: Duration(milliseconds: 500)),
                  SnapPosition(
                      positionPixel: 100,
                      snappingCurve: Curves.ease,
                      snappingDuration: Duration(milliseconds: 750))
                ],
              )
            : _buildSuggestions());
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

  void _pushLoginOrLogOut(UserState userState) {
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

class GrabSection extends StatelessWidget {
  final String _userName;

  GrabSection(this._userName);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(children: [
            Expanded(child: Text("Welcome back, $_userName")),
            Icon(Icons.keyboard_arrow_up_outlined)
          ]),
        ));
  }
}

class SheetContent extends StatelessWidget {
  final String _userName;

  SheetContent(this._userName);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 50,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                color: Colors.blue,
                width: 60,
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text("$_userName",style: TextStyle(fontSize: 20),),
                    ElevatedButton(
                      onPressed: null,
                      child: Text(
                        "Change avatar",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: greenButton,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
