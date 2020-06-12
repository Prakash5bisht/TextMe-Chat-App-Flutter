import 'package:intl/intl.dart';
class DateAndTime{

  var weekday;
  var month;

  String getDateAndTime(var time){
//    switch (time.month) {
//      case 1:
//        month = 'january';
//        break;
//      case 2:
//        month = 'feburary';
//        break;
//      case 3:
//        month = 'march';
//        break;
//      case 4:
//        month = 'april';
//        break;
//      case 5:
//        month = 'may';
//        break;
//      case 6:
//        month = 'june';
//        break;
//      case 7:
//        month = 'july';
//        break;
//      case 8:
//        month = 'august';
//        break;
//      case 9:
//        month = 'september';
//        break;
//      case 10:
//        month = 'october';
//        break;
//      case 11:
//        month = 'november';
//        break;
//      case 12:
//        month = 'december';
//        break;
//    }
//
//    switch(time.weekday){
//      case 1:
//        weekday = 'mon';
//        break;
//      case 2:
//        weekday = 'tue';
//        break;
//      case 3:
//        weekday = 'wed';
//        break;
//      case 4:
//        weekday = 'thu';
//        break;
//      case 5:
//        weekday = 'fri';
//        break;
//      case 6:
//        weekday = 'sat';
//        break;
//      case 7:
//        weekday = 'sun';
//        break;
//    }
    return '${DateFormat.yMMMMd().add_jm().format(time)}';
  }
//$weekday ${time.day} $month ${time.year} ${time.hour}:${time.minute}
}