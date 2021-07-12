// tab_item.dart

import 'package:flutter/material.dart';

enum TabItem { Items, AddItem, Logout }

const Map<TabItem, String> tabName = {
  TabItem.Items: 'items',
  TabItem.AddItem: 'additem',
  TabItem.Logout: 'logout',
};

const Map<TabItem, MaterialColor> activeTabColor = {
  TabItem.Items: Colors.blue,
  TabItem.AddItem: Colors.green,
  TabItem.Logout: Colors.red,
};
