import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {

  late String location; // location name for the UI
  late String time; // the time in that location
  late String flag; // url to asset flag icon
  late String url; // location url for api endpoint
  late bool isDaytime; // true or false if daytime or not

  WorldTime({required this.location, required this.flag, required this.url});

  Future<void> getData() async {
    try {
      // making the request

      Response response = await get(
          Uri.parse('http://worldtimeapi.org/api/timezone/$url'));
      Map data = jsonDecode(response.body);

      // get properties from data

      String datetime = data['datetime'];
      String offsetHours = data['utc_offset'].substring(1, 3);
      String offsetMinutes = data['utc_offset'].substring(4, 6);

      // create a datetime object

      DateTime now = DateTime.parse(datetime);
      now = now.add(Duration(hours: int.parse(offsetHours), minutes: int.parse(offsetMinutes)));

      // set the time property
      isDaytime = now.hour > 6 && now.hour < 20 ? true : false;
      time = DateFormat.jm().format(now);
    }

    catch (e) {
      print('Caught error: $e');
      time = 'could not get time data';
    }
  }
}