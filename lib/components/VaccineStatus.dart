import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
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

  Future<String> _fetchVaccineData() async {
    final dataRepository = Provider.of<DataRepository>(context, listen: false);
    vaccineData = await dataRepository.getVaccineData();
    print("print:: " + vaccineData.toString());
    return Future.value("OK");
  }

  @override
  Widget build(BuildContext context) {
    print("Fetching Vaccine Data");
    return FutureBuilder<String>(
        future: _fetchVaccineData(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoading();
          } else {
            if (snapshot.hasError)
              return _buildError();
            else
              return _buildBody(context); // snapshot.data  :- get your object which is pass from your downloadData() function
          }
        }
    );
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
      body: new Container(
        child: new Center(
          child: new Column(children: <Widget>[
            new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: new Card(
                    child: new Container(
                      padding: new EdgeInsets.all(32.0),
                      child: new Column(
                        children: <Widget>[
                          ListTile(
                              title: Text('Total Vaccine Contendors',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                              subtitle: Text(
                                  'Contains the count of those vaccines as well which are not yet in human trials. In the midst of darkness we have a ray of hope.'),
                              trailing: Text(
                                '140+',
                                style: Theme.of(context).textTheme.headline4,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: new Card(
                    color: Colors.blueGrey,
                    child: new Container(
                      padding: new EdgeInsets.all(32.0),
                      child: new Column(
                        children: <Widget>[
                          ListTile(
                              title: Text('Phase I',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                              subtitle:
                                  Text('Vaccines testing safety and dosage'),
                              trailing: Text(
                                '19',
                                style: Theme.of(context).textTheme.headline4,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: new Card(
                    color: Colors.blue[300],
                    child: new Container(
                      padding: new EdgeInsets.all(32.0),
                      child: new Column(
                        children: <Widget>[
                          ListTile(
                              title: Text('Phase II',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                              subtitle:
                                  Text('Vaccines in expanded safety trials'),
                              trailing: Text(
                                '13',
                                style: Theme.of(context).textTheme.headline4,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: new Card(
                    color: Colors.blueGrey[900],
                    child: new Container(
                      padding: new EdgeInsets.all(32.0),
                      child: new Column(
                        children: <Widget>[
                          ListTile(
                              title: Text('Phase III',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                              subtitle: Text(
                                  'Vaccines in large-scale efficacy tests'),
                              trailing: Text(
                                '4',
                                style: Theme.of(context).textTheme.headline4,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: new Card(
                    color: Colors.teal,
                    child: new Container(
                      padding: new EdgeInsets.all(32.0),
                      child: new Column(
                        children: <Widget>[
                          ListTile(
                              title: Text('Approval',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                              subtitle:
                                  Text('Vaccines approved for limited use'),
                              trailing: Text(
                                '1',
                                style: Theme.of(context).textTheme.headline4,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(20.0),
                    children: _getListings(),
                  ),
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }
}

List<Widget> _getListings() {}
