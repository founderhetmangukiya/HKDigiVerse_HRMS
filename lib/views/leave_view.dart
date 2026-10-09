import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/app_colors.dart';
import '../controller/leave_controller.dart';
import '../models/leave_model.dart';

class LeaveView extends StatelessWidget {
  LeaveView({super.key});

  final LeaveController controller =
  Get.put(LeaveController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFFF7F9FB),

      body: SafeArea(
        child: Obx(
              () => controller.isLoading.value
              ? const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          )
              : RefreshIndicator(
            color: AppColors.primary,
            onRefresh:
            controller.loadLeaveData,
            child: SingleChildScrollView(
              physics:
              const AlwaysScrollableScrollPhysics(),
              padding:
              const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  _buildPageHeader(
                    context,
                  ),

                  const SizedBox(height: 28),

                  _buildSummaryCards(),

                  const SizedBox(height: 28),

                  _buildFilters(context),

                  const SizedBox(height: 24),

                  _buildRequestsSection(
                    context,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // PAGE HEADER
  // =========================================================

  Widget _buildPageHeader(
      BuildContext context,
      ) {
    return LayoutBuilder(
      builder: (
          context,
          constraints,
          ) {
        final isMobile =
            constraints.maxWidth < 700;

        final title = Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const Text(
              'Leave',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 3),

            const Text(
              'View your leave balances, history, and upcoming time off.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        );

        final buttons = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton.icon(
              onPressed: () {
                Get.snackbar(
                  'Calendar',
                  'Calendar view is ready for API integration.',
                  snackPosition:
                  SnackPosition.BOTTOM,
                );
              },
              icon: const Icon(
                Icons.calendar_month_outlined,
                size: 19,
              ),
              label: const Text(
                'View Calendar',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              style:
              OutlinedButton.styleFrom(
                foregroundColor:
                AppColors.navy,
                backgroundColor:
                Colors.white,
                side: const BorderSide(
                  color: AppColors.border,
                ),
                minimumSize:
                const Size(150, 46),
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(width: 14),

            ElevatedButton.icon(
              onPressed:
              controller.openRequestLeave,
              icon: const Icon(
                Icons.add_rounded,
                size: 22,
              ),
              label: const Text(
                'Request Leave',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                AppColors.primary,
                foregroundColor:
                Colors.white,
                elevation: 0,
                minimumSize:
                const Size(160, 46),
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        );

        if (isMobile) {
          return Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              title,
              const SizedBox(height: 18),
              SingleChildScrollView(
                scrollDirection:
                Axis.horizontal,
                child: buttons,
              ),
            ],
          );
        }

        return Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Expanded(child: title),
            buttons,
          ],
        );
      },
    );
  }

  // =========================================================
  // SUMMARY CARDS
  // =========================================================

  Widget _buildSummaryCards() {
    return SizedBox(
      height: 244,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount:
        controller.summaries.length,
        separatorBuilder: (
            context,
            index,
            ) =>
        const SizedBox(width: 18),
        itemBuilder: (
            context,
            index,
            ) {
          return _buildSummaryCard(
            controller.summaries[index],
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(
      LeaveSummaryModel summary,
      ) {
    return Container(
      width: 288,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 22,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===================================================
          // TITLE + ICON
          // ===================================================

          Row(
            children: [
              Expanded(
                child: Text(
                  summary.leaveType,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(
                    alpha: 0.08,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  summary.icon,
                  size: 17,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ===================================================
          // DAYS TAKEN
          // ===================================================

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatNumber(
                  summary.daysTaken,
                ),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),

              const SizedBox(width: 6),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 6,
                  ),
                  child: Text(
                    'Days Taken (${controller.currentMonth})',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ===================================================
          // DIVIDER
          // ===================================================

          const Divider(
            height: 1,
            color: AppColors.border,
          ),

          const SizedBox(height: 12),

          // ===================================================
          // BOTTOM STATISTICS
          // ===================================================

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _miniStat(
                  'Pending',
                  _formatNumber(
                    summary.pendingDays,
                  ),
                ),
              ),

              Expanded(
                child: _miniStat(
                  summary.leaveTypeId == 'monthly'
                      ? 'Free Allowance'
                      : 'Overall',
                  summary.leaveTypeId == 'monthly'
                      ? '${_formatNumber(summary.freeAllowance)} Free Day'
                      : '${_formatNumber(summary.overallAllowance)} Days',
                ),
              ),

              if (summary.leaveTypeId == 'monthly')
                Expanded(
                  child: _miniStat(
                    'Unpaid',
                    '${_formatNumber(summary.unpaidDays)} Day(s)',
                    valueColor: Colors.orange,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniStat(
      String title,
      String value, {
        Color valueColor = Colors.black,
      }) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            color: AppColors.textLight,
          ),
        ),

        const SizedBox(height: 3),

        Text(
          value,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  // =========================================================
  // FILTERS
  // =========================================================

  Widget _buildFilters(
      BuildContext context,
      ) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (
            context,
            constraints,
            ) {
          final compact =
              constraints.maxWidth < 950;

          if (compact) {
            return Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                _filterDropdown(
                  title: 'Leave Type',
                  value: controller
                      .selectedLeaveFilter
                      .value,
                  items: [
                    'All Leave Types',
                    ...controller.leaveTypes
                        .map(
                          (e) => e.name,
                    ),
                  ],
                  onChanged: (value) {
                    controller
                        .selectedLeaveFilter
                        .value =
                        value ?? 'All Leave Types';
                  },
                ),

                const SizedBox(height: 16),

                _filterDropdown(
                  title: 'Status',
                  value: controller
                      .selectedStatusFilter
                      .value,
                  items: const [
                    'All Status',
                    'Pending',
                    'Approved',
                    'Rejected',
                  ],
                  onChanged: (value) {
                    controller
                        .selectedStatusFilter
                        .value =
                        value ?? 'Pending';
                  },
                ),

                const SizedBox(height: 16),

                _dateRangeFilter(
                  context,
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _searchButton(),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _resetButton(),
                    ),
                  ],
                ),
              ],
            );
          }

          return Row(
            crossAxisAlignment:
            CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 250,
                child: _filterDropdown(
                  title: 'Leave Type',
                  value: controller
                      .selectedLeaveFilter
                      .value,
                  items: [
                    'All Leave Types',
                    ...controller.leaveTypes
                        .map(
                          (e) => e.name,
                    ),
                  ],
                  onChanged: (value) {
                    controller
                        .selectedLeaveFilter
                        .value =
                        value ?? 'All Leave Types';
                  },
                ),
              ),

              const SizedBox(width: 26),

              SizedBox(
                width: 170,
                child: _filterDropdown(
                  title: 'Status',
                  value: controller
                      .selectedStatusFilter
                      .value,
                  items: const [
                    'All Status',
                    'Pending',
                    'Approved',
                    'Rejected',
                  ],
                  onChanged: (value) {
                    controller
                        .selectedStatusFilter
                        .value =
                        value ?? 'Pending';
                  },
                ),
              ),

              const SizedBox(width: 26),

              Expanded(
                child: _dateRangeFilter(
                  context,
                ),
              ),

              const SizedBox(width: 18),

              _searchButton(),

              const SizedBox(width: 10),

              _resetButton(),
            ],
          );
        },
      ),
    );
  }

  // =========================================================
  // FILTER DROPDOWN
  // =========================================================

  Widget _filterDropdown({
    required String title,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),

        const SizedBox(height: 8),

        DropdownButtonFormField<String>(
          initialValue: value,
          onChanged: onChanged,
          decoration:
          _filterDecoration(),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.icon,
          ),
          items: items
              .map(
                (item) =>
                DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ),
          )
              .toList(),
        ),
      ],
    );
  }

  InputDecoration _filterDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding:
      const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 13,
      ),
      enabledBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(9),
        borderSide: const BorderSide(
          color: AppColors.border,
        ),
      ),
      focusedBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(9),
        borderSide: const BorderSide(
          color: AppColors.primary,
        ),
      ),
    );
  }

  // =========================================================
  // DATE RANGE
  // =========================================================

  Widget _dateRangeFilter(
      BuildContext context,
      ) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const Text(
          'Date Range',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),

        const SizedBox(height: 8),

        InkWell(
          onTap: () async {
            await controller
                .selectFilterStartDate(
              context,
            );

            if (controller
                .filterStartDate
                .value !=
                null) {
              await controller
                  .selectFilterEndDate(
                context,
              );
            }
          },
          child: Container(
            height: 50,
            padding:
            const EdgeInsets.symmetric(
              horizontal: 14,
            ),
            decoration: BoxDecoration(
              color:
              AppColors.primary
                  .withValues(
                alpha: 0.05,
              ),
              borderRadius:
              BorderRadius.circular(9),
              border: Border.all(
                color: AppColors.border,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    controller
                        .filterStartDate
                        .value ==
                        null
                        ? 'Start date'
                        : controller.formatDate(
                      controller
                          .filterStartDate
                          .value!,
                    ),
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: controller
                          .filterStartDate
                          .value ==
                          null
                          ? AppColors.textLight
                          : AppColors.navy,
                    ),
                  ),
                ),

                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 17,
                  color: AppColors.icon,
                ),

                Expanded(
                  child: Padding(
                    padding:
                    const EdgeInsets.only(
                      left: 10,
                    ),
                    child: Text(
                      controller
                          .filterEndDate
                          .value ==
                          null
                          ? 'End date'
                          : controller.formatDate(
                        controller
                            .filterEndDate
                            .value!,
                      ),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: controller
                            .filterEndDate
                            .value ==
                            null
                            ? AppColors.textLight
                            : AppColors.navy,
                      ),
                    ),
                  ),
                ),

                const Icon(
                  Icons.calendar_month_outlined,
                  size: 19,
                  color: AppColors.icon,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // SEARCH BUTTON
  // =========================================================

  Widget _searchButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        onPressed:
        controller.applyFilters,
        icon: const Icon(
          Icons.search_rounded,
          size: 20,
        ),
        label: const Text(
          'Search',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor:
          AppColors.primary,
          foregroundColor:
          Colors.white,
          elevation: 0,
          padding:
          const EdgeInsets.symmetric(
            horizontal: 25,
          ),
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(9),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // RESET
  // =========================================================

  Widget _resetButton() {
    return SizedBox(
      height: 50,
      child: OutlinedButton.icon(
        onPressed:
        controller.resetFilters,
        icon: const Icon(
          Icons.refresh_rounded,
          size: 20,
        ),
        label: const Text(
          'Reset',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        style:
        OutlinedButton.styleFrom(
          foregroundColor:
          AppColors.navy,
          backgroundColor:
          Colors.white,
          side: const BorderSide(
            color: AppColors.border,
          ),
          padding:
          const EdgeInsets.symmetric(
            horizontal: 22,
          ),
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(9),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // REQUESTS SECTION
  // =========================================================

  Widget _buildRequestsSection(
      BuildContext context,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding:
            const EdgeInsets.all(24),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Leave Requests',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight:
                      FontWeight.w800,
                      color: AppColors.navy,
                    ),
                  ),
                ),

                Text(
                  '${controller.filteredRequests.length} records found',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color:
                    AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const Divider(
            height: 1,
            color: AppColors.border,
          ),

          if (controller
              .filteredRequests
              .isEmpty)
            _buildEmptyState()
          else
            _buildRequestsTable(),
        ],
      ),
    );
  }

  // =========================================================
  // EMPTY STATE
  // =========================================================

  Widget _buildEmptyState() {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
        vertical: 60,
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_busy_outlined,
            size: 48,
            color:
            AppColors.icon,
          ),

          const SizedBox(height: 12),

          const Text(
            'No Leave Requests Found',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Try changing your filters.',
            style: TextStyle(
              fontFamily: 'Poppins',
              color:
              AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // TABLE
  // =========================================================

  Widget _buildRequestsTable() {
    return SingleChildScrollView(
      scrollDirection:
      Axis.horizontal,
      child: DataTable(
        headingRowHeight: 58,
        dataRowMinHeight: 78,
        dataRowMaxHeight: 88,
        columnSpacing: 35,

        headingTextStyle:
        const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
        ),

        columns: const [
          DataColumn(
            label: Text('Sr. No.'),
          ),
          DataColumn(
            label: Text('Leave Type'),
          ),
          DataColumn(
            label: Text('Day Type'),
          ),
          DataColumn(
            label: Text('From'),
          ),
          DataColumn(
            label: Text('Approved By'),
          ),
          DataColumn(
            label: Text('To'),
          ),
          DataColumn(
            label: Text('No. of Days'),
          ),
          DataColumn(
            label: Text('Status'),
          ),
          DataColumn(
            label: Text(''),
          ),
        ],

        rows: List.generate(
          controller.filteredRequests.length,
              (index) {
            final request =
            controller.filteredRequests[
            index];

            return DataRow(
              cells: [
                DataCell(
                  Text(
                    '${(index + 1).toString().padLeft(2, '0')}',
                    style:
                    _tableTextStyle(),
                  ),
                ),

                DataCell(
                  _leaveTypeBadge(
                    request.leaveType,
                  ),
                ),

                DataCell(
                  Text(
                    controller.formatDayType(
                      request.dayType,
                    ),
                    style:
                    _tableTextStyle(),
                  ),
                ),

                DataCell(
                  Text(
                    controller.formatDate(
                      request.startDate,
                    ),
                    style:
                    _tableTextStyle(),
                  ),
                ),

                DataCell(
                  _approvedBy(
                    request,
                  ),
                ),

                DataCell(
                  Text(
                    controller.formatDate(
                      request.endDate,
                    ),
                    style:
                    _tableTextStyle(),
                  ),
                ),

                DataCell(
                  Text(
                    '${_formatNumber(request.numberOfDays)} Day${request.numberOfDays == 1 ? '' : 's'}',
                    style:
                    _tableTextStyle(
                      bold: true,
                    ),
                  ),
                ),

                DataCell(
                  _statusBadge(
                    request.status,
                  ),
                ),

                DataCell(
                  IconButton(
                    onPressed: () =>
                        controller
                            .viewLeaveRequest(
                          request,
                        ),
                    icon: const Icon(
                      Icons
                          .visibility_outlined,
                      color:
                      AppColors.primary,
                      size: 21,
                    ),
                    tooltip:
                    'View Request',
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // =========================================================
  // LEAVE BADGE
  // =========================================================

  Widget _leaveTypeBadge(
      String leaveType,
      ) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color:
        const Color(0xFFF0F4F8),
        borderRadius:
        BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          Text(
            leaveType,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight:
              FontWeight.w700,
              color: AppColors.navy,
            ),
          ),

          const SizedBox(width: 5),

          const Icon(
            Icons.info_outline_rounded,
            size: 14,
            color: AppColors.icon,
          ),
        ],
      ),
    );
  }

  // =========================================================
  // APPROVED BY
  // =========================================================

  Widget _approvedBy(
      LeaveRequestModel request,
      ) {
    if (request.status ==
        LeaveStatus.pending) {
      return const Text(
        'Pending Approval',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      );
    }

    return Row(
      mainAxisSize:
      MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor:
          AppColors.primary
              .withValues(
            alpha: 0.1,
          ),
          child: const Icon(
            Icons.person_outline_rounded,
            color: AppColors.primary,
            size: 20,
          ),
        ),

        const SizedBox(width: 10),

        Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Text(
              request.approvedByName,
              style:
              _tableTextStyle(
                bold: true,
              ),
            ),

            if (request.approvedByRole
                .isNotEmpty)
              Text(
                request.approvedByRole,
                style:
                const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  color:
                  AppColors.textSecondary,
                ),
              ),
          ],
        ),
      ],
    );
  }

  // =========================================================
  // STATUS BADGE
  // =========================================================

  Widget _statusBadge(
      LeaveStatus status,
      ) {
    Color color;
    String text;

    switch (status) {
      case LeaveStatus.approved:
        color = AppColors.primary;
        text = 'Approved';
        break;

      case LeaveStatus.rejected:
        color = Colors.red;
        text = 'Rejected';
        break;

      case LeaveStatus.pending:
        color = Colors.orange;
        text = 'Pending';
        break;
    }

    return Row(
      mainAxisSize:
      MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 7),

        Text(
          text,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color == AppColors.primary
                ? AppColors.navy
                : color,
          ),
        ),
      ],
    );
  }

  // =========================================================
  // TABLE TEXT
  // =========================================================

  TextStyle _tableTextStyle({
    bool bold = false,
  }) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: 13,
      fontWeight:
      bold ? FontWeight.w700 : FontWeight.w500,
      color: AppColors.navy,
    );
  }

  // =========================================================
  // FORMAT NUMBER
  // =========================================================

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(1);
  }
}