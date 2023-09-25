import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:week3/model/weather.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyWidget(),
  ));
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  List<String> capitalList = [
    "Asia/Ho_Chi_Minh",
    "Asia/Hong_Kong",
    "Asia/Irkutsk",
    "Asia/Jakarta",
    "Asia/Jayapura",
    "Asia/Jerusalem"
  ];
  List<Weather> list = [];

  bool isLoading = true;
  var res = {};

  Future<void> _fetchData() async {
    for (int i = 0; i < capitalList.length; i++) {
      var apiUrl = 'https://worldtimeapi.org/api/timezone/${capitalList[i]}';
      HttpClient client = HttpClient();
      client.autoUncompress = true;
      final HttpClientRequest request = await client.getUrl(Uri.parse(apiUrl));
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      final HttpClientResponse response = await request.close();
      final String content = await response.transform(utf8.decoder).join();
      res = json.decode(content);
      String name = res['timezone'].split('/')[1];
      String time = res['datetime'].split('T')[1].split('.')[0];
      String day = res['datetime'].split('T')[0];
      String dayOfWeekStr = '';
      String utc_offset = res['utc_offset'];
      switch (res['day_of_week']) {
        case 1:
          dayOfWeekStr = 'Monday';
          break;
        case 2:
          dayOfWeekStr = 'Tuesday ';
          break;
        case 3:
          dayOfWeekStr = 'Wednesday ';
          break;
        case 4:
          dayOfWeekStr = 'Thursday ';
          break;
        case 5:
          dayOfWeekStr = 'Friday ';
          break;
        case 6:
          dayOfWeekStr = 'Saturday ';
          break;
        case 7:
          dayOfWeekStr = 'Sunday ';
          break;
      }
      String utc = '$dayOfWeekStr $utc_offset';
      String title = '4:50 hrs behind';

      list.add(Weather(name, time, day, utc, title));
    }
    setState(() {
      isLoading = false;
    });
  }


  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    int sc = 2;
    Timer(new Duration(seconds: sc), () {
      setState(() {
       for(int i  = 0 ; i < list.length ; i++){
         list[i].autoUpTime();
       }

      });
    });

    return Scaffold(
      body: Center(
        child: (isLoading
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return listItem(list[index]);
                })),
      ),
    );
  }
}

Widget listItem(Weather weather) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${weather.name}',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              '${weather.utc}',
              style: TextStyle(color: Colors.grey),
            ),
            Text('${weather.subscription}',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
        Column(
          children: [
            Text('${weather.time}',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            Text('${weather.day}', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    ),
  );
}
