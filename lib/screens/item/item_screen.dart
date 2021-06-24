import 'package:flutter/material.dart';
import 'package:loginpage/main.dart';
import 'package:loginpage/widgets/bottom_nav_widget.dart';

class ItemScreen extends StatelessWidget {
  static const String id = "ItemScreen";
  List _buildList(int count) {
    List<Widget> listItems = List();
    for (int i = 0; i < count; i++) {
      listItems.add(
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            child: Card(
              color: Colors.grey.shade800,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Item ${i.toString()}',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.blue.shade200,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return listItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text('Items'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add_a_photo),
              tooltip: 'Add Photo',
              onPressed: () => Navigator.pushNamed(context, Uploader.id),
            )
          ]),
      body: CustomScrollView(
        slivers: [
          // Have to find a way to populate the list from DB
          SliverList(
            delegate: SliverChildListDelegate(_buildList(10)),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavWidget(),
    );
  }
}
