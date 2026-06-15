import 'dart:convert';

import 'package:flutter/services.dart';

class DeviceConfig {
  DeviceConfig({required this.dorianId});

  final int dorianId;

  static Future<DeviceConfig> load() async {
    final raw = await rootBundle.loadString('config.json');
    final data = jsonDecode(raw) as Map<String, dynamic>;
    final id = int.tryParse(data['dorianId']?.toString() ?? '');

    if (id == null || id <= 0) {
      throw const FormatException('config.json must include a positive dorianId');
    }

    return DeviceConfig(dorianId: id);
  }
}
