import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import 'home.dart';
import 'favorite.dart';

class App extends StatefulWidget {
  const App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentPageIndex;

  @override
  void initState() {
    super.initState();
    _currentPageIndex = 0;
  }

  Widget _bodyWidget() {
    switch (_currentPageIndex) {
      case 0:
        return Home();
        break;
      case 1:
        return Container();
        break;
      case 2:
        return Container();
        break;
      case 3:
        return Container();
        break;
      case 4:
        return MyFavoriteContents();
        break;
    }
    return Container();
  }

  BottomNavigationBarItem _bottomNavigationItem(String name, String label) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 3),
        child: SvgPicture.asset("assets/svg/${name}_off.svg", width: 22),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 3),
        child: SvgPicture.asset(
          "assets/svg/${name}_on.svg",
          width: 22,
        ),
      ),
      label: label,
    );
  }

  Widget _buttonNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentPageIndex,
      onTap: (int index) => {
        setState(() => {_currentPageIndex = index})
      },
      selectedItemColor: Colors.black,
      selectedFontSize: 12,
      items: [
        _bottomNavigationItem("home", "홈"),
        _bottomNavigationItem("notes", "동네생활"),
        _bottomNavigationItem("location", "내 근처"),
        _bottomNavigationItem("chat", "채팅"),
        _bottomNavigationItem("user", "나의 당근"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _bodyWidget(), bottomNavigationBar: _buttonNavigationBar());
  }
}
