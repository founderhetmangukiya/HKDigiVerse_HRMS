import 'package:flutter/material.dart';

class SidebarItemModel {
  final String title;
  final IconData icon;
  final List<SidebarItemModel> children;

  const SidebarItemModel({
    required this.title,
    required this.icon,
    this.children = const [],
  });

  bool get hasChildren => children.isNotEmpty;
}