import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/app_colors.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  Timer? _timer;

  DateTime _now = DateTime.now();

  // ---------------------------------------------------------------------------
  // DYNAMIC DATA
  // ---------------------------------------------------------------------------

  int workingDay = 3;
  int totalWorkingDays = 27;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (_) {
        if (!mounted) return;

        setState(() {
          _now = DateTime.now();
        });
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // DYNAMIC TIME
  // ---------------------------------------------------------------------------

  String get greeting {
    final hour = _now.hour;

    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    }

    if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    }

    if (hour >= 17 && hour < 21) {
      return 'Good Evening';
    }

    return 'Good Night';
  }

  String get timeText {
    return DateFormat('hh:mm:ss a').format(_now);
  }

  String get dateText {
    return DateFormat('MMM dd, yyyy').format(_now);
  }

  String get monthText {
    return DateFormat('MMMM').format(_now);
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;

        final bool isMobile = width < 600;
        final bool isTablet = width >= 600 && width < 1000;
        final bool isDesktop = width >= 1000;

        final double horizontalPadding = isMobile
            ? 16
            : isTablet
            ? 24
            : 32;

        final double verticalPadding = isMobile ? 20 : 28;

        return Container(
          width: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              verticalPadding,
              horizontalPadding,
              30,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(
                  isMobile: isMobile,
                  isTablet: isTablet,
                ),

                SizedBox(
                  height: isMobile ? 22 : 30,
                ),

                _buildResponsiveCards(
                  width: width,
                  isMobile: isMobile,
                  isTablet: isTablet,
                  isDesktop: isDesktop,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // HEADER
  // ---------------------------------------------------------------------------

  Widget _buildHeader({
    required bool isMobile,
    required bool isTablet,
  }) {
    final double titleSize = isMobile
        ? 26
        : isTablet
        ? 32
        : 40;

    final double subtitleSize = isMobile ? 12.5 : 14.5;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$greeting, ',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: titleSize,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  height: 1.15,
                ),
              ),
              TextSpan(
                text: 'Parth',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: titleSize,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  height: 1.15,
                ),
              ),
              TextSpan(
                text: ' 👋',
                style: TextStyle(
                  fontSize: isMobile ? 23 : 29,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        Text(
          "Today's overview — everything moving across the company, in one screen.",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: subtitleSize,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            height: 1.45,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // RESPONSIVE CARDS
  // ---------------------------------------------------------------------------

  Widget _buildResponsiveCards({
    required double width,
    required bool isMobile,
    required bool isTablet,
    required bool isDesktop,
  }) {
    final double availableWidth = width -
        (isMobile
            ? 32
            : isTablet
            ? 48
            : 64);

    if (isMobile) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCard(
            width: availableWidth,
            label: 'CURRENT TIME (IST)',
            value: timeText,
            icon: Icons.access_time_rounded,
            valueColor: AppColors.primary,
          ),
          const SizedBox(height: 14),
          _buildCard(
            width: availableWidth,
            label: "TODAY'S DATE",
            value: dateText,
            icon: Icons.calendar_today_rounded,
            valueColor: const Color(0xFF3478F6),
          ),
          const SizedBox(height: 14),
          _buildCard(
            width: availableWidth,
            label: 'WORKING DAY',
            value: 'Day $workingDay of $totalWorkingDays',
            icon: Icons.work_history_rounded,
            valueColor: const Color(0xFFFF9200),
          ),
          const SizedBox(height: 14),
          _buildCard(
            width: availableWidth,
            label: 'FINANCIAL MONTH',
            value: monthText,
            icon: Icons.account_balance_wallet_rounded,
            valueColor: AppColors.primary,
          ),
        ],
      );
    }

    if (isTablet) {
      final double cardWidth = (availableWidth - 16) / 2;

      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          _buildCard(
            width: cardWidth,
            label: 'CURRENT TIME (IST)',
            value: timeText,
            icon: Icons.access_time_rounded,
            valueColor: AppColors.primary,
          ),
          _buildCard(
            width: cardWidth,
            label: "TODAY'S DATE",
            value: dateText,
            icon: Icons.calendar_today_rounded,
            valueColor: const Color(0xFF3478F6),
          ),
          _buildCard(
            width: cardWidth,
            label: 'WORKING DAY',
            value: 'Day $workingDay of $totalWorkingDays',
            icon: Icons.work_history_rounded,
            valueColor: const Color(0xFFFF9200),
          ),
          _buildCard(
            width: cardWidth,
            label: 'FINANCIAL MONTH',
            value: monthText,
            icon: Icons.account_balance_wallet_rounded,
            valueColor: AppColors.primary,
          ),
        ],
      );
    }

    // -------------------------------------------------------------------------
    // DESKTOP
    // -------------------------------------------------------------------------

    final double cardWidth = (availableWidth - 54) / 4;

    return Wrap(
      spacing: 18,
      runSpacing: 18,
      children: [
        _buildCard(
          width: cardWidth,
          label: 'CURRENT TIME (IST)',
          value: timeText,
          icon: Icons.access_time_rounded,
          valueColor: AppColors.primary,
        ),
        _buildCard(
          width: cardWidth,
          label: "TODAY'S DATE",
          value: dateText,
          icon: Icons.calendar_today_rounded,
          valueColor: const Color(0xFF3478F6),
        ),
        _buildCard(
          width: cardWidth,
          label: 'WORKING DAY',
          value: 'Day $workingDay of $totalWorkingDays',
          icon: Icons.work_history_rounded,
          valueColor: const Color(0xFFFF9200),
        ),
        _buildCard(
          width: cardWidth,
          label: 'FINANCIAL MONTH',
          value: monthText,
          icon: Icons.account_balance_wallet_rounded,
          valueColor: AppColors.primary,
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // CARD
  // ---------------------------------------------------------------------------

  Widget _buildCard({
    required double width,
    required String label,
    required String value,
    required IconData icon,
    required Color valueColor,
  }) {
    // Completely responsive card sizing.
    final double cardHeight = width < 350
        ? 125
        : width < 500
        ? 135
        : width < 750
        ? 145
        : 150;

    final double horizontalPadding = width < 350 ? 16 : 20;

    final double iconSize = width < 350 ? 32 : 36;

    final double valueFontSize = width < 350
        ? 21
        : width < 500
        ? 23
        : 26;

    return SizedBox(
      width: width,
      height: cardHeight,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 18,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFE7EDF3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.025),
              blurRadius: 18,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOP
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: iconSize,
                  height: iconSize,
                  decoration: BoxDecoration(
                    color: valueColor.withValues(alpha: 0.09),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: width < 350 ? 16 : 18,
                    color: valueColor,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: width < 350 ? 9.5 : 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.25,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // VALUE
            Expanded(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    value,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: valueFontSize,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                      color: valueColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}