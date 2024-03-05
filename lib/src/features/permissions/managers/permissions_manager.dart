import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class PermissionsManager {
  bool? _permissionsGranted;

  Future<bool> validatePermissions() async {
    final permissionsGranted = _permissionsGranted;
    if (permissionsGranted != null) return permissionsGranted;

    final Map<Permission, PermissionStatus> permissions;
    if (Platform.isAndroid) {
      permissions = await [
        Permission.manageExternalStorage,
        Permission.microphone,
      ].request();
    } else {
      permissions = await [
        Permission.microphone,
      ].request();
    }

    _permissionsGranted =
        permissions.values.every((element) => element.isGranted);

    if (_permissionsGranted == false &&
        permissions.values.any((permission) =>
            permission.isDenied || permission.isPermanentlyDenied)) {
      openAppSettings();
    }

    return _permissionsGranted ?? false;
  }
}
