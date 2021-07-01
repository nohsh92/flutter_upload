import 'package:flutter/material.dart';
import 'package:loginpage/widgets/bottom_nav_widget.dart';

class LandingScreen extends StatelessWidget {
  static const String id = "LandingScreen";
  List<int> top = <int>[];
  List<int> bottom = <int>[0];

  @override
  List _buildList(int count) {
    List<Widget> listItems = [];
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
                  'Category ${i.toString()}',
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
        title: const Text('Landing Screen'),
      ),
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
