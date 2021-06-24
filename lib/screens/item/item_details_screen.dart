import 'package:flutter/material.dart';
import 'package:loginpage/widgets/bottom_nav_widget.dart';

class ItemDetailScreen extends StatelessWidget {
  static const String id = "ItemDetailScreen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Items'),
      ),
      body: CustomScrollView(
        slivers: [
          // Going to use on the item page later
          SliverAppBar(
            expandedHeight: 300.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                'images/bg1.jpg',
                fit: BoxFit.cover,
              ),
              stretchModes: [
                StretchMode.zoomBackground,
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavWidget(),
    );
  }
}
