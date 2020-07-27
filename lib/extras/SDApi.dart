import 'package:beacon_broadcast/beacon_broadcast.dart';

class SDApi {

  BeaconBroadcast beaconBroadcast = BeaconBroadcast();

  invokeSocDistance(){
    print("invoking SD Api");
    beaconBroadcast
      .setUUID('CB10023F-A318-3394-4199-A8730C7C1AEC')
      .setMajorId(1)
      .setMinorId(100) //optional
      .setIdentifier("Cubeacon") //iOS-only, optional
      .start();
  }

  monitorApi() {
    return beaconBroadcast.isAdvertising();
  }

  stopTransmission() {
    print("Stopping SD Api");
    beaconBroadcast.stop();
  }

}