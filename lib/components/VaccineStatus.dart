import 'package:async/async.dart';
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
  List<Item> _data;
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  _fetchVaccineData() {
    return this._memoizer.runOnce(() async {
      final dataRepository =
          Provider.of<DataRepository>(context, listen: false);
      vaccineData = await dataRepository.getVaccineData();
      _data = generateItems(vaccineData, vaccineData.length);
      return "OK";
    });
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
        body: SingleChildScrollView(
          child: Container(
              child: ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                _data[index].isExpanded = !isExpanded;
              });
            },
            children: _data.map<ExpansionPanel>((Item item) {
              return ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: Text(item.headerValue),
                  );
                },
                body: ListTile(
                  title: Text(item.expandedValue),
                  subtitle: Text(item.institution),
                ),
                isExpanded: item.isExpanded,
              );
            }).toList(),
          )),
        ));
  }
}

List<Item> generateItems(List<VDataStruct> data, int numberOfItems) {
  List<Item> itemList = new List<Item>();
  for (var i = 0; i < data.length; i++) {
    itemList.add(Item(
        headerValue: data[i].candidate,
        expandedValue: data[i].trialPhase,
        institution: data[i].institutions));
  }
  return itemList;
}

class Item {
  Item({
    this.expandedValue,
    this.headerValue,
    this.institution,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  String institution;
  bool isExpanded;
}
