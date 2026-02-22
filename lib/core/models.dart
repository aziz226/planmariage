import 'package:flutter/material.dart';

class ServiceModel {
  final String title;
  final String description;
  final IconData icon;
  final int count;
  final String providerLabel;

  const ServiceModel({
    required this.title,
    required this.description,
    required this.icon,
    required this.count,
    required this.providerLabel,
  });
}

class PackModel {
  final String title;
  final String qualifier;
  final String price;
  final String description;
  final List<String> includes;

  const PackModel({
    required this.title,
    required this.qualifier,
    required this.price,
    required this.description,
    required this.includes,
  });
}
