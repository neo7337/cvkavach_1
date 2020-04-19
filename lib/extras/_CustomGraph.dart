import 'package:cvkavach/extras/pieChart.dart';
import 'package:flutter/material.dart';

class CustomGraph extends StatelessWidget {
  final Map<String, double> dataMap;
  final String title;

  CustomGraph(this.dataMap, this.title);

  @override
  Widget build(BuildContext context) {
    double chartRadiusFactor =
        MediaQuery.of(context).size.aspectRatio > 0.6 ? 0.5 : 0.625;
    double fontSize = MediaQuery.of(context).size.aspectRatio > 0.6 ? 10 : 12;
    TextStyle titleStyle = MediaQuery.of(context).size.aspectRatio > 0.6
        ? TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          )
        : TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          );
    return PieChart(
      dataMap: dataMap,
      animationDuration: Duration(milliseconds: 800),
      chartRadius: MediaQuery.of(context).size.width * chartRadiusFactor,
      showChartValuesInPercentage: true,
      showChartValues: false,
      showChartValuesOutside: true,
      colorList: [Color(0xfff5c76a), Color(0xffff653b), Color(0xff9ff794)],
      showLegends: false,
      decimalPlaces: 1,
      showChartValueLabel: true,
      initialAngle: 4.5,
      chartType: ChartType.ring,
      chartValueStyle: TextStyle(
        color: Colors.white.withOpacity(0.6),
        fontSize: fontSize,
      ),
      chartTitle: title,
      chartTitleStyle: titleStyle,
    );
  }
}