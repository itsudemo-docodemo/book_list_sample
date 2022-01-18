import 'package:book_list_sample/3_detail/detail_page.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'dart:math';

List<int> year = [];
List<double> nenrei = [];
List<double> shunyu1 = [];
List<double> shunyu2 = [];
List<double> shunyu3 = [];
List<double> shishutsu = [];
List<double> zandaka = [];
int _counter = 0;

class Chart extends StatelessWidget {
  //イニシャライザ
  Chart(this.value_items);
  List<double> value_items = [];

  int first_year = 2020;

  void _calculate() {
    var index = 0;

    if (year.isEmpty == false) {
      year.clear();
    }
    if (zandaka.isEmpty == false) {
      zandaka.clear();
    }
    //残高が０になるまで計算
    do {
      //年
      year.add(first_year + index);
      //年齢
      nenrei.add(value_items[0] + index);
      if (index == 0) {
        //残高（初年度）
        zandaka.add(value_items[1]);
        //支出（初年度）
        shishutsu.add(value_items[3]);
      } else {
        //残高 = 前年残高 + 前年収入１ + 前年収入２ - 前年支出
        zandaka.add(zandaka[index - 1] +
            shunyu1[index - 1] +
            shunyu2[index - 1] +
            shunyu3[index - 1] -
            shishutsu[index - 1]);
        //支出 = 前年支出 * 年間インフレ率
        shishutsu.add(shishutsu[index - 1] * (1.0 + value_items[6] / 100));
      }
      //収入１（利息・配当金） = 残高 * 投資利回り(20%税引後)
      shunyu1.add(zandaka[index] * (value_items[2] / 100.0) * 0.8);
      //収入２（年金）
      if (nenrei[index] < value_items[4]) {
        //年金受給開始までは０
        shunyu2.add(0);
      } else {
        //年間受給額 * 年間インフレ率
        shunyu2.add(
            value_items[5] * 12 * pow((1.0 + value_items[6] / 100), index));
//        shunyu2.add(value_items[5] * 12);インフレ連動無しの場合
      }
      //収入３（年間その他所得）
      shunyu3.add(value_items[7] * 12);
/*
      print('index:${index}----------------------');
      print('年齢：${nenrei[index]}');
      print('残高：${zandaka[index]}');
      print('収入１：${shunyu1[index]}');
      print('収入２：${shunyu2[index]}');
      print('収入３：${shunyu3[index]}');
      print('支出：${shishutsu[index]}');
*/
      index++;
    } while (0 < zandaka[index - 1]);

//    setState(() {
    _counter = nenrei[index - 2].toInt();
//    });
  }

  @override
  Widget build(BuildContext context) {
    //計算する
    _calculate();
    return Scaffold(
      appBar: AppBar(
        title: Text('計算結果'),
        //戻るボタン無効化
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('君は「${_counter}歳」まで今の貯金だけで生きられるぞ！'),
            Text("グラフ"),
            Expanded(
                flex: 1,
                child: Card(
                    child: Container(
                        padding: EdgeInsets.all(10),
                        child: SimpleTimeSeriesChart.withSampleData()))),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).primaryColor,
        notchMargin: 6.0,
        shape: AutomaticNotchedShape(
          RoundedRectangleBorder(),
          StadiumBorder(
            side: BorderSide(),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.list_alt,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Detail(year, nenrei, zandaka,
                            shunyu1, shunyu2, shunyu3, shishutsu)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SimpleTimeSeriesChart extends StatelessWidget {
  final List<charts.Series<dynamic, DateTime>> seriesList;
  final bool animate;

  SimpleTimeSeriesChart(this.seriesList, {this.animate = false});

  factory SimpleTimeSeriesChart.withSampleData() {
    return new SimpleTimeSeriesChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }

  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    List<TimeSeriesSales> data = [];
    for (var i = 0; i < year.length; i++) {
      data.add(
          TimeSeriesSales(new DateTime(year[i], 1, 1), zandaka[i].toInt()));
    }
/*
    final data = [
      new TimeSeriesSales(new DateTime(2020, 7, 19), 50),
      new TimeSeriesSales(new DateTime(2020, 7, 20), 25),
      new TimeSeriesSales(new DateTime(2020, 7, 21), 100),
      new TimeSeriesSales(new DateTime(2020, 7, 22), 75),
      new TimeSeriesSales(new DateTime(2020, 7, 23), 600),
      new TimeSeriesSales(new DateTime(2020, 7, 24), 60),
      new TimeSeriesSales(new DateTime(2020, 7, 25), 76),
    ];
*/
    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}
