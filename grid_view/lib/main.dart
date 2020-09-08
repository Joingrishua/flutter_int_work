import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  final List<String> _listItems = [
    'Hair',
    'Artistry',
    'Ayurveda',
    'Nutrition',
    'Beauty',
    'Nail Art',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[600],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Icon(
            Icons.menu,
          ),
          title: Text('Search'),
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Container(
                  height:  ,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage('assets/Images/addImage.jpg'),
                        fit: BoxFit.fill,
                      )),
                  child: Container(
                    //height: 200.0,
                    padding: EdgeInsets.all(5.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Card(
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  onTap: () {},
                                  child: Icon(Icons.search),
                                ),
                                contentPadding: EdgeInsets.all(5.0),
                                labelText: "Search...",
                                border: InputBorder.none),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.count(
                           crossAxisCount: 2,
                           padding: EdgeInsets.all(20),
                           crossAxisSpacing: 20,
                           mainAxisSpacing: 20,
                           children: _listItems
                               .map((item) => Card(
                                     child: Container(
                                       child: Text(item),
                                     ),
                                   ))
                              .toList(),
                        ),
                ),
              ],
            ),
          ),
        ));
  }
}
