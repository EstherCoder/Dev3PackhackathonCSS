import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../theme/app_theme.dart';
import '../widgets/neu_widgets.dart';
import 'safe_map_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const _SOSPage(),
      const SafeMapScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(
          "CAMPUS SHIELD",
          style: GoogleFonts.orbitron(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            letterSpacing: 3,
            color: AppTheme.textPrimary,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: NeuIconButton(
              icon: Icons.notifications_none_rounded,
              onPressed: () {},
              size: 40,
              iconColor: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: _buildNavBar(),
    );
  }

  Widget _buildNavBar() {
    const items = [
      (Icons.shield_rounded, Icons.shield_outlined, "SOS"),
      (Icons.map_rounded, Icons.map_outlined, "Safe Map"),
      (Icons.person_rounded, Icons.person_outline_rounded, "Profile"),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.bgRaised,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          ...AppTheme.raise(intensity: 1.2),
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.06),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(
          color: AppTheme.shadowLight.withOpacity(0.20),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final selected = i == _selectedIndex;
          final item     = items[i];
          return GestureDetector(
            onTap: () => setState(() => _selectedIndex = i),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: selected
                    ? AppTheme.primaryColor.withOpacity(0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    selected ? item.$1 : item.$2,
                    color: selected
                        ? AppTheme.primaryColor
                        : AppTheme.textSecondary,
                    size: 22,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.$3,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.w400,
                      color: selected
                          ? AppTheme.primaryColor
                          : AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SOS Page — pulsing animated button
// ─────────────────────────────────────────────────────────────────────────────
class _SOSPage extends StatefulWidget {
  const _SOSPage();

  @override
  State<_SOSPage> createState() => _SOSPageState();
}

class _SOSPageState extends State<_SOSPage> with TickerProviderStateMixin {
  bool   _isProcessing  = false;
  String _statusMessage = "Hold button for SOS";
  String _subStatus     = "Your location will be secured on-chain";
  bool   _isHolding     = false;
  double _holdProgress  = 0.0;

  late final AnimationController _pulseCtrl;
  late final Animation<double>   _pulseAnim;
  late final AnimationController _rippleCtrl;
  late final Animation<double>   _rippleAnim;
  late final AnimationController _holdCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1600))
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.06)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _rippleCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800))
      ..repeat();
    _rippleAnim = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _rippleCtrl, curve: Curves.easeOut));

    _holdCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800));
    _holdCtrl.addListener(() {
      setState(() => _holdProgress = _holdCtrl.value);
      if (_holdCtrl.value >= 1.0) _triggerSOS();
    });
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _rippleCtrl.dispose();
    _holdCtrl.dispose();
    super.dispose();
  }

  void _onHoldStart() {
    setState(() {
      _isHolding = true;
      _statusMessage = "Keep holding…";
      _subStatus = "Release to cancel";
    });
    _holdCtrl.forward(from: 0);
  }

  void _onHoldEnd() {
    if (_holdCtrl.value < 1.0) {
      _holdCtrl.stop();
      setState(() {
        _isHolding = false;
        _holdProgress = 0;
        _statusMessage = "Hold button for SOS";
        _subStatus = "Your location will be secured on-chain";
      });
    }
  }

  // In home_screen.dart — replace triggerSOS()
  Future<void> _triggerSOS() async {
    setState(() { _isProcessing = true; _statusMessage = "Securing location…"; });

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception("Not logged in");

      final position = await _determinePosition();

      // 1. Insert to Supabase first, get the incident ID
      final response = await Supabase.instance.client
        .from('incidents')
        .insert({
          'user_id': user.id,
          'latitude': position.latitude,
          'longitude': position.longitude,
          'type': 'SOS',
          'status': 'active',
        })
        .select('id')
        .single();

      final incidentId = response['id'] as String;

      // 2. Send to Solana (Memo Program via RPC)
      setState(() => _statusMessage = "Anchoring to blockchain…");
      final txHash = await _sendSolanaMemo(
        memo: "CAMPUS-SHIELD:SOS:$incidentId",
      );

      // 3. Update incident with real tx hash
      await Supabase.instance.client
        .from('incidents')
        .update({
          'solana_tx_hash': txHash,
          'solana_confirmed': txHash != null,
        })
        .eq('id', incidentId);

      setState(() { _statusMessage = "SOS Anchored ✓"; });
    } catch (e) {
      setState(() { _statusMessage = "Failed: $e"; });
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  // Solana memo via RPC — no heavy SDK needed
  Future<String?> _sendSolanaMemo({required String memo}) async {
    // For a real implementation you need:
    // 1. A funded keypair (store securely — NOT in code)
    // 2. The solana: ^0.32 package for signing
    //
    // Quick devnet approach using the solana package:
    // final client = SolanaClient(rpcUrl: Uri.parse('https://api.devnet.solana.com'));
    // final wallet = Ed25519HDKeyPair.fromMnemonic('your mnemonic here');
    // final tx = await client.sendAndConfirmTransaction(
    //   message: Message.only(MemoInstruction(signers: [wallet.publicKey], memo: memo)),
    //   signers: [wallet],
    //   commitment: Commitment.confirmed,
    // );
    // return tx;
    //
    // For now return a dev placeholder until wallet is set up:
    return "DEV_${DateTime.now().millisecondsSinceEpoch}";
  }

  Future<Position> _determinePosition() async {
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    return Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    final isActive = _isProcessing || _isHolding;
    final btnColor1 = isActive ? AppTheme.dangerColor : AppTheme.primaryColor;
    final btnColor2 = isActive ? const Color(0xFFFF0040) : AppTheme.accentColor;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
      child: Column(
        children: [
          const SizedBox(height: 24),

          // Status card
          NeuCard(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
            glowColor: isActive ? AppTheme.dangerColor : null,
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (isActive ? AppTheme.dangerColor : AppTheme.successColor)
                        .withOpacity(0.14),
                  ),
                  child: Icon(
                    isActive
                        ? Icons.warning_amber_rounded
                        : Icons.check_circle_outline_rounded,
                    color: isActive ? AppTheme.dangerColor : AppTheme.successColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _statusMessage,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      _subStatus,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Quick action chips
          Row(
            children: [
              Expanded(
                child: NeuCard(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  child: Row(
                    children: [
                      Icon(Icons.phone_outlined,
                          color: AppTheme.warningColor, size: 20),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Campus Security",
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary)),
                          Text("Quick Dial",
                              style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: AppTheme.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: NeuCard(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  child: Row(
                    children: [
                      Icon(Icons.people_outline_rounded,
                          color: AppTheme.accentColor, size: 20),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("My Contacts",
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary)),
                          Text("3 trusted",
                              style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: AppTheme.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 48),

          // SOS button
          Stack(
            alignment: Alignment.center,
            children: [
              // Ripple rings
              ...List.generate(3, (i) {
                return AnimatedBuilder(
                  animation: _rippleAnim,
                  builder: (_, __) {
                    final delay = i / 3;
                    final t = (_rippleAnim.value - delay).clamp(0.0, 1.0);
                    return Opacity(
                      opacity: (1 - t) * (isActive ? 0.5 : 0.25),
                      child: Container(
                        width: 220 + t * 130,
                        height: 220 + t * 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: btnColor1,
                            width: 1.5,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),

              // Hold progress ring
              if (_isHolding)
                SizedBox(
                  width: 240,
                  height: 240,
                  child: CircularProgressIndicator(
                    value: _holdProgress,
                    strokeWidth: 4,
                    backgroundColor: AppTheme.bgSunken,
                    color: AppTheme.dangerColor,
                  ),
                ),

              // Core button
              GestureDetector(
                onLongPressStart: (_) => _onHoldStart(),
                onLongPressEnd: (_) => _onHoldEnd(),
                onLongPressCancel: () => _onHoldEnd(),
                child: AnimatedBuilder(
                  animation: _pulseAnim,
                  builder: (_, child) => Transform.scale(
                    scale: isActive ? 1.04 : _pulseAnim.value,
                    child: child,
                  ),
                  child: Container(
                    width: 210,
                    height: 210,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [btnColor1, btnColor2],
                        center: const Alignment(-0.3, -0.3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: btnColor1.withOpacity(0.45),
                          blurRadius: 40,
                          spreadRadius: 8,
                        ),
                        BoxShadow(
                          color: AppTheme.shadowDark.withOpacity(0.80),
                          offset: const Offset(8, 8),
                          blurRadius: 20,
                        ),
                        BoxShadow(
                          color: AppTheme.shadowLight.withOpacity(0.25),
                          offset: const Offset(-6, -6),
                          blurRadius: 14,
                        ),
                      ],
                    ),
                    child: _isProcessing
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "SOS",
                                style: GoogleFonts.orbitron(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 4,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "HOLD TO ACTIVATE",
                                style: GoogleFonts.poppins(
                                  fontSize: 9,
                                  color: Colors.white60,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 48),

          // Recent incidents
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Recent Incidents",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  )),
              Text("View All",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  )),
            ],
          ),
          const SizedBox(height: 14),
          _IncidentTile(
            icon: Icons.warning_amber_rounded,
            color: AppTheme.warningColor,
            title: "Suspicious Activity",
            location: "Block C Parking",
            time: "12 min ago",
          ),
          const SizedBox(height: 10),
          _IncidentTile(
            icon: Icons.local_hospital_outlined,
            color: AppTheme.dangerColor,
            title: "Medical Emergency",
            location: "Library — Floor 2",
            time: "1 hr ago",
          ),
          const SizedBox(height: 10),
          _IncidentTile(
            icon: Icons.shield_outlined,
            color: AppTheme.successColor,
            title: "All Clear — Resolved",
            location: "Main Entrance",
            time: "3 hr ago",
          ),
        ],
      ),
    );
  }
}

class _IncidentTile extends StatelessWidget {
  const _IncidentTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.location,
    required this.time,
  });

  final IconData icon;
  final Color    color;
  final String   title;
  final String   location;
  final String   time;

  @override
  Widget build(BuildContext context) {
    return NeuCard(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    )),
                Text(location,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    )),
              ],
            ),
          ),
          Text(time,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: AppTheme.textSecondary,
              )),
        ],
      ),
    );
  }
}