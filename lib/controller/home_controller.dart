import 'package:demo_project/views/change_password_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/sidebar_item_model.dart';
import '../views/leave_view.dart';
import '../views/login_page.dart';

class HomeController extends GetxController {
  final RxInt selectedNavigationIndex = 0.obs;

  void changeNavigation(int index) {
    selectedNavigationIndex.value = index;
  }

  final RxMap<String, bool> expandedMenus = <String, bool>{}.obs;

  void toggleMenu(String title) {
    expandedMenus[title] = !(expandedMenus[title] ?? false);
  }

  bool isExpanded(String title) {
    return expandedMenus[title] ?? false;
  }

  final List<SidebarItemModel> sidebarItems = [
    const SidebarItemModel(
      title: 'Employee List',
      icon: Icons.people_outline_rounded,
    ),

    const SidebarItemModel(
      title: 'Org Structure',
      icon: Icons.account_tree_outlined,
    ),

    const SidebarItemModel(
      title: 'Attendance',
      icon: Icons.fact_check_outlined,
    ),

    const SidebarItemModel(
      title: 'Leave',
      icon: Icons.event_available_outlined,
    ),

    const SidebarItemModel(title: 'Work Logs', icon: Icons.access_time_rounded),

    const SidebarItemModel(
      title: 'Schedule',
      icon: Icons.calendar_month_outlined,
    ),

    // =======================================================
    // WORKSPACE
    // =======================================================
    const SidebarItemModel(
      title: 'Workspace',
      icon: Icons.work_outline_rounded,
      children: [
        SidebarItemModel(
          title: 'Seating Arrangement',
          icon: Icons.event_seat_outlined,
        ),
        SidebarItemModel(
          title: 'Resource Management',
          icon: Icons.inventory_2_outlined,
        ),
        SidebarItemModel(title: 'Gallery', icon: Icons.photo_library_outlined),
      ],
    ),

    // =======================================================
    // PAYROLL
    // =======================================================
    const SidebarItemModel(
      title: 'Payroll',
      icon: Icons.payments_outlined,
      children: [
        SidebarItemModel(
          title: 'Payroll Dashboard',
          icon: Icons.dashboard_outlined,
        ),
        SidebarItemModel(
          title: 'Salary Structure',
          icon: Icons.account_balance_wallet_outlined,
        ),
        SidebarItemModel(title: 'Payroll Settings', icon: Icons.tune_rounded),
        SidebarItemModel(
          title: 'Payroll Processing',
          icon: Icons.play_circle_outline_rounded,
        ),
        SidebarItemModel(
          title: 'Bonus & Deductions',
          icon: Icons.card_giftcard_outlined,
        ),
        SidebarItemModel(title: 'Payslips', icon: Icons.description_outlined),
      ],
    ),

    // =======================================================
    // FINANCE
    // =======================================================
    const SidebarItemModel(
      title: 'Finance',
      icon: Icons.account_balance_outlined,
      children: [
        SidebarItemModel(title: 'Transactions', icon: Icons.swap_horiz_rounded),
        SidebarItemModel(title: 'Plan', icon: Icons.receipt_long_outlined),
        SidebarItemModel(title: 'Summary', icon: Icons.summarize_outlined),
        SidebarItemModel(
          title: 'Other Transactions',
          icon: Icons.more_horiz_rounded,
        ),
      ],
    ),

    // =======================================================
    // SALES
    // =======================================================
    const SidebarItemModel(
      title: 'Sales',
      icon: Icons.assignment_outlined,
      children: [
        SidebarItemModel(title: 'Dashboard', icon: Icons.dashboard_outlined),
        SidebarItemModel(title: 'Pipeline', icon: Icons.view_column_outlined),
        SidebarItemModel(title: 'Leads', icon: Icons.people_outline_rounded),
        SidebarItemModel(
          title: 'Tasks & Follow-ups',
          icon: Icons.assignment_turned_in_outlined,
        ),
        SidebarItemModel(
          title: 'Sales Analytics',
          icon: Icons.bar_chart_outlined,
        ),
        SidebarItemModel(
          title: 'Team Performance',
          icon: Icons.emoji_events_outlined,
        ),
        SidebarItemModel(title: 'Reports', icon: Icons.description_outlined),
        SidebarItemModel(title: 'Settings', icon: Icons.tune_rounded),
      ],
    ),

    // =======================================================
    // INVOICE
    // =======================================================
    const SidebarItemModel(
      title: 'Invoice',
      icon: Icons.receipt_long_outlined,
      children: [
        SidebarItemModel(title: 'Invoices', icon: Icons.receipt_outlined),
        SidebarItemModel(
          title: 'Quotation',
          icon: Icons.request_quote_outlined,
        ),
        SidebarItemModel(title: 'Ledger', icon: Icons.menu_book_outlined),
      ],
    ),

    const SidebarItemModel(
      title: 'Interviews & Hiring',
      icon: Icons.person_search_outlined,
    ),

    const SidebarItemModel(
      title: 'Document Center',
      icon: Icons.folder_outlined,
    ),

    const SidebarItemModel(
      title: 'Sub-Departments & Designations',
      icon: Icons.account_tree_outlined,
    ),

    const SidebarItemModel(
      title: 'Penalty',
      icon: Icons.warning_amber_outlined,
    ),

    const SidebarItemModel(title: 'Remarks', icon: Icons.comment_outlined),

    const SidebarItemModel(title: 'Research', icon: Icons.science_outlined),

    const SidebarItemModel(title: 'Access Control', icon: Icons.control_camera),

    const SidebarItemModel(title: 'Recycle Bin', icon: Icons.delete),

    const SidebarItemModel(title: 'Settings', icon: Icons.settings),

    const SidebarItemModel(title: 'Change Password', icon: Icons.password),

    const SidebarItemModel(title: 'Logout', icon: Icons.exit_to_app),
  ];

  // =========================================================
  // MENU TAP
  // =========================================================

  void onMenuTap(SidebarItemModel item, {bool isChild = false}) {
    // Parent menu with children
    if (item.hasChildren && !isChild) {
      toggleMenu(item.title);
      return;
    }

    // Leave
    if (item.title == 'Change Password') {
      Get.back();

      Get.to(() => ChangePasswordView(), transition: Transition.rightToLeft);

      return;
    }
    // Leave
    if (item.title == 'Leave') {
      Get.back();

      Get.to(
        () => LeaveView(),
        transition: Transition.rightToLeft,
        duration: const Duration(milliseconds: 350),
      );

      return;
    }

    // Logout
    if (item.title == 'Logout') {
      logout();
      return;
    }

    // Everything else
    Get.snackbar(
      item.title,
      'Work in Progress',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
      backgroundColor: const Color(0xFF061B41),
      colorText: Colors.white,
      icon: const Icon(Icons.construction_outlined, color: Colors.white),
    );
  }

  // =========================================================
  // LOGOUT
  // =========================================================

  void logout() {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),

        content: const Text('Are you sure you want to logout?'),

        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Cancel'),
          ),

          TextButton(
            onPressed: () async {
              // =============================================
              // FUTURE:
              // 1. Call Logout API
              // 2. Clear Token
              // 3. Clear User Data
              // 4. Clear Local Storage
              // =============================================

              Get.offAll(
                () => LoginPage(),
                transition: Transition.fadeIn,
                duration: const Duration(milliseconds: 300),
              );
            },
            child: const Text(
              'Yes, Logout',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
