import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connected Bluetooth Devices',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BluetoothDevicesScreen(),
    );
  }
}

class BluetoothDevicesScreen extends StatefulWidget {
  const BluetoothDevicesScreen({super.key});
  @override
  State<BluetoothDevicesScreen> createState() => _BluetoothDevicesScreenState();
}

class _BluetoothDevicesScreenState extends State<BluetoothDevicesScreen> {
  // final FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  List<BluetoothDevice> connectedDevices = [];

  @override
  void initState() {
    super.initState();
    fetchConnectedDevices();
  }

  Future<void> fetchConnectedDevices() async {
    setState(() {
      connectedDevices = FlutterBluePlus.connectedDevices;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connected Bluetooth Devices'),
      ),
      body: ListView.builder(
        itemCount: connectedDevices.length,
        itemBuilder: (context, index) {
          final device = connectedDevices[index];
          return ListTile(
            title: Text(device.platformName),
            subtitle: Text(device.remoteId.toString()),
          );
        },
      ),
    );
  }
}