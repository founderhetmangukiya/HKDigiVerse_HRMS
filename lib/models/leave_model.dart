import 'package:flutter/material.dart';

enum LeaveStatus {
  pending,
  approved,
  rejected,
}

enum LeaveDayType {
  fullDay,
  firstHalf,
  secondHalf,
}

class LeaveTypeModel {
  final String id;
  final String name;
  final IconData icon;

  final double overallAllowance;

  // Monthly leave has free allowance.
  final double freeAllowance;

  // Whether this leave can be requested.
  final bool isPaid;

  const LeaveTypeModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.overallAllowance,
    this.freeAllowance = 0,
    this.isPaid = true,
  });
}

class LeaveSummaryModel {
  final String leaveTypeId;
  final String leaveType;
  final IconData icon;

  double daysTaken;
  double pendingDays;
  double overallAllowance;
  double freeAllowance;
  double unpaidDays;

  LeaveSummaryModel({
    required this.leaveTypeId,
    required this.leaveType,
    required this.icon,
    this.daysTaken = 0,
    this.pendingDays = 0,
    this.overallAllowance = 0,
    this.freeAllowance = 0,
    this.unpaidDays = 0,
  });

  double get remainingDays {
    final remaining = overallAllowance - daysTaken - pendingDays;
    return remaining < 0 ? 0 : remaining;
  }
}

class LeaveRequestModel {
  final String id;
  final String leaveTypeId;
  final String leaveType;
  final LeaveDayType dayType;

  final DateTime startDate;
  final DateTime endDate;

  final double numberOfDays;

  final String reason;

  final String? proofFileName;

  LeaveStatus status;

  final String approvedByName;
  final String approvedByRole;
  final String? approvedByImage;

  final DateTime createdAt;

  LeaveRequestModel({
    required this.id,
    required this.leaveTypeId,
    required this.leaveType,
    required this.dayType,
    required this.startDate,
    required this.endDate,
    required this.numberOfDays,
    required this.reason,
    this.proofFileName,
    required this.status,
    required this.approvedByName,
    required this.approvedByRole,
    this.approvedByImage,
    required this.createdAt,
  });
}