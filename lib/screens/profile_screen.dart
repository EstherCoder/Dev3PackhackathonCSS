import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/neu_widgets.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsOn = true;
  bool _locationSharing = true;
  bool _anonymousMode   = false;

  // Mock data — replace with real Supabase user data
  static const _userName  = "Alex Mwanza";
  static const _userEmail = "a.mwanza@campus.edu";
  static const _userRole  = "Student — Year 3";
  static const _sosCount  = 2;
  static const _reportsCount = 5;
  static const _safePoints   = 340;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
      child: Column(
        children: [
          const SizedBox(height: 12),

          // ── Profile hero ─────────────────────────────────────────────────
          NeuCard(
            padding: const EdgeInsets.all(24),
            glowColor: AppTheme.primaryColor.withOpacity(0.3) != Colors.transparent
                ? null
                : null,
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [AppTheme.primaryColor, AppTheme.accentColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          ...AppTheme.raise(intensity: 1.1),
                          ...AppTheme.glow(intensity: 0.7),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _initials(_userName),
                          style: GoogleFonts.poppins(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.bgBase,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: AppTheme.successColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.bgRaised, width: 2),
                        ),
                        child: const Icon(Icons.check_rounded,
                            color: AppTheme.bgBase, size: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(_userName,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    )),
                const SizedBox(height: 2),
                Text(_userEmail,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    )),
                const SizedBox(height: 4),
                NeuBadge(
                  label: _userRole,
                  color: AppTheme.primaryColor,
                  icon: Icons.school_outlined,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Stats row ────────────────────────────────────────────────────
          Row(children: [
            Expanded(
              child: _StatCard(
                  label: "SOS Sent",
                  value: "$_sosCount",
                  icon: Icons.sos_rounded,
                  color: AppTheme.dangerColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                  label: "Reports",
                  value: "$_reportsCount",
                  icon: Icons.flag_outlined,
                  color: AppTheme.warningColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                  label: "Safe Pts",
                  value: "$_safePoints",
                  icon: Icons.star_outline_rounded,
                  color: AppTheme.primaryColor),
            ),
          ]),

          const SizedBox(height: 20),

          // ── Emergency contacts ───────────────────────────────────────────
          _SectionHeader(
              title: "Emergency Contacts",
              action: "Add",
              onAction: () {}),
          const SizedBox(height: 10),
          _ContactTile(
              name: "Mum", phone: "+260 97 123 4567",
              relation: "Family", color: AppTheme.successColor),
          const SizedBox(height: 8),
          _ContactTile(
              name: "Dr. Banda", phone: "+260 96 987 6543",
              relation: "Campus Doctor", color: AppTheme.warningColor),
          const SizedBox(height: 8),
          _ContactTile(
              name: "Security Desk", phone: "+260 21 123 0000",
              relation: "Campus Security", color: AppTheme.dangerColor),

          const SizedBox(height: 20),

          // ── Settings ─────────────────────────────────────────────────────
          _SectionHeader(title: "Settings"),
          const SizedBox(height: 10),
          NeuCard(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              children: [
                _ToggleTile(
                  icon: Icons.notifications_outlined,
                  label: "Push Notifications",
                  value: _notificationsOn,
                  onChanged: (v) => setState(() => _notificationsOn = v),
                ),
                _divider(),
                _ToggleTile(
                  icon: Icons.location_on_outlined,
                  label: "Live Location Sharing",
                  value: _locationSharing,
                  onChanged: (v) => setState(() => _locationSharing = v),
                ),
                _divider(),
                _ToggleTile(
                  icon: Icons.visibility_off_outlined,
                  label: "Anonymous Mode",
                  value: _anonymousMode,
                  onChanged: (v) => setState(() => _anonymousMode = v),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          NeuCard(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              children: [
                _ActionTile(
                    icon: Icons.help_outline_rounded,
                    label: "Help & Support",
                    onTap: () {}),
                _divider(),
                _ActionTile(
                    icon: Icons.privacy_tip_outlined,
                    label: "Privacy Policy",
                    onTap: () {}),
                _divider(),
                _ActionTile(
                    icon: Icons.info_outline_rounded,
                    label: "About Campus Shield",
                    onTap: () {}),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Logout button
          NeuButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: AppTheme.dangerColor,
            radius: 14,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.logout_rounded,
                    color: Colors.white, size: 18),
                const SizedBox(width: 10),
                Text(
                  "LOG  OUT",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Divider(
      height: 1, thickness: 1, color: AppTheme.shadowLight.withOpacity(0.25));

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return "${parts[0][0]}${parts[1][0]}".toUpperCase();
    return name.substring(0, 2).toUpperCase();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.action, this.onAction});
  final String   title;
  final String?  action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            )),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Text(action!,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryColor,
                )),
          ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
  final String   label;
  final String   value;
  final IconData icon;
  final Color    color;

  @override
  Widget build(BuildContext context) {
    return NeuCard(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(value,
              style: GoogleFonts.orbitron(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              )),
          const SizedBox(height: 4),
          Text(label,
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: AppTheme.textSecondary,
              )),
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.name,
    required this.phone,
    required this.relation,
    required this.color,
  });
  final String name;
  final String phone;
  final String relation;
  final Color  color;

  @override
  Widget build(BuildContext context) {
    return NeuCard(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                name[0],
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    )),
                Text(relation,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    )),
              ],
            ),
          ),
          Row(
            children: [
              NeuIconButton(
                icon: Icons.call_outlined,
                onPressed: () {},
                size: 36,
                iconColor: AppTheme.successColor,
              ),
              const SizedBox(width: 8),
              NeuIconButton(
                icon: Icons.message_outlined,
                onPressed: () {},
                size: 36,
                iconColor: AppTheme.primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });
  final IconData   icon;
  final String     label;
  final bool       value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.textSecondary, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppTheme.textPrimary,
                )),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primaryColor,
            inactiveThumbColor: AppTheme.textSecondary,
            inactiveTrackColor: AppTheme.bgSunken,
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData   icon;
  final String     label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.textSecondary, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppTheme.textPrimary,
                  )),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppTheme.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}