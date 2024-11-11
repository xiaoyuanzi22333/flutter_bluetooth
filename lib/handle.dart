import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BluetoothPermissionScreen(),
    );
  }
}

class BluetoothPermissionScreen extends StatefulWidget {
  const BluetoothPermissionScreen({super.key});

  @override
  State<BluetoothPermissionScreen> createState() => _BluetoothPermissionScreenState();
}

class _BluetoothPermissionScreenState extends State<BluetoothPermissionScreen> {
  @override
  void initState() {
    super.initState();
    checkBluetoothPermission();
  }

  Future<void> checkBluetoothPermission() async {
    var status = await Permission.bluetooth.status;
    debugPrint(status.toString());
    if (!status.isGranted) {
      await Permission.bluetooth.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Permission'),
      ),
      body: const Center(
        child: Text('Check Bluetooth Permission in Console'),
      ),
    );
  }
}