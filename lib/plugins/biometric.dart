import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class Biometric {

  Biometric._privateConstructor();
  static final Biometric instance = Biometric._privateConstructor();

  final LocalAuthentication auth = LocalAuthentication();
  Map<String,dynamic> rslt = {'status':false};
  Future<Map> authenticate() async {
    bool authenticated = false;
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (canCheckBiometrics) {
      try {
        authenticated = await auth.authenticateWithBiometrics(
            localizedReason: 'Login into Scratch App',
            useErrorDialogs: true,
            stickyAuth: false);
            rslt = {'status':authenticated};
      } on PlatformException catch (e) {
        print(e);
      }
    } else {
      return rslt;
    }
    return rslt;
  }
}
