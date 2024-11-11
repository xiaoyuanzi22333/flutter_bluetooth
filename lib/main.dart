import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';


void main() {
  runApp(const MyApp());
  // FlutterBluePlus.startScan(timeout: Duration(seconds: 4)).catchError((error) {
  //   debugPrint("Error starting scan: $error");
  // });
  // debugPrint("scan end");

  // // Listen to the scanning results

  // FlutterBluePlus.scanResults.listen((results) {
  //   for (var result in results) {
  //     debugPrint('Found Bluetooth device! Name: ${result.device.platformName}, RSSI: ${result.rssi}');
  //   }
  // });
  // debugPrint("ggg");

  // // Optional: Stop scanning as needed
  // Future.delayed(Duration(seconds: 4));
  // FlutterBluePlus.stopScan();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Blue Plus Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BluetoothScreen(),
    );
  }
}

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {

  // FlutterBluePlus flutterBlue = FlutterBluePlus();
  List<BluetoothDevice> _connectedDevices = [];
  List<ScanResult> _scanResults = [];
  bool _scanning = false;

  @override
  void initState() {
    super.initState();
    _startScan();
    _getConnectedDevices();
  }

  // 扫描蓝牙设备
  void _startScan() {
    
    // debugPrint("开始扫描");debugPrint("开始扫描");debugPrint("开始扫描");debugPrint("开始扫描");
    setState(() {
      _scanning = true;
    });

    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5)).then((_) {
      setState(() {
        _scanning = false;
      });
    });

    FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        _scanResults = results;
      });
    });
    // debugPrint("扫描结束");debugPrint("扫描结束");debugPrint("扫描结束");debugPrint("扫描结束");
  }

  // 获取已连接的设备
  void _getConnectedDevices() async {
    List<BluetoothDevice> connectedDevices = FlutterBluePlus.connectedDevices;
    setState(() {
      _connectedDevices = connectedDevices;
    });
  }

  // 连接设备
  void _connectToDevice(BluetoothDevice device) async {
    await device.connect(autoConnect: false).catchError((e) {
      debugPrint("连接失败: $e");
    });
    _getConnectedDevices();
  }

  // 断开设备
  void _disconnectFromDevice(BluetoothDevice device) async {
    await device.disconnect();
    _getConnectedDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('蓝牙设备'),
      ),
      body: Column(
        children: [
          _scanning
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _startScan,
                  child: const Text('重新扫描'),
                ),
          const SizedBox(height: 200),
          const Text('已连接的设备:', style: TextStyle(fontWeight: FontWeight.bold)),
          _buildConnectedDevicesList(),
          const Divider(),
          const Text('扫描到的设备:', style: TextStyle(fontWeight: FontWeight.bold)),
          _buildScanResultsList(),
        ],
      ),
    );
  }

  Widget _buildConnectedDevicesList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _connectedDevices.length,
      itemBuilder: (context, index) {
        BluetoothDevice device = _connectedDevices[index];
        return ListTile(
          title: Text(device.platformName),
          subtitle: Text(device.remoteId.toString()),
          trailing: ElevatedButton(
            onPressed: () => _disconnectFromDevice(device),
            child: const Text("断开连接"),
          ),
        );
      },
    );
  }

  Widget _buildScanResultsList() {
    debugPrint("扫描");debugPrint("扫描");debugPrint("扫描");debugPrint("扫描");
    debugPrint(_scanResults.length.toString());
    var status = Permission.bluetooth.status;
    // debugPrint(status.toString());
    status.then((val) {
      debugPrint(val.toString());
    });
    debugPrint("扫描");debugPrint("扫描");debugPrint("扫描");debugPrint("扫描");

    return ListView.builder(
      shrinkWrap: true,
      itemCount: _scanResults.length,
      itemBuilder: (context, index) {
        ScanResult result = _scanResults[index];
        return ListTile(
          title: Text(result.device.platformName.isEmpty ? '未知设备' : result.device.platformName),
          subtitle: Text(result.device.remoteId.toString()),
          trailing: ElevatedButton(
            onPressed: () => _connectToDevice(result.device),
            child: const Text('连接'),
          ),
        );
      },
    );
  }
}