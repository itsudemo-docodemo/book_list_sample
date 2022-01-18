import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Detail extends StatelessWidget {
  //イニシャライザ
  Detail(this.year, this.nenrei, this.zandaka, this.shunyu1, this.shunyu2,
      this.shunyu3, this.shishutsu);
  List<int> year = [];
  List<double> nenrei = [];
  List<double> zandaka = [];
  List<double> shunyu1 = [];
  List<double> shunyu2 = [];
  List<double> shunyu3 = [];
  List<double> shishutsu = [];

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat("#,###");
    return Scaffold(
      appBar: AppBar(
        title: Text('詳細'),
      ),
      body: ListView.builder(
        itemCount: year.length - 1,
        itemBuilder: (BuildContext context, int index) {
          /*
          return Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black38),
                ),
              ),
              child: ListTile(
                leading: Text('${year[index]}'),
                title: Text('${zandaka[index].toInt()}'),
                subtitle: Text('${zandaka[index].toInt()}'),
                trailing: Text('円'),
//                onTap: () { /* react to the tile being tapped */ },
              )
          );
          */
          return Card(
            child: Padding(
              child: Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("年（年齢）"),
                        Text("貯金残高"),
                        Text("収入"),
                        Text("", style: TextStyle(fontSize: 10.0)),
                        Text("", style: TextStyle(fontSize: 10.0)),
                        Text("", style: TextStyle(fontSize: 10.0)),
                        Text("支出"),
                      ],
                    ),
                  ),
                  Container(
//                    width: 180,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('${year[index]}年（${nenrei[index]}歳）'),
                        Text('${formatter.format(zandaka[index].toInt())}万円'),
                        Text(
                            '${(shunyu1[index] + shunyu2[index] + shunyu3[index]).toInt()}万円'),
                        Text('（利息・配当金：${shunyu1[index].toInt()}万円）',
                            style: TextStyle(fontSize: 10.0)),
                        Text('（年金：${shunyu2[index].toInt()}万円）',
                            style: TextStyle(fontSize: 10.0)),
                        Text('（その他所得：${shunyu3[index].toInt()}万円）',
                            style: TextStyle(fontSize: 10.0)),
                        Text('${shishutsu[index].toInt()}万円'),
                      ],
                    ),
                  ),
                ],
              ),
              /*
              child: Text(
                '${year[index]}',
                style: TextStyle(fontSize: 22.0),
              ),
              */
              padding: EdgeInsets.all(10.0),
            ),
          );
        },
      ),
    );
  }
}
