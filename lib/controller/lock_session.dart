import 'dart:async';

import 'package:get/get.dart';
import 'package:local_session_timeout/local_session_timeout.dart';

class LockSession extends GetxController {
  LockSession get getXID => Get.find<LockSession>();

  final StreamController<SessionState> sessionStream = StreamController();
  // late final sessionLock  = StreamController<SessionState> sessionStream;

  startLockSession() {
    sessionStream.add(SessionState.startListening);
  }

  stopLockSession() {
    sessionStream.add(SessionState.stopListening);
  }
}
