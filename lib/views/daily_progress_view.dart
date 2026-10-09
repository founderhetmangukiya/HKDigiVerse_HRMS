import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/app_colors.dart';

class DailyProgressView extends StatefulWidget {
  const DailyProgressView({super.key});

  @override
  State<DailyProgressView> createState() => _DailyProgressViewState();
}

class _DailyProgressViewState extends State<DailyProgressView> {
  // ===========================================================================
  // FILTERS
  // ===========================================================================

  final TextEditingController _searchController =
  TextEditingController();

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  String _selectedStatus = 'All';

  // ===========================================================================
  // DEMO DATA
  // Replace this list with API/controller data later.
  // ===========================================================================

  final List<DailyProgressModel> _allRecords = [
    DailyProgressModel(
      name: 'Parth Devani',
      designation: 'Sales',
      dateTime: '2026-10-04 • 07:58',
      status: DailyProgressStatus.pending,
      completedTasks: 0,
      pendingTasks: 4,
      rating: 0,
      approvedDate: null,
      approvedBy: null,
      remarks: null,
    ),
    DailyProgressModel(
      name: 'Het Patel',
      designation: 'Digital Marketing',
      dateTime: '2026-10-04 • 09:12',
      status: DailyProgressStatus.verified,
      completedTasks: 8,
      pendingTasks: 2,
      rating: 4.5,
      approvedDate: '2026-10-04',
      approvedBy: 'Rahul Shah',
      remarks: 'Good progress today. Keep improving client follow-ups.',
    ),
    DailyProgressModel(
      name: 'Krisha Shah',
      designation: 'HR',
      dateTime: '2026-10-04 • 09:25',
      status: DailyProgressStatus.verified,
      completedTasks: 6,
      pendingTasks: 1,
      rating: 4.0,
      approvedDate: '2026-10-04',
      approvedBy: 'Het Mangukiya',
      remarks: 'Tasks completed properly. Documentation is maintained.',
    ),
    DailyProgressModel(
      name: 'Dev Patel',
      designation: 'Development',
      dateTime: '2026-10-04 • 10:05',
      status: DailyProgressStatus.rejected,
      completedTasks: 3,
      pendingTasks: 6,
      rating: 2.5,
      approvedDate: '2026-10-04',
      approvedBy: 'Parth Devani',
      remarks: 'Several assigned tasks are still incomplete.',
    ),
  ];

  // ===========================================================================
  // LIFECYCLE
  // ===========================================================================

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ===========================================================================
  // FILTERED RECORDS
  // ===========================================================================

