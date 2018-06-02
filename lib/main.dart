import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Map _data;
List _listfeatures;
void main() async {

  _data = await getJson();
  _listfeatures = _data['features'];
  print(_listfeatures);

  runApp(new MaterialApp(
    title: 'Earthquakes',
    home: new Earthquakes(),
  ));
}

  class Earthquakes extends StatefulWidget {

    @override
    State<StatefulWidget> createState() {
      return new EarthquakesState();
    }
  }

class EarthquakesState extends State<Earthquakes>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Last Earthquakes'),
          centerTitle: true,
          backgroundColor: Colors.red,
        ),
        body: new Center(
          child: new ListView.builder(
              itemCount: _listfeatures.length,
              padding: const EdgeInsets.only(right: 16.0),
              itemBuilder: (BuildContext context, int position) {
                if (position.isOdd) return new Divider();
                final index = position ~/ 2;
                var format = new DateFormat("d/MM/yyyy   H:m:s");
                var date = format.format( new DateTime.fromMicrosecondsSinceEpoch(_listfeatures[index]['properties']['time']*1000,
                  isUtc: true));
                return new ListTile(
                  title: new Text('$date',
                      style: new TextStyle(fontSize: 14.9)
                  ),
                  subtitle: new Text(_listfeatures[index]['properties']['place'],
                  style: new TextStyle(
                    color: Colors.grey,
                    fontSize: 14.5,
                    fontWeight: FontWeight.normal
                  ),),
                  leading: new CircleAvatar(
                    backgroundColor: Colors.redAccent,
                    child: new Text(_listfeatures[index]['properties']['mag'].toString(),
                    style: new TextStyle(
                      color: Colors.white
                    ),),
                  ),
                  onTap: () { _showOnTapMessage(context, "${_listfeatures[index]['properties']['title']}");},
                );
              }
          ),
        )
    );
  }
}

void _showOnTapMessage(BuildContext context, String message){
  var alert = new AlertDialog(
    title: new Text('Location'),
    content: new Text(message),
    actions: <Widget>[
      new FlatButton(onPressed: (){Navigator.pop(context);},
          child: new Text('OK'))
    ],
  );
  showDialog(context: context, builder: (context) => alert);
}

Future<Map> getJson() async {
  String apiUrl = 'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson';

  http.Response response = await http.get(apiUrl);

  return json.decode(response.body);
}

