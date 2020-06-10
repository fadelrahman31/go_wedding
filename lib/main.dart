import 'package:flutter/material.dart';
import 'package:go_wedding/page2.dart';
import 'page1.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
 // This widget is the root of your application.
 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     title: 'Everglow',
     theme: ThemeData(
       primarySwatch: Colors.blue,
     ),
     home: MyHomePage(title: 'Flutter Demo Home Page'),
   );
 }
}

class MyHomePage extends StatefulWidget {
 const MyHomePage({Key key, this.title}) : super(key: key);

 final String title;

 @override
 State<StatefulWidget> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<MyHomePage> {
 int _currentTabIndex = 0;

 Widget build(BuildContext context) {
   final _kTabPages = <Widget>[
     Center(
       child: PageOne(),
     ),
     Center(
       child: PageTwo(),
     )
   ];

   final _kBottomNavbarItem = <BottomNavigationBarItem>[
     BottomNavigationBarItem(
         title: Text('Page 1'),
         icon: Icon(Icons.apps)
     ),
     BottomNavigationBarItem(
         title: Text('Page 2'),
         icon: Icon(Icons.supervised_user_circle)
     ),
   ];
   assert(_kTabPages.length == _kBottomNavbarItem.length);
   final bottomNavBar = BottomNavigationBar(
     items: _kBottomNavbarItem,
     currentIndex: _currentTabIndex,
     type: BottomNavigationBarType.fixed,
     onTap: (int index){
       setState(() {
         _currentTabIndex = index;
       });
     },
   );
   return Scaffold(
     appBar: AppBar(
       title: Text("EVERGLOW"),
     ),
     body: _kTabPages[_currentTabIndex],
     bottomNavigationBar: BottomAppBar(
       shape: CircularNotchedRectangle(),
       child: bottomNavBar,
     ),
   );
 }
}

//class _MyHomePageState extends State<MyHomePage> {
//  int _counter = 0;
//
//  void _incrementCounter() {
//    setState(() {
//      _counter++;
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text(widget.title),
//      ),
//      body: Center(
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Text(
//              'You have pushed the button this many times:',
//            ),
//            Text(
//              '$_counter',
//              style: Theme.of(context).textTheme.display1,
//            ),
//          ],
//        ),
//      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _incrementCounter,
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
//    );
//  }
//}
