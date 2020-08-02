import 'package:async/async.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:numometer/extras/VaccineDataTile.dart';
import 'package:numometer/repositories/data_repositories.dart';
import 'package:numometer/services/api_service.dart';
import 'package:provider/provider.dart';

class VaccineDataProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<DataRepository>(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: VaccineStatus(),
        ),
        create: (_) => DataRepository(apiService: APIService()));
  }
}

class VaccineStatus extends StatefulWidget {
  VaccineStatus({Key key}) : super(key: key);
  @override
  _VaccineStatusWidget createState() => _VaccineStatusWidget();
}

class _VaccineStatusWidget extends State<VaccineStatus> {
  void initState() {
    super.initState();
  }

  List<VDataStruct> vaccineData = new List<VDataStruct>();
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  _fetchVaccineData() {
    return this._memoizer.runOnce(() async {
      final dataRepository =
          Provider.of<DataRepository>(context, listen: false);
      vaccineData = await dataRepository.getVaccineData();
      return "OK";
    });
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 1));
    return null;
  }

  @override
  Widget build(BuildContext context) {
    print("Fetching Vaccine Data");
    return FutureBuilder(
        future: _fetchVaccineData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoading();
          } else {
            if (snapshot.hasError)
              return _buildError();
            else
              return _buildBody(
                  context); // snapshot.data  :- get your object which is pass from your downloadData() function
          }
        });
  }

  Widget _buildError() {
    print("build error");
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(FeatherIcons.alertCircle, size: 48, color: Color(0xffff653b)),
        SizedBox(height: 14),
        Text('Server Error, Please contact Administrator',
            style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                decoration: TextDecoration.none))
      ],
    ));
  }

  Widget _buildLoading() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(height: 24),
            Text(
              'Fetching latest updates',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            SizedBox(height: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xFF101010),
      body: RefreshIndicator (
        onRefresh: _handleRefresh,
          child:new SafeArea (
            child: Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                  child:  ListView(
                    padding: const EdgeInsets.all(20.0),
                    children: _getListings(vaccineData),
                  ),
                )
              ]
            )
          )
        )
      )
    );
  }
}

List<Widget> _getListings(List<VDataStruct> list) {
    List listings = new List<Widget>();
    if(list.length >0) {
        for(var i=0; i<list.length; i++) {
            listings.add(VaccineDataTile(i, list[i]));
        }
    }
    return listings;
}