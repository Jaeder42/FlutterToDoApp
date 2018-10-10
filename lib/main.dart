import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'TODO App',
      theme: new ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: new MyHomePage(title: 'TODO App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _todoItems = [];

  _addTodoItem(newItemText) {
    setState(() {
      _todoItems.add(newItemText);
    });
  }

  _showDialog() async {
    final textController = TextEditingController();
    var result = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text('Ny TODO'),
            content: new TextField(controller: textController),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Lägg till'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
    _addTodoItem(textController.text);
    return result;
  }

  _buildItem(todoItemText, index, context) {
    return new Dismissible(
      key: Key(todoItemText),
      background: Container(color: Colors.red[900]),
      onDismissed: (direction) {
        setState(() {
          _todoItems.removeAt(index);
        });
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("$todoItemText borttagen"),
          action: SnackBarAction(
            label: 'Ångra',
            onPressed: () {
              setState(() {
                _todoItems.insert(index, todoItemText);
              });
            },
          ),
        ));
      },
      child: new ListTile(title: new Text(todoItemText)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('TODO App')),
      body: new ListView.builder(
        itemCount: _todoItems.length,
        itemBuilder: (context, index) {
          return _buildItem(_todoItems[index], index, context);
        },
      ),
      floatingActionButton: new FloatingActionButton(
          onPressed: _showDialog,
          tooltip: 'Add TODO',
          child: new Icon(Icons.add)),
    );
  }
}
