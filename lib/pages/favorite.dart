import 'package:carrot_market_sample/repository/contents_repository.dart';
import 'package:flutter/material.dart';
import 'detail.dart';
import 'package:carrot_market_sample/utils/data_utils.dart';
import 'package:flutter_svg/svg.dart';

class MyFavoriteContents extends StatefulWidget {
  MyFavoriteContents({Key key}) : super(key: key);

  @override
  _MyFavoriteContentsState createState() => _MyFavoriteContentsState();
}

class _MyFavoriteContentsState extends State<MyFavoriteContents> {
  ContentsRepository contentsRepository;
  @override
  void initState() {
    super.initState();
    contentsRepository = ContentsRepository();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarWidget(),
      body: _bodyWidget(),
    );
  }

  Widget _appBarWidget() {
    return AppBar(
        title: Text(
      "관심목록",
      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    ));
  }

  Widget _bodyWidget() {
    return FutureBuilder(
        future: _loadMyContentsList(),
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

  Future<List<dynamic>> _loadMyContentsList() async {
    return await contentsRepository.loadFavoriteContents();
  }

  Widget makeDataList(List<dynamic> datas) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    DetailContentView(data: datas[index]),
              ),
            );
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
                          Text(DataUtils.calcStringToWon(datas[index]["price"]),
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
      itemCount: datas.length,
    );
  }
}
