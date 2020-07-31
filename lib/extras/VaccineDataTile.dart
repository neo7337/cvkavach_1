import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';

class VaccineDataTile extends StatelessWidget {
  final String vaccineName;
  final String phase;
  final String institution;
  VaccineDataTile(this.vaccineName, this.phase, this.institution);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.white24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget> [
              SizedBox( width: 6),
              Text(
                vaccineName,
                style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[200],
                      decoration: TextDecoration.none),
              ),
              SizedBox(width: 6),
              Text(
                  phase,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[200],
                      decoration: TextDecoration.none),
                ),
              SizedBox(width: 6),
              Text(
                  institution,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[200],
                      decoration: TextDecoration.none),
                ),
            ]
          )
        ]
      )
    );
  }

}