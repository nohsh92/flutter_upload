import 'package:flutter/material.dart';
import 'package:loginpage/widgets/tab_item.dart';

class BottomNavigation extends StatelessWidget {
  BottomNavigation({@required this.currentTab, @required this.onSelectTab});
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        _buildItem(TabItem.Items),
        _buildItem(TabItem.AddItem),
        _buildItem(TabItem.Logout),
      ],
      onTap: (index) => onSelectTab(
        TabItem.values[index],
      ),
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    return BottomNavigationBarItem(
      icon: Icon(
        Icons.layers,
        color: _colorTabMatching(tabItem),
      ),
      label: tabName[tabItem],
    );
  }

  Color _colorTabMatching(TabItem item) {
    return currentTab == item ? activeTabColor[item] : Colors.grey;
  }
}
