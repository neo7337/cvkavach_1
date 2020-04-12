import 'package:cvkavach/services/api_service.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';

class StateDetailPage extends StatelessWidget {

  final List<DistrictData> value;

  StateDetailPage(this.value);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xFF101010),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(FeatherIcons.chevronLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: new SafeArea (
          child: Container(
            child: Column(
              children: <Widget>[
                Expanded(
                child:  ListView(
                  padding: const EdgeInsets.all(20.0),
                  children: _getListings(),
                ),
              )
            ]
          )
        )
      )
    );
  }

  List<Widget> _getListings() { 
    List listings = new List<Widget>();
    value.forEach((f) {
      listings.add(_StatTile(f.district, f.confirmed));
    });
    return listings;
  }
}


class _StatTile extends StatelessWidget {
  final String district;
  final int confirmed;

  _StatTile(this.district, this.confirmed);

  @override
  Widget build(BuildContext context) {
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    Function mathFunc = (Match match) => '${match[1]},';
    return Container(
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
                    child: Text(district, 
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
                    'Confirmed Cases',
                    style: TextStyle(
                        fontSize: 14, 
                        color: Colors.white.withOpacity(0.6),
                        decoration: TextDecoration.none),
                  ),
                ],
              ),
              Text(
                confirmed.toString().replaceAllMapped(reg, mathFunc),
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
    );
  }
}