  List<DailyProgressModel> get _filteredRecords {
    final search = _searchController.text.trim().toLowerCase();

    return _allRecords.where((record) {
      final matchesSearch =
          search.isEmpty ||
              record.name.toLowerCase().contains(search) ||
              record.designation.toLowerCase().contains(search);

      final matchesStatus =
          _selectedStatus == 'All' ||
              _statusText(record.status) == _selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  // ===========================================================================
  // KPI
  // ===========================================================================

  int get _totalVerification => _allRecords.length;

  int get _pendingCount => _allRecords
      .where(
        (item) => item.status == DailyProgressStatus.pending,
  )
      .length;

  int get _rejectedCount => _allRecords
      .where(
        (item) => item.status == DailyProgressStatus.rejected,
  )
      .length;

  int get _verifiedCount => _allRecords
      .where(
        (item) => item.status == DailyProgressStatus.verified,
  )
      .length;

  double get _averageRating {
    final ratedRecords = _allRecords
        .where((item) => item.rating > 0)
        .toList();

    if (ratedRecords.isEmpty) {
      return 0;
    }

    final total = ratedRecords.fold<double>(
      0,
          (sum, item) => sum + item.rating,
    );

    return total / ratedRecords.length;
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final bool isMobile = width < 600;
        final bool isTablet = width >= 600 && width < 1000;

        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              isMobile
                  ? 16
                  : isTablet
                  ? 24
                  : 32,
              isMobile ? 20 : 28,
              isMobile
                  ? 16
                  : isTablet
                  ? 24
                  : 32,
              30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(
                  isMobile: isMobile,
                  isTablet: isTablet,
                ),

                SizedBox(
                  height: isMobile ? 20 : 26,
                ),

                _buildKpiSection(
                  isMobile: isMobile,
                  isTablet: isTablet,
                ),

                SizedBox(
                  height: isMobile ? 18 : 22,
                ),

                _buildFilters(
                  isMobile: isMobile,
                  isTablet: isTablet,
                ),

                SizedBox(
                  height: isMobile ? 18 : 22,
                ),

                _buildResultsHeader(
                  isMobile: isMobile,
                ),

                const SizedBox(height: 12),

                _buildCards(
                  isMobile: isMobile,
                  isTablet: isTablet,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // HEADER
  // ===========================================================================

  Widget _buildHeader({
    required bool isMobile,
    required bool isTablet,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Progress',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: isMobile
                ? 26
                : isTablet
                ? 30
                : 34,
            fontWeight: FontWeight.w800,
            color: AppColors.navy,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Review, verify and approve employee daily progress.',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: isMobile ? 12.5 : 14,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // KPI SECTION
  // ===========================================================================

  Widget _buildKpiSection({
    required bool isMobile,
    required bool isTablet,
  }) {
    final items = [
      _KpiItem(
        title: 'Total Verification',
        value: '$_totalVerification',
        icon: Icons.fact_check_outlined,
        color: AppColors.navy,
      ),
      _KpiItem(
        title: 'Pending',
        value: '$_pendingCount',
        icon: Icons.pending_actions_rounded,
        color: const Color(0xFFFF9800),
      ),
      _KpiItem(
        title: 'Reject',
        value: '$_rejectedCount',
        icon: Icons.cancel_outlined,
        color: const Color(0xFFE53935),
      ),
      _KpiItem(
        title: 'Verify',
        value: '$_verifiedCount',
        icon: Icons.verified_outlined,
        color: AppColors.primary,
      ),
      _KpiItem(
        title: 'Avg Rating',
        value: _averageRating.toStringAsFixed(1),
        icon: Icons.star_outline_rounded,
        color: const Color(0xFFF59E0B),
      ),
    ];

    if (isMobile) {
      return SizedBox(
        height: 112,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (_, __) =>
          const SizedBox(width: 10),
          itemBuilder: (context, index) {
            return SizedBox(
              width: 170,
              child: _buildKpiCard(items[index]),
            );
          },
        ),
      );
    }

    if (isTablet) {
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: items.map((item) {
          return SizedBox(
            width: 185,
            child: _buildKpiCard(item),
          );
        }).toList(),
      );
    }

    return Row(
      children: items.map((item) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: item == items.last ? 0 : 14,
            ),
            child: _buildKpiCard(item),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildKpiCard(_KpiItem item) {
    return Container(
      height: 112,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  item.icon,
                  size: 18,
                  color: item.color,
                ),
              ),
              const Spacer(),
              Text(
                item.value,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: item.color,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // FILTERS
  // ===========================================================================

  Widget _buildFilters({
    required bool isMobile,
    required bool isTablet,
  }) {
    return Container(
      padding: EdgeInsets.all(
        isMobile ? 14 : 18,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FBFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 750) {
            return Column(
              children: [
                _buildSearchField(
                  width: double.infinity,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildDateField(
                        label: 'Start Date',
                        date: _startDate,
                        onTap: () =>
                            _selectDate(isStart: true),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildDateField(
                        label: 'End Date',
                        date: _endDate,
                        onTap: () =>
                            _selectDate(isStart: false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildStatusDropdown(
                  width: double.infinity,
                ),
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildSearchField(
                  width: double.infinity,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDateField(
                  label: 'Start Date',
                  date: _startDate,
                  onTap: () =>
                      _selectDate(isStart: true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDateField(
                  label: 'End Date',
                  date: _endDate,
                  onTap: () =>
                      _selectDate(isStart: false),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatusDropdown(
                  width: double.infinity,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchField({
    required double width,
  }) {
    return SizedBox(
      width: width,
      height: 48,
      child: TextField(
        controller: _searchController,
        onChanged: (_) {
          setState(() {});
        },
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          color: AppColors.navy,
        ),
        decoration: InputDecoration(
          hintText: 'Search employee...',
          hintStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12.5,
            color: AppColors.textLight,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: 20,
            color: AppColors.icon,
          ),
          suffixIcon:
          _searchController.text.isNotEmpty
              ? IconButton(
            onPressed: () {
              _searchController.clear();
              setState(() {});
            },
            icon: const Icon(
              Icons.close_rounded,
              size: 18,
            ),
          )
              : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
          const EdgeInsets.symmetric(
            horizontal: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.border,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.border,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 17,
              color: AppColors.icon,
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 8.5,
                      color: AppColors.textLight,
                    ),
                  ),
                  Text(
                    DateFormat('dd MMM yyyy')
                        .format(date),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusDropdown({
    required double width,
  }) {
    return SizedBox(
      width: width,
      height: 48,
      child: DropdownButtonFormField<String>(
        initialValue: _selectedStatus,
        isExpanded: true,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          color: AppColors.navy,
        ),
        decoration: InputDecoration(
          labelText: 'Status',
          labelStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 10,
            color: AppColors.textLight,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
          const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.border,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.border,
            ),
          ),
        ),
        items: const [
          DropdownMenuItem(
            value: 'All',
            child: Text('All'),
          ),
          DropdownMenuItem(
            value: 'Pending',
            child: Text('Pending'),
          ),
          DropdownMenuItem(
            value: 'Verified',
            child: Text('Verified'),
          ),
          DropdownMenuItem(
            value: 'Rejected',
            child: Text('Rejected'),
          ),
        ],
        onChanged: (value) {
          if (value == null) return;

          setState(() {
            _selectedStatus = value;
          });
        },
      ),
    );
  }

  // ===========================================================================
  // DATE PICKER
  // ===========================================================================

  Future<void> _selectDate({
    required bool isStart,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
      isStart ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme:
            Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;

    setState(() {
      if (isStart) {
        _startDate = picked;

        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate;
        }
      } else {
        _endDate = picked;

        if (_endDate.isBefore(_startDate)) {
          _startDate = _endDate;
        }
      }
    });
  }

  // ===========================================================================
  // RESULT HEADER
  // ===========================================================================

  Widget _buildResultsHeader({
    required bool isMobile,
  }) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Verification Records',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
        ),
        Text(
          '${_filteredRecords.length} Records',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // CARDS
  // ===========================================================================

  Widget _buildCards({
    required bool isMobile,
    required bool isTablet,
  }) {
    final records = _filteredRecords;

    if (records.isEmpty) {
      return _buildEmptyState();
    }

    if (isMobile) {
      return Column(
        children: records.map((record) {
          return Padding(
            padding: const EdgeInsets.only(
              bottom: 12,
            ),
            child: _buildProgressCard(
              record,
              isMobile: true,
            ),
          );
        }).toList(),
      );
    }

    return Column(
      children: records.map((record) {
        return Padding(
          padding: const EdgeInsets.only(
            bottom: 12,
          ),
          child: _buildProgressCard(
            record,
            isMobile: false,
          ),
        );
      }).toList(),
    );
  }

  // ===========================================================================
  // EMPLOYEE CARD
  // ===========================================================================

  Widget _buildProgressCard(
      DailyProgressModel record, {
        required bool isMobile,
      }) {
    final statusColor = _statusColor(record.status);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.018,
            ),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(
              isMobile ? 18 : 22,
            ),
            child: isMobile
                ? _buildMobileCardTop(
              record,
              statusColor,
            )
                : _buildDesktopCardTop(
              record,
              statusColor,
            ),
          ),

          const Divider(
            height: 1,
            color: AppColors.border,
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(
              isMobile ? 18 : 22,
              16,
              isMobile ? 18 : 22,
              16,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  size: 19,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'Completed Tasks (${record.completedTasks})',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(
              isMobile ? 18 : 22,
              0,
              isMobile ? 18 : 22,
              18,
            ),
            child: Row(
              children: [
                const SizedBox(width: 28),
                Expanded(
                  child: Text(
                    record.completedTasks == 0
                        ? 'No tasks completed.'
                        : '${record.completedTasks} tasks completed today.',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(
            height: 1,
            color: AppColors.border,
          ),

          // VIEW FULL REPORT
          InkWell(
            onTap: () => _showFullReport(record),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 14,
              ),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: const [
                  Text(
                    'View Full Report',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 17,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // DESKTOP CARD TOP
  // ===========================================================================

  Widget _buildDesktopCardTop(
      DailyProgressModel record,
      Color statusColor,
      ) {
    return Row(
      children: [
        _buildAvatar(record.name),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                record.name,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                record.designation,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        Row(
          children: [
            const Icon(
              Icons.access_time_rounded,
              size: 17,
              color: AppColors.icon,
            ),
            const SizedBox(width: 7),
            Text(
              record.dateTime,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),

        const SizedBox(width: 20),

        _buildStatusBadge(
          record.status,
          statusColor,
        ),
      ],
    );
  }

  // ===========================================================================
  // MOBILE CARD TOP
  // ===========================================================================

  Widget _buildMobileCardTop(
      DailyProgressModel record,
      Color statusColor,
      ) {
    return Column(
      children: [
        Row(
          children: [
            _buildAvatar(record.name),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    record.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    record.designation,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            _buildStatusBadge(
              record.status,
              statusColor,
            ),
          ],
        ),

        const SizedBox(height: 14),

        Row(
          children: [
            const Icon(
              Icons.access_time_rounded,
              size: 16,
              color: AppColors.icon,
            ),
            const SizedBox(width: 7),
            Text(
              record.dateTime,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ===========================================================================
  // AVATAR
  // ===========================================================================

  Widget _buildAvatar(String name) {
    final initial =
    name.trim().isEmpty
        ? '?'
        : name.trim()[0].toUpperCase();

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(
          alpha: 0.10,
        ),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 21,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  // ===========================================================================
  // STATUS BADGE
  // ===========================================================================

  Widget _buildStatusBadge(
      DailyProgressStatus status,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withValues(alpha: 0.20),
        ),
      ),
      child: Text(
        _statusText(status).toUpperCase(),
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }

  // ===========================================================================
  // EMPTY
  // ===========================================================================

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 60,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 42,
            color: AppColors.icon,
          ),
          SizedBox(height: 12),
          Text(
            'No records found',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Try changing your search or filters.',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // FULL REPORT POPUP
  // ===========================================================================

  void _showFullReport(
      DailyProgressModel record,
      ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 650,
              maxHeight: 720,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildAvatar(record.name),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Full Progress Report',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight:
                                FontWeight.w800,
                                color: AppColors.navy,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              record.name,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color:
                                AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            Navigator.pop(context),
                        icon: const Icon(
                          Icons.close_rounded,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  const Divider(
                    color: AppColors.border,
                  ),

                  const SizedBox(height: 20),

                  _buildReportInfo(
                    'Name',
                    record.name,
                  ),

                  _buildReportInfo(
                    'Designation',
                    record.designation,
                  ),

                  _buildReportInfo(
                    'Approval Date',
                    record.approvedDate ??
                        'Not approved yet',
                  ),

                  _buildReportInfo(
                    'Approved By',
                    record.approvedBy ??
                        'Pending approval',
                  ),

                  const SizedBox(height: 12),

                  _buildRatingSection(record),

                  const SizedBox(height: 22),

                  _buildReportTaskSection(
                    title: 'Completed Today Tasks',
                    value:
                    record.completedTasks,
                    icon:
                    Icons.check_circle_outline_rounded,
                    color: AppColors.primary,
                  ),

                  const SizedBox(height: 12),

                  _buildReportTaskSection(
                    title: 'Pending Tasks',
                    value:
                    record.pendingTasks,
                    icon:
                    Icons.pending_actions_rounded,
                    color:
                    const Color(0xFFFF9800),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'Remarks',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius:
                      BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.border,
                      ),
                    ),
                    child: Text(
                      record.remarks ??
                          'No remarks available.',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12.5,
                        color:
                        AppColors.textSecondary,
                        height: 1.55,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor:
                        AppColors.primary,
                        foregroundColor: Colors.white,
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Close',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // REPORT INFO
  // ===========================================================================

  Widget _buildReportInfo(
      String title,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 14,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // RATING
  // ===========================================================================

  Widget _buildRatingSection(
      DailyProgressModel record,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFFDE68A),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.star_rounded,
            color: Color(0xFFF59E0B),
            size: 28,
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Approval Rating',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
            ),
          ),
          Text(
            '${record.rating.toStringAsFixed(1)} / 5',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFFF59E0B),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // TASK REPORT
  // ===========================================================================

  Widget _buildReportTaskSection({
    required String title,
    required int value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: color.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 19,
              color: color,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
            ),
          ),
          Text(
            '$value',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // STATUS HELPERS
  // ===========================================================================

  String _statusText(
      DailyProgressStatus status,
      ) {
    switch (status) {
      case DailyProgressStatus.pending:
        return 'Pending';
      case DailyProgressStatus.verified:
        return 'Verified';
      case DailyProgressStatus.rejected:
        return 'Rejected';
    }
  }

  Color _statusColor(
      DailyProgressStatus status,
      ) {
    switch (status) {
      case DailyProgressStatus.pending:
        return const Color(0xFFFF9800);

      case DailyProgressStatus.verified:
        return AppColors.primary;

      case DailyProgressStatus.rejected:
        return const Color(0xFFE53935);
    }
  }
}

// =============================================================================
// MODEL
// =============================================================================

enum DailyProgressStatus {
  pending,
  verified,
  rejected,
}

class DailyProgressModel {
  final String name;
  final String designation;
  final String dateTime;
  final DailyProgressStatus status;

  final int completedTasks;
  final int pendingTasks;

  final double rating;

  final String? approvedDate;
  final String? approvedBy;
  final String? remarks;

  const DailyProgressModel({
    required this.name,
    required this.designation,
    required this.dateTime,
    required this.status,
    required this.completedTasks,
    required this.pendingTasks,
    required this.rating,
    required this.approvedDate,
    required this.approvedBy,
    required this.remarks,
  });
}

// =============================================================================
// KPI MODEL
// =============================================================================

class _KpiItem {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
}