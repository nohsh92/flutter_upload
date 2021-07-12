import 'package:flutter/material.dart';
import 'package:loginpage/widgets/tab_item.dart';

void pushBottomNav() {
  Navigator.of(context).push(MaterialPageRoute(
    // we'll look at ColorDetailPage later
    builder: (context) => ColorDetailPage(
      color: activeTabColor[TabItem.Items],
      title: tabName[TabItem.Items],
    ),
  ));
}
