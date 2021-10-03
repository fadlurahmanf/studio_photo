import 'dart:math';

extension UtilsString on String{
  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';


  String toDate(){
    ///FORMAT YYYY-MM-DD HH-MM-SS
    String value = this;
    List<String> listSplitValue = value.split(" ");
    String date = listSplitValue[0];
    String time = listSplitValue[1];
    String day = date.split("-").last;
    String month = date.split("-")[1].monthInNumberToMonthInWord();
    String hour = time.split(":").first;
    String minutes = time.split(":")[1];
    return "$day $month $hour:$minutes";
  }

  String monthInNumberToMonthInWord(){
    String value = this;
    if(value=="01") return "Jan";
    else if(value=="02") return "Feb";
    else if(value=="03") return "Mar";
    else if(value=="04") return "Apr";
    else if(value=="05") return "May";
    else if(value=="06") return "Jun";
    else if(value=="07") return "Jul";
    else if(value=="08") return "Aug";
    else if(value=="09") return "Sep";
    else if(value=="10") return "Oct";
    else if(value=="11") return "Nov";
    else return "Dec";
  }

  String getRandomString(int length){
    return String.fromCharCodes(
        Iterable.generate(length, (_) => _chars.codeUnitAt(Random().nextInt(_chars.length)))
    );
  }
}