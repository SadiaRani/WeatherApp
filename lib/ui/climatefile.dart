import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/apifile.dart' as util;

class Climate extends StatefulWidget {
  const Climate({super.key});

  @override
  State<Climate> createState() => _ClimateState();
}

class _ClimateState extends State<Climate> {

  void showStuff() async {
    Map data = await getWeather(util.apiId, util.defaultCity);
    print(data.toString());
  }

  String? _cityEnter;

  Future _goToNextScreen() async {
    Map? results = await Navigator.of(context).push(
      MaterialPageRoute<Map>(builder: (BuildContext context) {
        return ChangeCity();
      }),
    );
    if (results != null && results.containsKey('enter')) {
      setState(() {
        _cityEnter = results['enter'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          "ClimateApp",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _goToNextScreen();
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Image(
              image: const AssetImage('images/umberlla.png'),
              height: 1100.0,
              width: 600.0,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: Text(
              '${_cityEnter == null ? util.defaultCity : _cityEnter}',
              style: cityStyle(),
            ),
          ),
          Center(
            child: Image(
              image: const AssetImage('images/rain.png'),
              height: 50,
              width: 50,
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(30.0, .0, 0.0, 0.0),
            child: updateTempWidget('${_cityEnter == null ? util.defaultCity : _cityEnter}'),
          ),
        ],
      ),
    );
  }

  Future<Map> getWeather(String appId, String city) async {
    String apiUrl = "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$appId&units=imperial";
    http.Response response = await http.get(Uri.parse(apiUrl));
    return json.decode(response.body);
  }

  Widget updateTempWidget(String city) {
    return FutureBuilder(
      future: getWeather(util.apiId, city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        if (snapshot.hasData) {
          Map content = snapshot.data!;
          return Container(
            margin: EdgeInsets.fromLTRB(30.0, 250.0, 0.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  title: Text(
                    content['main']['temp'].toString() + "F",
                    style: tempStyle(),
                  ),
                  subtitle: ListTile(
                    title: Text(
                      'Humidity: ${content['main']['humidity'].toString()}\n'
                          'Min: ${content['main']['temp_min'].toString()}F\n'
                          'Max: ${content['main']['temp_max'].toString()}F\n',
                      style: extraData(),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  TextStyle cityStyle() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 30.9,
      fontStyle: FontStyle.italic,
    );
  }

  TextStyle tempStyle() {
    return const TextStyle(
      color: Colors.white,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      fontSize: 49.9,
    );
  }
}

TextStyle extraData() {
  return TextStyle(
    color: Colors.white70,
    fontStyle: FontStyle.normal,
    fontSize: 17.0,
  );
}

class ChangeCity extends StatelessWidget {
  var _cityFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Change City'),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset(
              'images/white_snow.png',
              height: 1100.0,
              width: 590.0,
              fit: BoxFit.fill,
            ),
          ),
          ListView(
            children: <Widget>[
              ListTile(
                title: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter City Name',
                  ),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                ),
              ),
              ListTile(
                title: ElevatedButton(

                  onPressed: () {
                    Navigator.pop(context, {'enter': _cityFieldController.text});
                  },
                  child: Text('Get Weather'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
