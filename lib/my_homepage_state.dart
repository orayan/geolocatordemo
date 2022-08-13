import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Position? _position;

// * تقوم هذه الوحدة البرمجية بطباعة موقع الجهاز
  void _getCurrentLocation() async {
    // *الكلاس position يحتوي على خصائص الموقع مثل الاحداثيات
    Position position = await _determinePosition();
    setState(() {
      _position = position;
    });
  }

  Future<Position> _determinePosition() async {
    // * لفحص صلاحيات قراءة الموقع من الجهاز
    LocationPermission permmission;
    permmission = await Geolocator.checkPermission();

// * فحص الصلاحيات وإذا لم تكن مسموحة ستم طلبها
    if (permmission == LocationPermission.denied) {
      permmission = await Geolocator.requestPermission();
      // * إذا لم يوافق المستخدم على منحها سيتم إظهار خطأ
      if (permmission == LocationPermission.denied) {
        return Future.error('Location Permission are denied.');
      }
    }
    // StreamSubscription<ServiceStatus> serviceStatusStream =
    //     Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
    //   print('the status is $status');
    // });

    // * إرجاع موقع الجهاز
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GeoLocator App'),
      ),
      body: Center(
        // * إظهار احداثيات الموقع
        child: _position != null
            ? Text('The Current Location is:  $_position')
            : const Text('No Location'),
      ),
      floatingActionButton: FloatingActionButton(
        // * استدعاء الكود الخاص بإحضار الموقع
        onPressed: _getCurrentLocation,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
