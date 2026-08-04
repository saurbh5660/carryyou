import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../network/api_constants.dart';
import 'apputills.dart';
import 'db_helper.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();

  factory SocketService() => _instance;
  IO.Socket? socket;
  final List<SocketListener> _listeners = [];
  Function(dynamic data,String eventType)? onListener;

  SocketService._internal() {
    connectToServer();
  }

  void addListener(SocketListener socketListener) {
    if (!_listeners.contains(socketListener)) {
      _listeners.add(socketListener);
    }
  }

  void removeListener(SocketListener socketListener) {
    _listeners.remove(socketListener);
  }

  void connectToServer() {
    if (socket == null || !socket!.connected) {
      socket = IO.io(ApiConstants.socketUrl, IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableForceNew()
          .build());

      socket?.onConnect((_) {
        print('Connected to socket server');
        connectUser();
      });

      socket?.onDisconnect((_) {
        print('Disconnected from socket server');
      });

      _setupListeners();
    }
  }

  void connectUser() {
    final senderId = DbHelper().getUserModel()?.id.toString();
    if (senderId != null) {
      socket?.emit('connect_user', {'userId': senderId});
      connectUserListener();
    }
  }

  void connectUserListener() {
    socket?.on('connect_user_listener', (data) {
      print('User connected: $data');
    });
  }

  void userConstantList(String senderId) {
    Logger().d(senderId);
    socket?.emit('user_constant_list', {'senderId': senderId});
  }

  void updateStatus(Map<String, dynamic> messageData) {
    socket?.emit('update_route', messageData);
  }

  void locationUpdate(Map<String, dynamic> messageData) {
    socket?.emit('loction_update', messageData);
  }

  void sendMessage(Map<String, dynamic> messageData) {
    socket?.emit('send_message', messageData);
  }

  void sendLocationToDriver(Map<String, dynamic> messageData) {
    Logger().d("sfsdfsdfsdf----------- $messageData");

    socket?.emit('sendLocationToDriver', messageData);
  }

  void getMessages(Map<String, dynamic> messageData) {
    socket?.emit('users_chat_list', messageData);
  }


  void _setupListeners() {
    // socket?.on('driver_location_update', (data) {
    //   printPrettyJson(data);
    //   Logger().d("location updated successfully");
    //   for (var listener in _listeners) {
    //     listener.onSocketEvent(data, 'driver_location_update');
    //   }
    // });

    socket?.on('bookingAcceptReject', (data) {
      printPrettyJson(data);
      Logger().d("Booking Accept Reject Driver");
      for (var listener in _listeners) {
        listener.onSocketEvent(data, 'bookingAcceptReject');
      }
    });

    socket?.on('cancelBooking', (data) {
      printPrettyJson(data);
      Logger().d("User Cancel Booking");
      for (var listener in _listeners) {
        listener.onSocketEvent(data, 'cancelBooking');
      }
    });

    socket?.on('bookingStatusChange', (data) {
      printPrettyJson(data);
      Logger().d("Booking Changed");
      for (var listener in _listeners) {
        listener.onSocketEvent(data, 'bookingStatusChange');
      }
    });

    socket?.on('driver_location_update', (data) {
      printPrettyJson("dsdsdsafsa-------------"+data.toString());
      for (var listener in _listeners) {
        listener.onSocketEvent(data, 'driver_location_update');
      }
    });

    socket?.on('user_location_update', (data) {
      printPrettyJson("dasFAsASGASG---------------------"+data.toString());
      Logger().d("location updated successfully");
      for (var listener in _listeners) {
        listener.onSocketEvent(data, 'user_location_update');
      }
    });

    socket?.on('loction_update', (data) {
      printPrettyJson(data);
      for (var listener in _listeners) {
        listener.onSocketEvent(data, 'loction_update');
      }
    });

    socket?.on('users_chat_list_listener', (data) {
      printPrettyJson(data);
      for (var listener in _listeners) {
        listener.onSocketEvent(data, 'users_chat_list_listener');
      }
    });

    socket?.on('send_message_emit', (data) {
      printPrettyJson(data);
      for (var listener in _listeners) {
        listener.onSocketEvent(data, 'send_message_emit');
      }
    });

    socket?.on('user_constant_chat_list', (data) {
      Logger().d("Received user constant chat list: $data");
      for (var listener in _listeners) {
        listener.onSocketEvent(data, 'users_chat_list_listener');
      }
    });
  }



  void disconnectSocket() {
    socket?.disconnect();
  }

  void dispose() {
    disconnectSocket();
  }
}

abstract class SocketListener {
  void onSocketEvent(dynamic data, String eventType);
}
