import 'dart:collection';

import 'package:numometer/components/StateDetail.dart';
import 'package:numometer/services/api_service.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';

class StatTileInd extends StatelessWidget {
  final List<String> value;
  final HashMap<String, List<DistrictData>> distData;

  StatTileInd(this.value, this.distData);

  @override
  Widget build(BuildContext context) {
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    Function mathFunc = (Match match) => '${match[1]},';
    return InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StateDetailPage(distData[value[0]]),
              ),
            ),
            child: Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.white24),
        ),
      ),
      child: Column(
        children:<Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    child: Text(value[0], 
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      decoration: TextDecoration.none)),
                  )
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(FeatherIcons.circle, color: Color(0xff0000ff), size: 10),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    'Total Cases',
                    style: TextStyle(
                        fontSize: 14, 
                        color: Colors.white.withOpacity(0.6),
                        decoration: TextDecoration.none),
                  ),
                ],
              ),
              Text(
                value[1].toString().replaceAllMapped(reg, mathFunc),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    decoration: TextDecoration.none),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(FeatherIcons.circle, color: Color(0xffff653b), size: 10),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    'Deaths',
                    style: TextStyle(
                        fontSize: 14, 
                        color: Colors.white.withOpacity(0.6),
                        decoration: TextDecoration.none),
                  ),
                ],
              ),
              Text(
                value[2].toString().replaceAllMapped(reg, mathFunc),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    decoration: TextDecoration.none),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(FeatherIcons.circle, color: Color(0xff9ff794), size: 10),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    'Recovered',
                    style: TextStyle(
                        fontSize: 14, 
                        color: Colors.white.withOpacity(0.6),
                        decoration: TextDecoration.none),
                  ),
                ],
              ),
              Text(
                value[3].toString().replaceAllMapped(reg, mathFunc),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    decoration: TextDecoration.none),
              ),
            ],
          )
        ]
      )
            )
    );
  }
}