import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'pieChart.dart';

class PieChartPainter extends CustomPainter {
  List<Paint> _paintList = [];
  List<double> _subParts;
  double _total = 0;
  double _totalAngle = math.pi * 2;

  final TextStyle chartValueStyle;
  final Color chartValueBackgroundColor;
  final double initialAngle;
  final bool showValuesInPercentage;
  final bool showChartValuesOutside;
  final int decimalPlaces;
  final bool showChartValueLabel;
  final ChartType chartType;
  final String chartTitle;
  final TextStyle chartTitleStyle;

  double _prevAngle = 0;

  PieChartPainter(
    double angleFactor,
    this.showChartValuesOutside,
    List<Color> colorList, {
    this.chartValueStyle,
    this.chartValueBackgroundColor,
    List<double> values,
    this.initialAngle,
    this.showValuesInPercentage,
    this.decimalPlaces,
    this.showChartValueLabel,
    this.chartType,
    this.chartTitle,
    this.chartTitleStyle,
  }) {
    for (int i = 0; i < values.length; i++) {
      final paint = Paint()..color = _getColor(colorList, i);
      if (chartType == ChartType.ring) {
        paint.style = PaintingStyle.stroke;
        paint.strokeWidth = 5;
      }
      _paintList.add(paint);
    }
    _totalAngle = angleFactor * math.pi * 2;
    _subParts = values;
    _total = values.fold(0, (v1, v2) => v1 + v2);
  }

  @override
  void paint(Canvas canvas, Size size) {
    int marginSide =
        1; // 1 or (-1) to determine the shift direction on the x axis
    final side = size.width < size.height ? size.width : size.height;
    _prevAngle = this.initialAngle;
    for (int i = 0; i < _subParts.length; i++) {
      canvas.drawArc(
        Rect.fromLTWH(0.0, 0.0, side, size.height),
        _prevAngle,
        (((_totalAngle) / _total) * _subParts[i]),
        chartType == ChartType.disc ? true : false,
        _paintList[i],
      );
      final radius = showChartValuesOutside ? side * 0.52 : side / 3;
      // number of pixels to shift if labels do clutter (if the percentage < 3%)
      final margin =
          (!_subParts.contains(0) && (_subParts.elementAt(i) / _total) < 0.03
                  ? 13
                  : 0) *
              marginSide;
      final x = (radius) *
              math.cos(_prevAngle +
                  ((((_totalAngle) / _total) * _subParts[i]) / 2)) +
          margin;
      final y = (radius) *
          math.sin(
              _prevAngle + ((((_totalAngle) / _total) * _subParts[i]) / 2));
      if (_subParts.elementAt(i).toInt() != 0) {
        final name = showValuesInPercentage
            ? (((_subParts.elementAt(i) / _total) * 100)
                    .toStringAsFixed(this.decimalPlaces) +
                '%')
            : _subParts.elementAt(i).toStringAsFixed(this.decimalPlaces);

        _drawName(canvas, name, x, y, side);
        marginSide *=
            -1; // switch the margin side for the next label to avoid shifting in the same direction
      }
      _prevAngle = _prevAngle + (((_totalAngle) / _total) * _subParts[i]);
    }

    TextSpan span = TextSpan(
      style: this.chartTitleStyle,
      text: this.chartTitle,
    );
    TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout();

    //Finally paint the text above box
    tp.paint(
      canvas,
      Offset(
        (side / 2) - (tp.width / 2),
        (side / 2) - (tp.height / 2),
      ),
    );
  }

  Color _getColor(List<Color> colorList, int index) {
    if (index > (colorList.length - 1)) {
      var newIndex = index % (colorList.length - 1);
      return colorList.elementAt(newIndex);
    } else
      return colorList.elementAt(index);
  }

  void _drawName(Canvas canvas, String name, double x, double y, double side) {
    TextSpan span = TextSpan(
      style: chartValueStyle,
      text: name,
    );
    TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout();

    //Finally paint the text above box
    tp.paint(
      canvas,
      Offset(
        (side / 2 + x / 0.84) - (tp.width / 2),
        (side / 2 + y / 0.84) - (tp.height / 2),
      ),
    );
  }

  @override
  bool shouldRepaint(PieChartPainter oldDelegate) =>
      oldDelegate._totalAngle != _totalAngle;
}
