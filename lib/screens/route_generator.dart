import 'package:flutter/material.dart';

import '../dao/screenobj.dart';

import '../main.dart';
import '../screens/login/login.dart';
import '../screens/placeorder/custList.dart';
import '../screens/placeorder/order.dart';
import '../screens/settings/settings.dart';
import '../screens/custdetails/custList.dart';
import '../screens/custdetails/custdetails.dart';
import '../screens/dashboard/dashboard.dart';
import '../screens/itemdetails/itemdetails.dart';
import '../screens/itemdetails/itemmaster.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    ScreenObj args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => MyHomePage());
      case '/login':
        return MaterialPageRoute(
          builder: (_) => Login(
            args,
          ),
        );

      case '/itemmstr':
        return MaterialPageRoute(
          builder: (_) => ItemList(
            args,
          ),
        );

      case '/itemdtls':
        return MaterialPageRoute(
          builder: (_) => ItemDetails(
            args,
          ),
        );

      case '/custmstr':
        return MaterialPageRoute(
          builder: (_) => CustomerList(
            args,
          ),
        );

      case '/custdtls':
        return MaterialPageRoute(
          builder: (_) => CustDetails(
            args,
          ),
        );

      case '/settings':
        return MaterialPageRoute(
          builder: (_) => Settings(
            args,
          ),
        );

      case '/custorder':
        return MaterialPageRoute(
          builder: (_) => CustomerListor(
            args,
          ),
        );

      case '/order':
        return MaterialPageRoute(
          builder: (_) => PlaceOrder(
            args,
          ),
        );

      case '/dashboard':
        return MaterialPageRoute(
          builder: (_) => Dashboard(
            args,
          ),
        );
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
