import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
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
  List<String> _todoItems = ['Första', 'Andra', 'Tredje'];

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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('TODO App')),
      body: new ListView.builder(
        itemCount: _todoItems.length,
        itemBuilder: (context, index) {
          return new ListTile(title: new Text(_todoItems[index]));
        },
      ),
      floatingActionButton: new FloatingActionButton(
          onPressed: _showDialog,
          tooltip: 'Add TODO',
          child: new Icon(Icons.add)),
    );
  }
}
