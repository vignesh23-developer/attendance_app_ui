import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../controller/home_controller.dart';
import '../../data/const/color_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _Header(ctrl: ctrl)),

          SliverToBoxAdapter(child: _ClockCard(ctrl: ctrl)),

          SliverToBoxAdapter(child: _PunchSection(ctrl: ctrl)),

          SliverToBoxAdapter(child: _StatsRow(ctrl: ctrl)),

          const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.ctrl});
  final HomeController ctrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.sp, 30.sp, 20.sp, 15.sp),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.white.withOpacity(0.5),
                    width: 2,
                  ),
                  color: AppColors.white.withOpacity(0.2),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: AppColors.white,
                  size: 26,
                ),
              ),
              SizedBox(width: 12.sp),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(text:
                      'Good Morning 👋',
                      fontSize: 14.sp,
                      color: AppColors.white.withOpacity(0.8),
                    ),
                    CommonText(text:
                      'Vigneshwaran',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ClockCard extends StatelessWidget {
  const _ClockCard({required this.ctrl});
  final HomeController ctrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.sp, 24.sp, 20.sp, 8.sp),
            child: Column(
              children: [
                Obx(() => CommonText(text:
                  ctrl.currentTime.value,
                  fontSize: 42,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                )),
                SizedBox(height: 4.sp),
                Obx(() => CommonText(text:
                  ctrl.currentDate.value,
                  fontSize: 14,
                  color: AppColors.textSecond,
                )),
              ],
            ),
          ),

          Divider(
            color: AppColors.border,
            height: 1,
            indent: 20.sp,
            endIndent: 20.sp,
          ),

          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 20.sp, vertical: 12.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _InfoChip(
                  icon: Icons.badge_outlined,
                  label: 'MZ001234',
                ),
                _InfoChip(
                  icon: Icons.business_outlined,
                  label: 'Engineering',
                ),
                Obx(() => _InfoChip(
                  icon: Icons.location_on_outlined,
                  label: ctrl.currentLocation.value,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.grey),
        const SizedBox(width: 4),
        CommonText(
          text: label,
          fontSize: 12,
          color: AppColors.greyDark,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _PunchSection extends StatelessWidget {
  const _PunchSection({required this.ctrl});
  final HomeController ctrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.sp),
      child: CommonCard(
        child: Column(
          children: [
            CommonText(text:
              'Tap to Punch',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            SizedBox(height: 4.sp),
            Obx(() => CommonText(text:
              ctrl.isCheckedIn.value
                  ? 'Working • ${ctrl.elapsedTime.value}'
                  : 'Not checked in yet',
              fontSize: 13,
              color: ctrl.isCheckedIn.value
                  ? AppColors.success
                  : AppColors.grey,
            )),

            SizedBox(height: 24.sp),


            _AnimatedPunchButton(ctrl: ctrl),

            SizedBox(height: 20.sp),


            Obx(() => ctrl.halfDayReached.value
                ? _HalfDayNotice()
                : const SizedBox.shrink()),

            // _WorkProgress(value: ctrl.progressPercent.value),
          ],
        ),
      ),
    );
  }
}

class _AnimatedPunchButton extends StatelessWidget {
  const _AnimatedPunchButton({required this.ctrl});

  final HomeController ctrl;

