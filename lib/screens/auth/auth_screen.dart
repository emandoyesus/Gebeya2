import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/auth_provider.dart';

class AuthScreen extends StatefulWidget {
  final bool isModal;
  const AuthScreen({super.key, this.isModal = false});

  static Future<bool?> show(BuildContext context) {
    return Navigator.push<bool>(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const AuthScreen(isModal: true),
      ),
    );
  }

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isSignUp = false;
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _identifierController = TextEditingController(); // Email or Phone for sign-in
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController(text: '+251 9');
  final _passwordController = TextEditingController();
  final _streetController = TextEditingController();
  String _selectedSubcity = 'Bole';

  bool _obscurePassword = true;

  final List<String> _subcities = [
    'Bole',
    'Kazanchis',
    'Kirkos',
    'Lideta',
    'Yeka',
    'Arada',
    'Gulele',
    'Akaki-Kality',
    'Nifas Silk-Lafto',
    'Kolfe Keranio',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _identifierController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _streetController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    bool success = false;

    if (_isSignUp) {
      success = await auth.signUp(
        fullName: _nameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        password: _passwordController.text,
        subcity: _selectedSubcity,
        streetAddress: _streetController.text,
      );
    } else {
      success = await auth.signIn(
        identifier: _identifierController.text,
        password: _passwordController.text,
      );
    }

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isSignUp
                ? 'Welcome to Gebeya, ${_nameController.text.trim()}!'
                : 'Welcome back, ${auth.currentUser?.fullName ?? ''}!',
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context, true);
    } else if (auth.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage!),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: Text(_isSignUp ? 'Create Customer Account' : 'Sign In to Gebeya'),
        leading: widget.isModal
            ? IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context, false),
              )
            : null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Branded Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shopping_bag_rounded,
                          size: 40,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Gebeya',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                              color: isDark ? AppColors.primaryLight : AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'ገበያ',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _isSignUp
                            ? 'Register to save delivery addresses and track orders'
                            : 'Sign in to access your orders and fast checkout',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Tab Switcher (Sign In / Register)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : AppColors.lightCard,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => _isSignUp = false),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: !_isSignUp
                                  ? (isDark ? AppColors.primaryLight : AppColors.primary)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Sign In',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: !_isSignUp
                                    ? (isDark ? Colors.black : Colors.white)
                                    : (isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => _isSignUp = true),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: _isSignUp
                                  ? (isDark ? AppColors.primaryLight : AppColors.primary)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Create Account',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: _isSignUp
                                    ? (isDark ? Colors.black : Colors.white)
                                    : (isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Form Fields
                if (_isSignUp) ...[
                  TextFormField(
                    controller: _nameController,
                    maxLength: 60,
                    buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                    decoration: const InputDecoration(
                      labelText: 'Full Name (የሙሉ ስም)',
                      hintText: 'e.g. Abebe Kebede',
                      prefixIcon: Icon(Icons.person_outline_rounded),
                    ),
                    validator: (val) =>
                        val == null || val.trim().isEmpty ? 'Please enter your full name' : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _emailController,
                    maxLength: 80,
                    buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      hintText: 'you@example.com',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!val.contains('@') || !val.contains('.')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _phoneController,
                    maxLength: 20,
                    buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number (ስልክ ቁጥር)',
                      hintText: '+251 91 123 4567',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    validator: (val) =>
                        val == null || val.trim().isEmpty ? 'Please enter your phone number' : null,
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: _selectedSubcity,
                    decoration: const InputDecoration(
                      labelText: 'Default Delivery Subcity (ክፍለ ከተማ)',
                      prefixIcon: Icon(Icons.map_outlined),
                    ),
                    items: _subcities.map((sc) {
                      return DropdownMenuItem(value: sc, child: Text(sc));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedSubcity = val);
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _streetController,
                    maxLength: 140,
                    buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                    decoration: const InputDecoration(
                      labelText: 'Street / Landmark (አካባቢ / መለያ ቦታ)',
                      hintText: 'e.g. Near Medhanialem Church',
                      prefixIcon: Icon(Icons.home_outlined),
                    ),
                  ),
                ] else ...[
                  TextFormField(
                    controller: _identifierController,
                    maxLength: 80,
                    buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                    decoration: const InputDecoration(
                      labelText: 'Email or Phone Number',
                      hintText: 'abebe.kebede@gebeya.et or +251 91...',
                      prefixIcon: Icon(Icons.account_circle_outlined),
                    ),
                    validator: (val) => val == null || val.trim().isEmpty
                        ? 'Please enter your email or phone'
                        : null,
                  ),
                ],

                const SizedBox(height: 14),

                TextFormField(
                  controller: _passwordController,
                  maxLength: 64,
                  buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (val.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: auth.isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: isDark ? AppColors.primaryLight : AppColors.primary,
                      foregroundColor: isDark ? Colors.black : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: auth.isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: isDark ? Colors.black : Colors.white,
                            ),
                          )
                        : Text(
                            _isSignUp ? 'Create Free Account' : 'Sign In',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                // Demo Quick Fill Affordance
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _isSignUp = false;
                        _identifierController.text = 'abebe.kebede@gebeya.et';
                        _passwordController.text = '123456';
                      });
                    },
                    icon: const Icon(Icons.auto_awesome_rounded, size: 16),
                    label: const Text(
                      'Use Demo Account (Abebe Kebede)',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
