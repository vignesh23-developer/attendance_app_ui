import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../data/const/color_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CommonAppBar(
        backgroundColor: AppColors.primary,
        title: 'My Profile',
        titleColor: AppColors.white,
        showBack: false,

        actions: [

          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton.icon(

              onPressed: () => _showLogoutDialog(),

              style: TextButton.styleFrom(

                backgroundColor: AppColors.white,

                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),

                  side: const BorderSide(
                    color: AppColors.danger,
                    width: 1,
                  ),
                ),
              ),

              icon: const Icon(
                Icons.power_settings_new_rounded,
                color: AppColors.danger,
                size: 18,
              ),

              label: CommonText(
                text: 'Logout',
                fontSize: 13,
                color: AppColors.danger,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Hero header ────────────────────────────────
            _ProfileHeader(),

            // ── Info cards ─────────────────────────────────
            _SectionTitle('Personal Information',"Edit"),
            _InfoCard(),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const CommonText(
          text:
          'Logout',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        content: const CommonText(
          text:
          'Are you sure you want to logout?',
          fontSize: 15,
          color: AppColors.textSecond,
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const CommonText( text: 'Cancel', fontSize: 14,
                color: AppColors.grey),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // Handle logout
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const CommonText( text: 'Logout', fontSize: 14,
                color: AppColors.white, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════
// Profile Header
// ══════════════════════════════════════════════
class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.sp, 15.sp, 20.sp, 15.sp),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white.withOpacity(0.2),
                  border: Border.all(
                    color: AppColors.white.withOpacity(0.5),
                    width: 2.5,
                  ),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: AppColors.white,
                  size: 48,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppColors.primary.withOpacity(0.2), width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: AppColors.primary,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.sp),
          CommonText(
            text:
            'John Doe',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
          SizedBox(height: 4.sp),
          CommonText(
            text:
            'Senior Software Engineer',
            fontSize: 13,
            color: AppColors.white.withOpacity(0.8),
          ),
          SizedBox(height: 14.sp),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _HeaderChip(label: 'TX001'),
              SizedBox(width: 10.sp),
              _HeaderChip(label: 'Senior Developer'),
              SizedBox(width: 10.sp),
              _HeaderChip(label: 'Full-Time'),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderChip extends StatelessWidget {
  const _HeaderChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: CommonText(
        text:
        label,
        fontSize: 11,
        color: AppColors.white,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title,this.subtitle);
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.sp, 20.sp, 20.sp, 8.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommonText(
            text:
            title,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.grey,
            // letterSpacing: 0.5,
          ),
          GestureDetector(
            onTap: (){},
            child: CommonText(
              text:
              subtitle,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.grey,
              // letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════
// Info Card
// ══════════════════════════════════════════════
class _InfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CommonCard(
      margin: EdgeInsets.symmetric(horizontal: 16.sp),
      child: Column(
        children: [
          _InfoRow(icon: Icons.badge_outlined,
              label: 'Employee ID', value: 'TX001'),
          _RowDivider(),
          _InfoRow(icon: Icons.business_outlined,
              label: 'Department', value: 'Senior Developer'),
          _RowDivider(),
          _InfoRow(icon: Icons.email_outlined,
              label: 'Email', value: 'Texa@company.com'),
          _RowDivider(),
          _InfoRow(icon: Icons.phone_outlined,
              label: 'Phone', value: '+91 98765 43210'),
          _RowDivider(),
          _InfoRow(icon: Icons.location_on_outlined,
              label: 'Location', value: 'Coimbatore, TN'),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.sp),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
          SizedBox(width: 14.sp),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText( text: label, fontSize: 12, color: AppColors.grey),
                SizedBox(height: 2.sp),
                CommonText(
                  text:
                  value,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, color: AppColors.border);
}
