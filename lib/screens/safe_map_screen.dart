import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/neu_widgets.dart';

/// Safe Map Screen
/// ─────────────────────────────────────────────────────────────────────────
/// Replace the placeholder map widget with your actual map plugin
/// (google_maps_flutter, flutter_map, etc.) when ready.
/// The incident data shown below is mock data — wire it up to Supabase.
class SafeMapScreen extends StatefulWidget {
  const SafeMapScreen({super.key});

  @override
  State<SafeMapScreen> createState() => _SafeMapScreenState();
}

class _SafeMapScreenState extends State<SafeMapScreen>
    with SingleTickerProviderStateMixin {
  String _selectedFilter = "All";
  final _filters = ["All", "SOS", "Medical", "Security", "Resolved"];

  // Mock incident data — replace with real Supabase query
  final _incidents = const [
    _Incident(
      type: "SOS",
      title: "SOS Alert",
      location: "Block C Parking Lot",
      time: "12 min ago",
      lat: -15.4166,
      lng: 28.2833,
      color: AppTheme.dangerColor,
      icon: Icons.sos_rounded,
    ),
    _Incident(
      type: "Medical",
      title: "Medical Emergency",
      location: "Library — Floor 2",
      time: "1 hr ago",
      lat: -15.4170,
      lng: 28.2840,
      color: AppTheme.warningColor,
      icon: Icons.local_hospital_outlined,
    ),
    _Incident(
      type: "Security",
      title: "Suspicious Activity",
      location: "Main Gate",
      time: "2 hr ago",
      lat: -15.4162,
      lng: 28.2828,
      color: AppTheme.accentColor,
      icon: Icons.security_outlined,
    ),
    _Incident(
      type: "Resolved",
      title: "All Clear",
      location: "Admin Block",
      time: "3 hr ago",
      lat: -15.4175,
      lng: 28.2845,
      color: AppTheme.successColor,
      icon: Icons.check_circle_outline_rounded,
    ),
  ];

  List<_Incident> get _filtered => _selectedFilter == "All"
      ? _incidents
      : _incidents.where((i) => i.type == _selectedFilter).toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter chips
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
          child: SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final selected = _filters[i] == _selectedFilter;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = _filters[i]),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppTheme.primaryColor
                          : AppTheme.bgRaised,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: selected ? AppTheme.glow() : AppTheme.raise(),
                    ),
                    child: Text(
                      _filters[i],
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? AppTheme.bgBase
                            : AppTheme.textSecondary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // Map area
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: NeuCard(
              padding: EdgeInsets.zero,
              radius: 20,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // ── Replace this Container with your real map widget ──
                    _MapPlaceholder(incidents: _filtered),
                    // ─────────────────────────────────────────────────────

                    // Legend overlay
                    Positioned(
                      top: 12,
                      right: 12,
                      child: NeuCard(
                        padding: const EdgeInsets.all(12),
                        radius: 14,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _LegendItem(AppTheme.dangerColor, "SOS"),
                            const SizedBox(height: 6),
                            _LegendItem(AppTheme.warningColor, "Medical"),
                            const SizedBox(height: 6),
                            _LegendItem(AppTheme.accentColor, "Security"),
                            const SizedBox(height: 6),
                            _LegendItem(AppTheme.successColor, "Resolved"),
                          ],
                        ),
                      ),
                    ),

                    // My location button
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: NeuIconButton(
                        icon: Icons.my_location_rounded,
                        onPressed: () {},
                        size: 46,
                        iconColor: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Incident list
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Nearby Incidents",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    NeuBadge(
                      label: "${_filtered.length} active",
                      color: AppTheme.dangerColor,
                      icon: Icons.circle,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: _filtered.isEmpty
                      ? Center(
                          child: Text(
                            "No incidents for this filter.",
                            style: GoogleFonts.poppins(
                                color: AppTheme.textSecondary),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.only(bottom: 100),
                          itemCount: _filtered.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (_, i) =>
                              _IncidentListTile(incident: _filtered[i]),
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Map placeholder — swap this out for google_maps_flutter / flutter_map
// ─────────────────────────────────────────────────────────────────────────────
class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder({required this.incidents});
  final List<_Incident> incidents;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFF0D1326),
      child: CustomPaint(
        painter: _GridPainter(),
        child: Stack(
          children: [
            // Campus outline (decorative)
            Center(
              child: Opacity(
                opacity: 0.15,
                child: Container(
                  width: 220,
                  height: 180,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: AppTheme.primaryColor, width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      "CAMPUS",
                      style: GoogleFonts.orbitron(
                        fontSize: 14,
                        color: AppTheme.primaryColor,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Incident pins
            ...incidents.asMap().entries.map((e) {
              final inc = e.value;
              final offsets = [
                const Offset(0.3, 0.35),
                const Offset(0.6, 0.55),
                const Offset(0.45, 0.65),
                const Offset(0.65, 0.3),
              ];
              final off = offsets[e.key % offsets.length];
              return Positioned.fill(
                child: FractionallySizedBox(
                  alignment: FractionalOffset(off.dx, off.dy),
                  widthFactor: 0.0,
                  heightFactor: 0.0,
                  child: _MapPin(color: inc.color, icon: inc.icon),
                ),
              );
            }),

            // "Map coming soon" label
            Positioned(
              bottom: 12,
              left: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.bgRaised.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Plug in your map SDK here",
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: AppTheme.textSecondary,
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

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryColor.withOpacity(0.05)
      ..strokeWidth = 1;
    const step = 32.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _MapPin extends StatelessWidget {
  const _MapPin({required this.color, required this.icon});
  final Color   color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: color.withOpacity(0.5), blurRadius: 12, spreadRadius: 2)
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        CustomPaint(
          size: const Size(10, 8),
          painter: _PinTailPainter(color: color),
        ),
      ],
    );
  }
}

class _PinTailPainter extends CustomPainter {
  const _PinTailPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _LegendItem extends StatelessWidget {
  const _LegendItem(this.color, this.label);
  final Color  color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 10, height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 11, color: AppTheme.textSecondary)),
      ],
    );
  }
}

class _IncidentListTile extends StatelessWidget {
  const _IncidentListTile({required this.incident});
  final _Incident incident;

  @override
  Widget build(BuildContext context) {
    return NeuCard(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: incident.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(incident.icon, color: incident.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(incident.title,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    )),
                Text(incident.location,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    )),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(incident.time,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: AppTheme.textSecondary,
                  )),
              const SizedBox(height: 4),
              NeuBadge(label: incident.type, color: incident.color),
            ],
          ),
        ],
      ),
    );
  }
}

class _Incident {
  const _Incident({
    required this.type,
    required this.title,
    required this.location,
    required this.time,
    required this.lat,
    required this.lng,
    required this.color,
    required this.icon,
  });

  final String   type;
  final String   title;
  final String   location;
  final String   time;
  final double   lat;
  final double   lng;
  final Color    color;
  final IconData icon;
}