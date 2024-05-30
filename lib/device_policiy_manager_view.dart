import 'package:device_policy_manager/device_policy_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DevicePolicyManagerView extends StatefulWidget {
  const DevicePolicyManagerView({super.key});

  @override
  State<DevicePolicyManagerView> createState() => _DevicePolicyManagerState();
}

class _DevicePolicyManagerState extends State<DevicePolicyManagerView> {


  @override
  void initState() {
    initPermissionGranted();
    super.initState();
  }

  initPermissionGranted() async {
    final status = await DevicePolicyManager.isPermissionGranted();

    if (status) {
      print('Permission Granted');
    }else {
      print('Permission Denied');

    }
    await DevicePolicyManager.requestPermession("Your app is requesting the Adminstration permission");
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<Map<String, dynamic>?>(
              stream: FlutterBackgroundService().on('update'),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final data = snapshot.data!;
                String? device = data["device"];
                DateTime? date = DateTime.tryParse(data["current_date"]);
                return Column(
                  children: [
                    Text(device ?? 'Unknown'),
                    Text(date.toString()),
                  ],
                );
              },
            ),
            ElevatedButton(
              child: const Text("Foreground Mode"),
              onPressed: () {
                FlutterBackgroundService().invoke("setAsForeground");
              },
            ),
            ElevatedButton(
              child: const Text("Background Mode"),
              onPressed: () {
                FlutterBackgroundService().invoke("setAsBackground");
              },
            ),
            ElevatedButton(
              onPressed: () async{
                await DevicePolicyManager.lockNow();
              },
              child: const Text('Block Device'),
            ),
          ],
        ),
      )
    );
  }
}
