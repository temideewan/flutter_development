import 'package:flutter/material.dart';
import 'package:random_words/random_words.dart';

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

// part of the things we have to do

class _RandomWordsState extends State<RandomWords> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Word pair generator'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
          ],
        ),
        body: _buildList());
  }

  final _randomWordPairs = <WordPair>[];

  final _savedWordPairs = Set<WordPair>();
  Widget _buildList() {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: ((BuildContext context, int item) {
          if (item.isOdd) return Divider();
          final index = item ~/ 2;

          if (index >= _randomWordPairs.length) {
            _randomWordPairs.addAll(generateWordPairs().take(10));
          }

          return _buildRow(_randomWordPairs[index]);
        }));
  }

  Widget _buildRow(WordPair pair) {
    // check if the item already exists in the set of saved items -boolean
    final _alreadySaved = _savedWordPairs.contains(pair);

    return Container(
        child: ListTile(
          title: Text(pair.asPascalCase, style: TextStyle(fontSize: 18)),
          trailing: Icon(_alreadySaved ? Icons.favorite : Icons.favorite_border,
              color: _alreadySaved ? Colors.red[600] : null),
          onTap: () {
            setState(() {
              if (_alreadySaved) {
                _savedWordPairs.remove(pair);
              } else {
                _savedWordPairs.add(pair);
              }
            });
          },
        ),
        decoration: BoxDecoration(color: Colors.purple[50]),
        padding: EdgeInsets.all(3));
  }

  void _pushSaved() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      final Iterable<ListTile> tiles = _savedWordPairs.map((WordPair pair) {
        return ListTile(
          title: Text(pair.asPascalCase, style: TextStyle(fontSize: 16)),
        );
      });

      final List<Widget> divided =
          ListTile.divideTiles(context: context, tiles: tiles).toList();

      return Scaffold(
          appBar: AppBar(title: Text('saved word pairs')),
          body: ListView(children: divided));
    }));
  }
}
