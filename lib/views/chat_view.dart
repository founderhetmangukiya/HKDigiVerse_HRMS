import 'dart:async';

import 'package:flutter/material.dart';

import '../components/app_colors.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeatureStatusPage(
      title: 'Chat',
      subtitle: 'Connect with your team and communicate easily.',
      icon: Icons.chat_bubble_outline_rounded,
      status: FeatureStatus.comingSoon,
      featureName: 'Team Chat',
      message:
      'We are building a better way for your team to communicate, collaborate, and stay connected.',
    );
  }
}

// =============================================================================
// FEATURE STATUS
// =============================================================================

enum FeatureStatus {
  comingSoon,
  underMaintenance,
}

// =============================================================================
// REUSABLE FEATURE STATUS PAGE
// =============================================================================

class FeatureStatusPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final FeatureStatus status;
  final String featureName;
  final String message;

  const FeatureStatusPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.status,
    required this.featureName,
    required this.message,
  });

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
              isMobile ? 24 : 32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(
                  isMobile: isMobile,
                  isTablet: isTablet,
                ),

                SizedBox(
                  height: isMobile ? 20 : 28,
                ),

                _buildStatusCard(
                  width: width,
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
    final double titleSize = isMobile
        ? 26
        : isTablet
        ? 30
        : 34;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: titleSize,
            fontWeight: FontWeight.w800,
            color: AppColors.navy,
            height: 1.2,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: isMobile ? 12.5 : 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // STATUS CARD
  // ===========================================================================

  Widget _buildStatusCard({
    required double width,
    required bool isMobile,
    required bool isTablet,
  }) {
    final bool isMaintenance =
        status == FeatureStatus.underMaintenance;

    final Color statusColor = isMaintenance
        ? const Color(0xFFFF9F1C)
        : AppColors.primary;

    final IconData statusIcon = isMaintenance
        ? Icons.build_circle_outlined
        : Icons.auto_awesome_rounded;

    final String statusTitle = isMaintenance
        ? 'Under Maintenance'
        : 'Coming Soon';

    final String statusDescription = isMaintenance
        ? 'We are currently working on improvements to this feature.'
        : 'This feature is currently under development. We are working to bring it to you soon.';

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: isMobile ? 420 : 460,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          isMobile ? 18 : 22,
        ),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.025,
            ),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(
          isMobile
              ? 24
              : isTablet
              ? 36
              : 48,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _AnimatedStatusIcon(
                  icon: icon,
                  color: statusColor,
                  isMaintenance: isMaintenance,
                ),

                const SizedBox(height: 24),

                // STATUS BADGE
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(
                      alpha: 0.09,
                    ),
                    borderRadius:
                    BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        statusIcon,
                        size: 16,
                        color: statusColor,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        statusTitle,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // FEATURE NAME
                Text(
                  featureName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: isMobile ? 22 : 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navy,
                  ),
                ),

                const SizedBox(height: 10),

                // MAIN MESSAGE
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: isMobile ? 13 : 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                    height: 1.65,
                  ),
                ),

                const SizedBox(height: 8),

                // SECONDARY MESSAGE
                Text(
                  statusDescription,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: isMobile ? 12 : 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textLight,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 26),

                // WORKING INDICATOR
                _WorkingIndicator(
                  color: statusColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// ANIMATED ICON
// =============================================================================

class _AnimatedStatusIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final bool isMaintenance;

  const _AnimatedStatusIcon({
    required this.icon,
    required this.color,
    required this.isMaintenance,
  });

  @override
  State<_AnimatedStatusIcon> createState() =>
      _AnimatedStatusIconState();
}

class _AnimatedStatusIconState
    extends State<_AnimatedStatusIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1800,
      ),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.96,
      end: 1.04,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: widget.color.withValues(
            alpha: 0.08,
          ),
          shape: BoxShape.circle,
        ),
        child: Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: widget.color.withValues(
                alpha: 0.15,
              ),
              width: 1,
            ),
          ),
          child: Icon(
            widget.icon,
            size: 40,
            color: widget.color,
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// WORKING INDICATOR
// =============================================================================

class _WorkingIndicator extends StatefulWidget {
  final Color color;

  const _WorkingIndicator({
    required this.color,
  });

  @override
  State<_WorkingIndicator> createState() =>
      _WorkingIndicatorState();
}

class _WorkingIndicatorState
    extends State<_WorkingIndicator> {
  Timer? _timer;

  int _activeDot = 0;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
      const Duration(milliseconds: 450),
          (_) {
        if (!mounted) return;

        setState(() {
          _activeDot = (_activeDot + 1) % 3;
        });
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'We are working',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),

        const SizedBox(width: 7),

        ...List.generate(
          3,
              (index) {
            final bool active =
                index == _activeDot;

            return AnimatedContainer(
              duration: const Duration(
                milliseconds: 250,
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: 2,
              ),
              width: active ? 7 : 5,
              height: active ? 7 : 5,
              decoration: BoxDecoration(
                color: active
                    ? widget.color
                    : widget.color.withValues(
                  alpha: 0.25,
                ),
                shape: BoxShape.circle,
              ),
            );
          },
        ),
      ],
    );
  }
}