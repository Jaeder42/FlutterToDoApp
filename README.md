# TODO.app: Flutter edition

## Förhandskrav / Installation

För att utveckla mot android ladda ner och installera Android studio, om du sitter på något annat än MacOS är detta ett krav.

Om du sitter på MacOS och vill utveckla mot iOS behöver du installera XCode.

Eller om du vill bygga till båda behöver båda vara installerade!

> ⚠️ **Installera Xcode eller Android Studio innan labben.** Installationen tar ca 30-45 min och det blir rätt långtråkigt att bara sitta och titta på.

Följ installationsstegen för flutter på https://flutter.io/get-started/install/ och dart på https://webdev.dartlang.org/tools/sdk#install för det operativsystem du känner dig bekväm med!

Om du inte har Visual Studio Code är det läge att installera det nu! Lägg sedan till den extension som heter "Flutter", och även "Dart". (Glöm inte klicka på **reload**!)

Se till att starta en iOS simulator om du vill utveckla mot den, på mac kan du söka efter "simulator" i spotlight. Eller öpnna en från XCode.

Sitter du på Windows eller vill jobba mot Android, kan du antingen bli utvecklare på din telefon. Sök på google efter hur man gör det på din specifika modell. Aktivera sedan USB-Debugging under developer settings och koppla in din telefon och välj att lita på datorn.

Alternativt startar du en Android emulator! Finns en liten lathund <a href="./extra/StartAndroidSimulator.markdown">här</a>.

## 1. Sätt upp ett nytt projekt

1. I Visual studio code klicka `cmd`+`shift`+`p` / `ctrl` + `shift`+ `p` för att öppna `Command Palette`.
2. Välj `Flutter: New Project`.
3. Välj ett snyggt namn, t.ex `todo_app` (om du här försöker bryta namnkonventionen kommer du få ett litet meddelande).
4. Välj en destination.

Nu borde du se den exempelapp som flutter initialiserat i `main.dart`!

5. Byt ut den kod som blivit autogenererad med nedanstående kod:

```dart
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
      home: new MyHomePage(title: 'TODO Home Page'),
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
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Center(
      child: new Text('Hello World'),
    ));
  }
}
```

6. Klicka `F5` för att köra!

## 2. Skapa en hårdkodad lista

För att skapa en lista behöver vi göra några saker i klassen `_MyHomePageState`.

1. Lägga till en hårdkodad lista av strängar som kan hålla våra TODO items

```dart
  List<String> _todoItems = ['Första', 'Andra', 'Tredje', 'Fjärde'];
```

2. Skriv om vår `build`-funktion så att den innehåller en listvy, till detta tillhör att definiera hur den ska byggas upp. Det finns en inbyggd funktion som itererar över en definierad längd och renderar ett listobjekt per iteration. Se koden nedan.

```dart
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text('TODO App')),
        body: new ListView.builder(
          itemCount: _todoItems.length,
          itemBuilder: (context, index) {
              return new ListTile(
                title: new Text(_todoItems[index]));
          },
        ));
  }
```

3. Klar! Nu finns en hårdkodad lista av "TODO items"

## 3. Lägg till nya poster!

1. Vi behöver en "lägg till"-knapp, en Floating Action Button fungerar bra för vårt mål! Och dessutom kan vi enkelt lägga till en sådan i vår "Scaffold". Under body i vår Scaffold lägger vi till en floatingActionButton, som nedan!

```dart
 floatingActionButton: new FloatingActionButton(
        onPressed: _addTodoItem,
        tooltip: 'Add task',
        child: new Icon(Icons.add)),
```

2. Nu borde \_addTodoItem vara felmarkerad i koden, så den funktionen ska vi nu lägga till! ovanför build-funktionen lägger vi till en tom funktion.

```dart
  _addTodoItem() {}
```

3. Inga fel! Men det händer inte mycket när man klickar på plusset. Det gör vi något åt. Det enklaste vi kan göra är att bara slänga in en sträng när man trycker. Så vi lägger till det i funktionen!

```dart
    _todoItems.add('Mer att göra!');
```

4. Konstigt, det händer fortfarande ingenting... Det är inte helt sant, saker läggs till i listan men listan renderas inte om. För att trigga en omrendering måste vi meddela att vårt state är uppdaterat. Den inbyggda funktionen setState löser detta åt oss!

```dart
  _addTodoItem() {
    setState(() {
      _todoItems.add('Mer att göra!');
    });
  }
```

5. Titta!

## 4. Be användaren om data!

1. Det är ju lite tråkigt att bara lägga till något hårdkodat om och om igen i en lista så nästa steg är att be användaren om vad ett item ska innehålla! Vi lägger till en Dialog som tar in text!

```dart
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
```

Och ropar på denna funktion när vi klickar på pluset.

```dart
 floatingActionButton: new FloatingActionButton(
          onPressed: _showDialog,
          tooltip: 'Add TODO',
          child: new Icon(Icons.add)),
    );
```

## 5. Ta bort skapade poster!

1. Det finns i Flutter en widget som låter oss "svepa iväg" listposter. Vi behöver därför ersätta våra listposter. Vi börjar med att bryta ut renderingen av listposterna. Och slänger på en liten divider när vi ändå refaktorerar!

```dart
itemBuilder: (context, index) {
          return _buildItem(_todoItems[index], index, context);
        },
```

```dart
  _buildItem(todoItemText, index, context){
    return Container(
          child: new ListTile(title: new Text(todoItemText)),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black26))),
        )
  }
```

2. Nu vill vi wrappa vår rendering med en Dismissible, som gör att vi kan "svepa bort".

```dart
  _buildItem(todoItemText, index, context) {
    return new Dismissible(
      key: Key(todoItemText),
      onDismissed: (direction) {
        setState(() {
          _todoItems.removeAt(index);
        });
      },
      child: Container(
          child: new ListTile(title: new Text(todoItemText)),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black26))),
        )
    );
  }
```

3. För att göra det lite snyggare lägger vi till en bakgrundsfärg på fältet!

```dart
  _buildItem(todoItemText, index, context) {
    return new Dismissible(
      key: Key(todoItemText),
      background: Container(color: Colors.red[900]),
      onDismissed: (direction) {
        setState(() {
          _todoItems.removeAt(index);
        });
      },
      child: Container(
          child: new ListTile(title: new Text(todoItemText)),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black26))),
        )
    );
  }
```

4. Grymt! Men vad händer när man sveper bort en av misstag? Eftersom vi kört material design hittills slänger vi på en snackbar, ett systemmeddelande som kan innehålla en action. I vårat fall vill vi lägga till en ångra-knapp!

```dart
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
      child: Container(
          child: new ListTile(title: new Text(todoItemText)),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black26))),
        )
    );
  }
```
