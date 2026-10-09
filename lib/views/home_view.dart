import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/app_colors.dart';
import '../controller/home_controller.dart';
import '../models/sidebar_item_model.dart';

import 'chat_view.dart';
import 'dashboard_view.dart';
import 'client_projects_view.dart';
import 'daily_progress_view.dart';
import 'task_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),

      // =====================================================
      // EXISTING SIDEBAR
      // =====================================================
      drawer: _buildSidebar(context, controller),

      // =====================================================
      // APP BAR
      // =====================================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,

        leading: Builder(
          builder: (context) {
            return IconButton(
              tooltip: 'Menu',
              icon: const Icon(
                Icons.menu_rounded,
                size: 29,
                color: AppColors.navy,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),

        title: Obx(
          () => Text(
            _navigationTitle(controller.selectedNavigationIndex.value),
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
        ),

        centerTitle: true,

        actions: [
          IconButton(
            tooltip: 'Notifications',
            icon: const Icon(
              Icons.notifications_none_rounded,
              size: 27,
              color: AppColors.navy,
            ),
            onPressed: () {
              Get.snackbar(
                'Notifications',
                'No new notifications.',
                snackPosition: SnackPosition.BOTTOM,
                margin: const EdgeInsets.all(16),
              );
            },
          ),

          IconButton(
            tooltip: 'Profile',
            icon: const Icon(
              Icons.account_circle_outlined,
              size: 29,
              color: AppColors.navy,
            ),
            onPressed: () {
              Get.snackbar(
                'Profile',
                'Profile page will be connected soon.',
                snackPosition: SnackPosition.BOTTOM,
                margin: const EdgeInsets.all(16),
              );
            },
          ),

          const SizedBox(width: 8),
        ],
      ),

      // =====================================================
      // MAIN BODY
      // =====================================================
      body: Obx(
        () => IndexedStack(
          index: controller.selectedNavigationIndex.value,

          children: const [
            DashboardView(),
            TaskView(),
            ClientProjectsView(),
            DailyProgressView(),
            ChatView(),
          ],
        ),
      ),

      // =====================================================
      // MAIN NAVIGATION BAR
      // =====================================================
      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: controller.selectedNavigationIndex.value,

          onDestinationSelected: controller.changeNavigation,

          backgroundColor: Colors.white,

          elevation: 8,

          indicatorColor: AppColors.primary.withValues(alpha: 0.12),

          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,

          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.task_alt_outlined),
              selectedIcon: Icon(Icons.task_alt_rounded),
              label: 'Task',
            ),
            NavigationDestination(
              icon: Icon(Icons.folder_outlined),
              selectedIcon: Icon(Icons.folder_rounded),
              label: 'Clients',
            ),

            NavigationDestination(
              icon: Icon(Icons.trending_up_outlined),
              selectedIcon: Icon(Icons.trending_up_rounded),
              label: 'Progress',
            ),

            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline_rounded),
              selectedIcon: Icon(Icons.chat_bubble_rounded),
              label: 'Chat',
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // NAVIGATION TITLE
  // =========================================================

  String _navigationTitle(int index) {
    switch (index) {
      case 0:
        return 'Dashboard';

      case 1:
        return 'Task';

      case 2:
        return 'Client & Projects';

      case 3:
        return 'Daily Progress';

      case 4:
        return 'Chat';

      default:
        return 'Dashboard';
    }
  }

  // =========================================================
  // KEEP YOUR EXISTING SIDEBAR
  // =========================================================

  Widget _buildSidebar(BuildContext context, HomeController controller) {
    return Drawer(
      width: 320,
      backgroundColor: const Color(0xFFEEF6F4),
      child: SafeArea(
        child: Column(
          children: [
            _buildSidebarHeader(),

            const Divider(height: 1, color: Color(0xFFD8E4E1)),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount: controller.sidebarItems.length,
                itemBuilder: (context, index) {
                  final item = controller.sidebarItems[index];

                  return _buildMenuItem(context, controller, item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // SIDEBAR HEADER
  // =========================================================

  Widget _buildSidebarHeader() {
    return Builder(
      builder: (context) {
        return SizedBox(
          height: 72,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.business_center_outlined,
                    color: Colors.white,
                    size: 23,
                  ),
                ),

                const SizedBox(width: 12),

                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'HK DigiVerse LLP',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                      Text(
                        'HRMS',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.close_rounded, color: AppColors.navy),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // =========================================================
  // MENU ITEM
  // =========================================================

  Widget _buildMenuItem(
    BuildContext context,
    HomeController controller,
    SidebarItemModel item,
  ) {
    return Obx(() {
      final bool expanded = controller.isExpanded(item.title);

      return Column(
        children: [
          InkWell(
            onTap: () {
              controller.onMenuTap(item);
            },
            child: Container(
              constraints: const BoxConstraints(minHeight: 52),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  SizedBox(
                    width: 34,
                    child: Icon(item.icon, size: 22, color: AppColors.navy),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      item.title,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.navy,
                      ),
                    ),
                  ),

                  if (item.hasChildren)
                    AnimatedRotation(
                      turns: expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 22,
                        color: AppColors.navy,
                      ),
                    ),
                ],
              ),
            ),
          ),

          if (item.hasChildren)
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: _buildChildren(controller, item.children),
              crossFadeState: expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),
        ],
      );
    });
  }

  // =========================================================
  // CHILDREN
  // =========================================================

  Widget _buildChildren(
    HomeController controller,
    List<SidebarItemModel> children,
  ) {
    return Container(
      margin: const EdgeInsets.only(left: 34),
      padding: const EdgeInsets.only(left: 1, bottom: 6),
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: Color(0xFFD5E1DE), width: 1)),
      ),
      child: Column(
        children: children.map((child) {
          return InkWell(
            onTap: () {
              controller.onMenuTap(child, isChild: true);
            },
            child: Container(
              constraints: const BoxConstraints(minHeight: 48),
              padding: const EdgeInsets.only(left: 20, right: 16),
              child: Row(
                children: [
                  Icon(child.icon, size: 20, color: const Color(0xFF697A78)),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      child.title,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
