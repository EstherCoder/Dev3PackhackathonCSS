import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase, AuthException;
import 'home_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/neu_widgets.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  final _nameController            = TextEditingController();
  final _emailController           = TextEditingController();
  final _passwordController        = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey                   = GlobalKey<FormState>();

  bool _obscurePassword        = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms           = false;
  bool _isLoading              = false;

  late final AnimationController _fadeCtrl;
  late final Animation<double>   _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700))
      ..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!(_formKey.currentState?.validate() ?? false) || !_agreeToTerms) return;
    setState(() => _isLoading = true);
    try {
      await Supabase.instance.client.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        data: {'full_name': _nameController.text.trim()},
      );
      if (!mounted) return;
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => const HomeScreen()));
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message)));
  } finally {
    setState(() => _isLoading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Ambient glow
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppTheme.accentColor.withOpacity(0.12),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -60,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppTheme.primaryColor.withOpacity(0.10),
                  Colors.transparent,
                ]),
              ),
            ),
          ),

          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Back + title
                      Row(
                        children: [
                          NeuIconButton(
                            icon: Icons.arrow_back_ios_new_rounded,
                            onPressed: () => Navigator.pop(context),
                            size: 42,
                            iconColor: AppTheme.textPrimary,
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Create Account",
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              Text(
                                "Join the protection network",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 36),

                      // Avatar placeholder
                      _buildAvatarPicker(),

                      const SizedBox(height: 32),

                      // Form card
                      NeuCard(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            // Full name
                            TextFormField(
                              controller: _nameController,
                              style: const TextStyle(
                                  color: AppTheme.textPrimary, fontSize: 15),
                              textCapitalization: TextCapitalization.words,
                              decoration: AppTheme.inputDecoration(
                                label: "Full Name",
                                icon: Icons.person_outline_rounded,
                                hint: "John Doe",
                              ),
                              validator: (v) =>
                                  (v == null || v.trim().isEmpty)
                                      ? "Name is required"
                                      : null,
                            ),
                            const SizedBox(height: 18),

                            // Email
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(
                                  color: AppTheme.textPrimary, fontSize: 15),
                              decoration: AppTheme.inputDecoration(
                                label: "Email Address",
                                icon: Icons.email_outlined,
                                hint: "student@campus.edu",
                              ),
                              validator: (v) =>
                                  (v == null || !v.contains('@'))
                                      ? "Enter a valid email"
                                      : null,
                            ),
                            const SizedBox(height: 18),

                            // Password
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: const TextStyle(
                                  color: AppTheme.textPrimary, fontSize: 15),
                              decoration: AppTheme.inputDecoration(
                                label: "Password",
                                icon: Icons.lock_outline_rounded,
                                suffix: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: AppTheme.textSecondary,
                                    size: 20,
                                  ),
                                  onPressed: () => setState(() =>
                                      _obscurePassword = !_obscurePassword),
                                ),
                              ),
                              validator: (v) =>
                                  (v == null || v.length < 6)
                                      ? "Minimum 6 characters"
                                      : null,
                            ),
                            const SizedBox(height: 18),

                            // Confirm password
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              style: const TextStyle(
                                  color: AppTheme.textPrimary, fontSize: 15),
                              decoration: AppTheme.inputDecoration(
                                label: "Confirm Password",
                                icon: Icons.lock_outline_rounded,
                                suffix: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: AppTheme.textSecondary,
                                    size: 20,
                                  ),
                                  onPressed: () => setState(() =>
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword),
                                ),
                              ),
                              validator: (v) =>
                                  v != _passwordController.text
                                      ? "Passwords do not match"
                                      : null,
                            ),

                            const SizedBox(height: 24),

                            // Terms checkbox
                            GestureDetector(
                              onTap: () => setState(
                                  () => _agreeToTerms = !_agreeToTerms),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      color: _agreeToTerms
                                          ? AppTheme.primaryColor
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: _agreeToTerms
                                            ? AppTheme.primaryColor
                                            : AppTheme.textSecondary,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: _agreeToTerms
                                        ? const Icon(Icons.check_rounded,
                                            color: AppTheme.bgBase, size: 14)
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          color: AppTheme.textSecondary,
                                        ),
                                        children: [
                                          const TextSpan(
                                              text: "I agree to the "),
                                          TextSpan(
                                            text: "Terms of Service",
                                            style: TextStyle(
                                              color: AppTheme.primaryColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const TextSpan(text: " and "),
                                          TextSpan(
                                            text: "Privacy Policy",
                                            style: TextStyle(
                                              color: AppTheme.primaryColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 28),

                            // Sign up button
                            NeuButton(
                              onPressed: (_agreeToTerms && !_isLoading)
                                  ? _handleSignup
                                  : null,
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              color: _agreeToTerms
                                  ? AppTheme.primaryColor
                                  : AppTheme.textHint,
                              radius: 14,
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: AppTheme.bgBase,
                                      ),
                                    )
                                  : Text(
                                      "CREATE  ACCOUNT",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 2,
                                        color: AppTheme.bgBase,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?  ",
                            style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: AppTheme.textSecondary),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              "Log In",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarPicker() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.bgRaised,
              boxShadow: AppTheme.raise(intensity: 1.2),
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(0.25),
                width: 1.5,
              ),
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              color: AppTheme.textSecondary,
              size: 40,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                shape: BoxShape.circle,
                boxShadow: AppTheme.glow(intensity: 0.6),
              ),
              child: const Icon(Icons.add_rounded,
                  color: AppTheme.bgBase, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}