import 'package:carrot_market_sample/pages/detail.dart';
import 'package:carrot_market_sample/repository/contents_repository.dart';
import 'package:carrot_market_sample/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String currentLocation;
  ContentsRepository contentsRepository;
  List<Map<String, String>> datas = [];
  Map locationString = {
    "ara": "아라동",
    "ora": "오라동",
    "donam": "도남동",
  };

  @override
  void initState() {
    super.initState();
    currentLocation = "ara";
    datas = [];

    print("initState - currentLocation : $currentLocation");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didChangeDependencies - currentLocation : $currentLocation");
    contentsRepository = ContentsRepository();
  }

  Widget _appBarWidget() {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          print("onTap");
        },
        child: PopupMenuButton<String>(
          offset: Offset(0, 30),
          shape: ShapeBorder.lerp(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              1),
          onSelected: (String where) {
            print("where $where");
            setState(() {
              currentLocation = where;
            });
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(value: "ara", child: Text("아라동")),
              PopupMenuItem(value: "ora", child: Text("오라동")),
              PopupMenuItem(value: "donam", child: Text("도남동")),
            ];
          },
          child: Row(
            children: [
              Text(locationString[currentLocation]),
              Icon(Icons.arrow_drop_down)
            ],
          ),
        ),
      ),
      elevation: 1,
      actions: [
        IconButton(icon: Icon(Icons.search), onPressed: () {}),
        IconButton(icon: Icon(Icons.tune), onPressed: () {}),
        IconButton(
            icon: SvgPicture.asset("assets/svg/bell.svg", width: 22),
            onPressed: () {}),
      ],
    );
  }

  loadContents() {
    return contentsRepository.loadContnetsFromLocation(currentLocation);
  }

  Widget makeDataList(datas) {
    return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (BuildContext _context, int index) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          DetailContentView(data: datas[index])));
            },
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    ClipRRect(
                        child: Hero(
                          tag: datas[index]["cid"],
                          child: Image.asset(datas[index]["image"],
                              width: 100, height: 100),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              datas[index]["title"],
                              style: TextStyle(fontSize: 15),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 5),
                            Text(datas[index]["location"],
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.3))),
                            SizedBox(height: 5),
                            Text(
                                DataUtils.calcStringToWon(
                                    datas[index]["price"]),
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            SizedBox(height: 5),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SvgPicture.asset('assets/svg/heart_off.svg',
                                      width: 13, height: 13),
                                  SizedBox(width: 5),
                                  Text(datas[index]["likes"]),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )),
          );
        },
        separatorBuilder: (BuildContext _context, int index) {
          return Container(height: 1, color: Colors.black.withOpacity(0.4));
        },
        itemCount: 10);
  }

  Widget _bodyWidget() {
    return FutureBuilder(
        future: loadContents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("데이터 오류"));
          }

          if (snapshot.hasData) {
            return makeDataList(snapshot.data);
          }

          return Center(child: Text("해당지역에 데이터가 없습니다."));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarWidget(),
      body: _bodyWidget(),
    );
  }
}