  @override
  Widget build(BuildContext context) {

    return Obx(() {

      final isIn = ctrl.isCheckedIn.value;

      return GestureDetector(

        onTap: ctrl.isLoading.value
            ? null
            : ctrl.onPunchTap,

        child: AnimatedBuilder(

          animation: ctrl.pulseAnim,

          builder: (_, child) => Transform.scale(
            scale: isIn
                ? ctrl.pulseAnim.value
                : 1.0,
            child: child,
          ),

          child: SizedBox(

            width: 160,
            height: 160,

            child: CustomPaint(

              painter: _RingPainter(
                progress: ctrl.progressPercent.value,
                isCheckedIn: isIn,
              ),

              child: Center(

                child: Container(

                  width: 120,
                  height: 120,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    gradient: LinearGradient(
                      colors: isIn
                          ? [
                        AppColors.success,
                        const Color(0xFF22C55E),
                      ]
                          : [
                        AppColors.primary,
                        AppColors.secondary,
                      ],
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: (isIn
                            ? AppColors.success
                            : AppColors.primary)
                            .withOpacity(0.35),

                        blurRadius: 24,
                        spreadRadius: 2,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),

                  child: ctrl.isLoading.value

                      ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 2.5,
                    ),
                  )

                      : Column(

                    mainAxisAlignment:
                    MainAxisAlignment.center,

                    children: [

                      Icon(
                        isIn
                            ? Icons.logout_rounded
                            : Icons.fingerprint_rounded,

                        color: AppColors.white,
                        size: 36,
                      ),

                      const SizedBox(height: 6),

                      CommonText(
                        text: isIn
                            ? 'CHECK OUT'
                            : 'CHECK IN',

                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.progress, required this.isCheckedIn});
  final double progress;
  final bool isCheckedIn;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    const strokeWidth = 6.0;

    // Background ring
    final bgPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    if (progress > 0) {
      final paint = Paint()
        ..color = isCheckedIn
            ? const Color(0xFF22C55E)
            : const Color(0xFFF59E0B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.isCheckedIn != isCheckedIn;
}

// class _WorkProgress extends StatelessWidget {
//   const _WorkProgress({required this.value});
//   final double value;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             CommonText(text:'Work Progress', fontSize: 12, color: AppColors.grey),
//             CommonText(text:
//               '${(value * 100).toInt()}% of 8h',
//               fontSize: 12,
//               color: AppColors.primary,
//               fontWeight: FontWeight.w600,
//             ),
//           ],
//         ),
//         const SizedBox(height: 6),
//         ClipRRect(
//           borderRadius: BorderRadius.circular(8),
//           child: LinearProgressIndicator(
//             value: value,
//             minHeight: 6,
//             backgroundColor: AppColors.greyLight,
//             valueColor: AlwaysStoppedAnimation<Color>(
//               value >= 1.0 ? AppColors.success : AppColors.primary,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

class _HalfDayNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.halfBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.circle, color: AppColors.warning, size: 8),
          const SizedBox(width: 6),
          CommonText(text:
            'Minimum half-day time reached',
            fontSize: 12,
            color: AppColors.halfFg,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.ctrl});
  final HomeController ctrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.sp, 16.sp, 16.sp, 0),
      child: Obx(() => Row(
        children: [
          Expanded(
            child: _StatCard(
              label: 'Check In',
              value: ctrl.checkInTime.value.isEmpty
                  ? '--:--'
                  : ctrl.checkInTime.value,
              icon: Icons.login_rounded,
              iconColor: AppColors.success,
              iconBg: AppColors.presentBg,
            ),
          ),
          SizedBox(width: 10.sp),
          Expanded(
            child: _StatCard(
              label: 'Punch Out',
              value: ctrl.checkOutTime.value.isEmpty
                  ? '--:--'
                  : ctrl.checkOutTime.value,
              icon: Icons.logout_rounded,
              iconColor: AppColors.danger,
              iconBg: AppColors.absentBg,
            ),
          ),
          SizedBox(width: 10.sp),
          Expanded(
            child: _StatCard(
              label: 'Total Hours',
              value: ctrl.elapsedTime.value == '00:00:00'
                  ? '--:--'
                  : ctrl.elapsedTime.value.substring(0, 5),
              icon: Icons.access_time_rounded,
              iconColor: AppColors.primary,
              iconBg: AppColors.primary.withOpacity(0.1),
            ),
          ),
        ],
      )),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      padding: EdgeInsets.all(12.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          SizedBox(height: 10.sp),
          CommonText(
            text:value,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          SizedBox(height: 2.sp),
          CommonText(text:label, fontSize: 11, color: AppColors.grey),
        ],
      ),
    );
  }
}
