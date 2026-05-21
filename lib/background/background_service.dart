import 'dart:async';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';

Future<void> initialService() async {
  final serviice = FlutterBackgroundService();
  await serviice.configure(
      iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration(
          onStart: onStart,
          isForegroundMode: true,
          autoStart: false,
          autoStartOnBoot: false));
  // if (await serviice.isRunning()) {
  //   print("Already run a service");
  //   stopBackgroundService();
  // } else {
  serviice.startService();
  //}
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  if (service is AndroidServiceInstance) {
    service.on("setAsForeground").listen((event) {
      service.setAsForegroundService();
    });
    // service.on("setAsBackeground").listen((event) {
    //   service.setAsBackgroundService();

    //   // stopBackgroundService();
    // });
    // service.on("task1").listen((event) {
    //   print("Task is inilisize and it running right now to build");
    //   task1Logic();
    // });
    // service.on("stopTask1").listen((event) {
    //   print("Stop Task 1 listener triggered");
    //   stopTask1();
    // });
    // service.on("isForegroundMode").listen((event) {
    //   stopBackgroundService(service);
    //   service.stopSelf();
    // });
  }
  service.on("stopService").listen((event) {
    service.stopSelf();
  });

  // Timer.periodic(Duration(seconds: 2), (timer) async {
  //   if (service is AndroidServiceInstance) {
  //     if (await service.isForegroundService()) {
  //       // var allData = await AuthApiRepository().getMasterrepo();
  //       // print("${allData} ${DateTime.now().second}");
  //       print(
  //           "Ths is the foreground service run in background ${DateTime.now().second}");
  //     }
  //   }
  // });
  service.on('onDestroy').listen((event) {
    // Handle service destruction here
    service.stopSelf();
  });
}

void stopTask1() {
  task1Running = false;
}

void invokeStopTask1() {
  final service = FlutterBackgroundService();
  service.invoke("stopTask1");
}

stopBackgroundService() {
  final service = FlutterBackgroundService();
  service.invoke(
      "stopService"); // this word "stopService" can stop the service which beacause of service.stopSelf() on the service.on("stopService")
}

bool task1Running = true;
bool task2Running = true;
void task1Logic() async {
  print("Executing Task 1");
  task1Running = true;

  while (task1Running) {
    await Future.delayed(Duration(seconds: 2));
    print("Task 1 is running ${DateTime.now().second}");
  }

  print("Task 1 stopped");
}

void stopBackgroundServicetask() {
  final service = FlutterBackgroundService();
  service.invoke("task1");
}

void stopBackgroundServicetaskR() {
  final service = FlutterBackgroundService();
  service.invoke("task1R");
}
