import 'package:paper/constants/constants.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketClient {
  Socket? socket;
  static SocketClient? _instance;
  SocketClient.internal() {
    socket = io(baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket!.connect();
  }

  static SocketClient get instance {
    _instance ??= SocketClient.internal();
    return _instance!;
  }
}
