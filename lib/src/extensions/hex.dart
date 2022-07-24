import 'package:flutter/material.dart';

/// [hex] for converting color to int
extension Hex on Color{
  int get hex {
    return int.parse('0x${value.toRadixString(16)}');
  }
}