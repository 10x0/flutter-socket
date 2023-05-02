import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart%20';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Location location = Location();
  late var _locationData;

  final IO.Socket socket = IO.io('https://1afa-110-44-115-142.ngrok-free.app',
      OptionBuilder().setTransports(['websocket']).build());

  @override
  void initState() {
    socket.onConnect((_) {
      print('connect');
    });
    socket.onConnectError((data) => print('ERROR: $data'));
    location.onLocationChanged.listen((LocationData locationData) {
      socket.emit('location-update', locationData.toJSON());
    });
    super.initState();
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Location')),
    );
  }
}

extension on LocationData {
  Map<String, dynamic> toJSON() => {
        'latitude': latitude,
        'longitude': longitude,
        'heading': heading,
        'speed': speed,
      };
}
