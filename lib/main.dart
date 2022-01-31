// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_this, prefer_const_constructors
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      home: Home(),
    ));

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var temp;
  var description;
  var currently;
  var humidity;
  var windspeed;

  Future getWeather() async {
    http.Response response = await http.get(
      Uri.https('api.openweathermap.org',
          '/data/2.5/weather?q=Karatina&units=imperial'),
      headers: {
        HttpHeaders.authorizationHeader: '2c45c43c2171a4bf40c7776904790eef',
      },
    );

    if (response.statusCode == 200) {
      var results = jsonDecode(response.body);
      setState(() {
        this.temp = results['main']['temp'];
        this.description = results['weather'][0]['description'];
        this.currently = results['weather'][0]['main'];
        this.humidity = results['main']['humidity'];
        this.windspeed = results['wind']['speed'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    this.getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            color: Colors.red,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Text('currently in Karatina',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600))),
                Text(
                  temp != null ? temp.toString() + '\u0000' : "loading",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                        currently != null ? currently.toString() : "loading",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600))),
              ],
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: <Widget>[
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.thermometerHalf),
                  title: Text("temperature"),
                  trailing: Text(
                      temp != null ? temp.toString() + "\u0000" : "loading"),
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.cloud),
                  title: Text("weather"),
                  trailing: Text(
                      description != null ? description.toString() : "loading"),
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.sun),
                  title: Text("humidity"),
                  trailing:
                      Text(humidity != null ? humidity.toString() : "loading"),
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.wind),
                  title: Text("wind speed"),
                  trailing: Text(
                      windspeed != null ? windspeed.toString() : "loading"),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
