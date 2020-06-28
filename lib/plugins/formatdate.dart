import 'package:intl/intl.dart';

class FormatDate {
  FormatDate._privateConstructor();
  static final FormatDate instance = FormatDate._privateConstructor();

  formatDate(DateTime now, String frmt) {
        Map<String, dynamic> respObj = {};
    print("Now  " + now.toString());
    print("frmt  " + frmt);
    DateFormat dateFormat = DateFormat(frmt);
    print(dateFormat.format(now).toString());
    respObj['frmtStr'] = dateFormat.format(now).toString();
    return respObj;
  }
}
