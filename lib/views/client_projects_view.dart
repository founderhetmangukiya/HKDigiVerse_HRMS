import 'package:flutter/material.dart';

import '../components/app_colors.dart';

class ClientProjectsView extends StatelessWidget {
  const ClientProjectsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ClientProjectsComingSoon();
  }
}

class _ClientProjectsComingSoon extends StatelessWidget {
  const _ClientProjectsComingSoon();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;

        final bool isMobile = width < 600;
        final bool isTablet = width >= 600 && width < 1000;

        final double horizontalPadding = isMobile
            ? 16
            : isTablet
            ? 24
            : 32;

        final double titleSize = isMobile
            ? 26
            : isTablet
            ? 30
            : 34;

        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              isMobile ? 20 : 28,
              horizontalPadding,
              30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ------------------------------------------------------------
                // HEADER
                // ------------------------------------------------------------

                Text(
                  'Client & Projects',
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
                  'Manage clients and track your active projects.',
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

                SizedBox(
                  height: isMobile ? 20 : 28,
                ),

                // ------------------------------------------------------------
                // COMING SOON CARD
                // ------------------------------------------------------------

                Container(
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
                            // ------------------------------------------------
                            // ICON
                            // ------------------------------------------------

                            Container(
                              width: isMobile ? 90 : 104,
                              height: isMobile ? 90 : 104,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(
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
                                    color:
                                    AppColors.primary.withValues(
                                      alpha: 0.15,
                                    ),
                                  ),
                                ),
                                child: Icon(
                                  Icons.folder_outlined,
                                  size: isMobile ? 38 : 44,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // ------------------------------------------------
                            // STATUS
                            // ------------------------------------------------

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(
                                  alpha: 0.09,
                                ),
                                borderRadius:
                                BorderRadius.circular(30),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.auto_awesome_rounded,
                                    size: 16,
                                    color: AppColors.primary,
                                  ),
                                  SizedBox(width: 7),
                                  Text(
                                    'Coming Soon',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 18),

                            // ------------------------------------------------
                            // TITLE
                            // ------------------------------------------------

                            Text(
                              'Client & Projects',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: isMobile ? 22 : 26,
                                fontWeight: FontWeight.w800,
                                color: AppColors.navy,
                              ),
                            ),

                            const SizedBox(height: 10),

                            // ------------------------------------------------
                            // DESCRIPTION
                            // ------------------------------------------------

                            Text(
                              'We are building a centralized workspace to manage clients, projects, progress, and business relationships efficiently.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: isMobile ? 13 : 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textSecondary,
                                height: 1.65,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              'This feature is currently under development. We are working to bring it to you soon.',
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

                            // ------------------------------------------------
                            // WORKING INDICATOR
                            // ------------------------------------------------

                            const _WorkingIndicator(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// =============================================================================
// WORKING INDICATOR
// =============================================================================

class _WorkingIndicator extends StatefulWidget {
  const _WorkingIndicator();

  @override
  State<_WorkingIndicator> createState() =>
      _WorkingIndicatorState();
}

class _WorkingIndicatorState extends State<_WorkingIndicator> {
  int activeDot = 0;

  @override
  void initState() {
    super.initState();

    Future.doWhile(() async {
      await Future.delayed(
        const Duration(milliseconds: 450),
      );

      if (!mounted) {
        return false;
      }

      setState(() {
        activeDot = (activeDot + 1) % 3;
      });

      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
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
            final bool active = index == activeDot;

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
                    ? AppColors.primary
                    : AppColors.primary.withValues(
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