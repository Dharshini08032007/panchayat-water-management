import 'package:flutter/material.dart';

class NeerWatchApp extends StatefulWidget {
  const NeerWatchApp({super.key});

  @override
  State<NeerWatchApp> createState() => _NeerWatchAppState();
}

class _NeerWatchAppState extends State<NeerWatchApp> {
  late final NeerWatchController _controller;

  @override
  void initState() {
    super.initState();
    _controller = NeerWatchController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NeerWatchScope(
      controller: _controller,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'NeerWatch',
            theme: NeerWatchTheme.light,
            home: AnimatedSwitcher(
              duration: const Duration(milliseconds: 320),
              child: _controller.isAuthenticated
                  ? const MainShell(key: ValueKey('shell'))
                  : const AuthFlowScreen(key: ValueKey('auth')),
            ),
          );
        },
      ),
    );
  }
}

class NeerWatchTheme {
  static const Color sky = Color(0xFF67C6FF);
  static const Color skyDeep = Color(0xFF0B7FCA);
  static const Color calmSurface = Color(0xFFF7FBFF);
  static const Color ink = Color(0xFF0D1B2A);

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: sky,
      brightness: Brightness.light,
      primary: skyDeep,
      secondary: sky,
      surface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: calmSurface,
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: ink),
        headlineMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: ink),
        headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: ink),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: ink),
        bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF203040)),
        bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF556B81)),
      ),
      cardTheme: CardThemeData(
        color: Colors.white.withOpacity(0.92),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF4F9FF),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: Color(0xFFE2EEF9)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: skyDeep, width: 1.4),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white.withOpacity(0.95),
        indicatorColor: sky.withOpacity(0.16),
        labelTextStyle: MaterialStateProperty.resolveWith(
          (states) => TextStyle(
            fontWeight: states.contains(MaterialState.selected) ? FontWeight.w700 : FontWeight.w600,
            color: states.contains(MaterialState.selected) ? skyDeep : const Color(0xFF607488),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF12324C),
        contentTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }
}

enum AppRole { user, incharge, admin }

enum AppTab { home, complaints, profile }

class NeerWatchUser {
  const NeerWatchUser({
    required this.name,
    required this.phone,
    required this.role,
  });

  final String name;
  final String phone;
  final AppRole role;

  NeerWatchUser copyWith({String? name, String? phone, AppRole? role}) {
    return NeerWatchUser(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role ?? this.role,
    );
  }
}

class WaterSchedule {
  const WaterSchedule({
    required this.area,
    required this.dateLabel,
    required this.startTime,
    required this.endTime,
    required this.isScheduled,
  });

  final String area;
  final String dateLabel;
  final String startTime;
  final String endTime;
  final bool isScheduled;
}

class ComplaintStats {
  const ComplaintStats({
    required this.total,
    required this.solved,
    required this.pending,
  });

  final int total;
  final int solved;
  final int pending;

  ComplaintStats copyWith({int? total, int? solved, int? pending}) {
    return ComplaintStats(
      total: total ?? this.total,
      solved: solved ?? this.solved,
      pending: pending ?? this.pending,
    );
  }
}

class ComplaintItem {
  ComplaintItem({
    required this.area,
    required this.type,
    required this.address,
    required this.description,
    required this.createdLabel,
    required this.hasPhoto,
  });

  final String area;
  final String type;
  final String address;
  final String description;
  final String createdLabel;
  final bool hasPhoto;
}

class _AccountRecord {
  _AccountRecord({
    required this.user,
    required this.password,
    required this.canSignUp,
  });

  NeerWatchUser user;
  String password;
  final bool canSignUp;
}

class NeerWatchController extends ChangeNotifier {
  NeerWatchController()
      : _accounts = [
          _AccountRecord(
            user: const NeerWatchUser(
              name: 'Aarav Resident',
              phone: '9876543210',
              role: AppRole.user,
            ),
            password: 'Water@123',
            canSignUp: true,
          ),
          _AccountRecord(
            user: const NeerWatchUser(
              name: 'Meera Incharge',
              phone: '9000011111',
              role: AppRole.incharge,
            ),
            password: 'Incharge@123',
            canSignUp: false,
          ),
          _AccountRecord(
            user: const NeerWatchUser(
              name: 'District Admin',
              phone: '8000000000',
              role: AppRole.admin,
            ),
            password: 'Admin@123',
            canSignUp: false,
          ),
        ],
        _areaSchedules = {
          'Ward 1 - River View': const WaterSchedule(
            area: 'Ward 1 - River View',
            dateLabel: 'Tue, 13 May',
            startTime: '06:00 AM',
            endTime: '08:00 AM',
            isScheduled: true,
          ),
          'Ward 2 - Temple Lane': const WaterSchedule(
            area: 'Ward 2 - Temple Lane',
            dateLabel: 'Wed, 14 May',
            startTime: '07:00 AM',
            endTime: '09:00 AM',
            isScheduled: true,
          ),
          'Ward 3 - Market Street': const WaterSchedule(
            area: 'Ward 3 - Market Street',
            dateLabel: 'No schedule assigned',
            startTime: '',
            endTime: '',
            isScheduled: false,
          ),
          'Ward 4 - School Road': const WaterSchedule(
            area: 'Ward 4 - School Road',
            dateLabel: 'Fri, 16 May',
            startTime: '05:30 AM',
            endTime: '07:30 AM',
            isScheduled: true,
          ),
        } {
    selectedRole = AppRole.user;
    selectedArea = _areaSchedules.keys.first;
    selectedComplaintType = complaintTypes.first;
    complaintStats = const ComplaintStats(total: 18, solved: 12, pending: 6);
    currentUser = null;
    isAuthenticated = false;
    activeTab = AppTab.home;
    warningText = '';
    loginPhone = '';
    loginPassword = '';
    signupName = '';
    signupPhone = '';
    signupPassword = '';
    signupConfirmPassword = '';
    signupOtp = '';
    photoLabel = '';
    complaintAddress = '';
    complaintDescription = '';
  }

  final List<_AccountRecord> _accounts;
  final Map<String, WaterSchedule> _areaSchedules;

  bool isAuthenticated = false;
  AppTab activeTab = AppTab.home;
  AppRole selectedRole = AppRole.user;
  NeerWatchUser? currentUser;
  String loginPhone = '';
  String loginPassword = '';
  String warningText = '';
  String selectedArea = '';
  String selectedComplaintType = '';
  String photoLabel = '';
  String complaintAddress = '';
  String complaintDescription = '';
  String signupName = '';
  String signupPhone = '';
  String signupPassword = '';
  String signupConfirmPassword = '';
  String signupOtp = '';
  ComplaintStats complaintStats = const ComplaintStats(total: 0, solved: 0, pending: 0);

  final List<String> complaintTypes = const [
    'Low pressure',
    'No supply',
    'Pipe leakage',
    'Dirty water',
    'Valve issue',
  ];

  final List<ComplaintItem> complaints = [
    ComplaintItem(
      area: 'Ward 1 - River View',
      type: 'Low pressure',
      address: 'Near community tank',
      description: 'Morning water pressure is low for three houses.',
      createdLabel: 'Today, 8:30 AM',
      hasPhoto: true,
    ),
    ComplaintItem(
      area: 'Ward 2 - Temple Lane',
      type: 'Dirty water',
      address: 'Temple street corner',
      description: 'Water has a muddy tint during evening supply.',
      createdLabel: 'Yesterday',
      hasPhoto: true,
    ),
  ];

  List<String> get areaOptions => _areaSchedules.keys.toList(growable: false);
  WaterSchedule? get selectedSchedule => _areaSchedules[selectedArea];

  void selectRole(AppRole role) {
    selectedRole = role;
    warningText = '';
    notifyListeners();
  }

  void setLoginPhone(String value) {
    loginPhone = value.trim();
    warningText = '';
    notifyListeners();
  }

  void setLoginPassword(String value) {
    loginPassword = value;
    warningText = '';
    notifyListeners();
  }

  void selectArea(String value) {
    selectedArea = value;
    notifyListeners();
  }

  void selectComplaintType(String value) {
    selectedComplaintType = value;
    notifyListeners();
  }

  void setComplaintAddress(String value) {
    complaintAddress = value;
    notifyListeners();
  }

  void setComplaintDescription(String value) {
    complaintDescription = value;
    notifyListeners();
  }

  void setSignupName(String value) {
    signupName = value.trim();
    notifyListeners();
  }

  void setSignupPhone(String value) {
    signupPhone = value.trim();
    notifyListeners();
  }

  void setSignupPassword(String value) {
    signupPassword = value;
    notifyListeners();
  }

  void setSignupConfirmPassword(String value) {
    signupConfirmPassword = value;
    notifyListeners();
  }

  void setSignupOtp(String value) {
    signupOtp = value.replaceAll(' ', '').trim();
    notifyListeners();
  }

  void markPhotoAttached() {
    photoLabel = 'Site photo attached';
    notifyListeners();
  }

  void removePhotoAttachment() {
    photoLabel = '';
    notifyListeners();
  }

  void selectTab(AppTab tab) {
    activeTab = tab;
    notifyListeners();
  }

  void updateCurrentUser({String? name, String? phone, String? password}) {
    final user = currentUser;
    if (user == null) {
      return;
    }

    final previousPhone = user.phone;
    currentUser = user.copyWith(
      name: name,
      phone: phone,
    );

    final accountIndex = _accounts.indexWhere((record) => record.user.phone == previousPhone);
    if (accountIndex != -1) {
      _accounts[accountIndex].user = currentUser!;
      if (password != null && password.isNotEmpty) {
        _accounts[accountIndex].password = password;
      }
    }

    loginPhone = currentUser!.phone;
    if (password != null && password.isNotEmpty) {
      loginPassword = password;
    }
    notifyListeners();
  }

  void login() {
    final index = _accounts.indexWhere((record) => record.user.phone == loginPhone);
    if (index == -1) {
      warningText = 'Invalid phone number or password';
      notifyListeners();
      return;
    }

    final account = _accounts[index];
    if (account.user.role != selectedRole) {
      warningText = 'Not a valid user for selected role';
      notifyListeners();
      return;
    }

    if (account.password != loginPassword) {
      warningText = 'Invalid phone number or password';
      notifyListeners();
      return;
    }

    currentUser = account.user;
    isAuthenticated = true;
    activeTab = AppTab.home;
    warningText = '';
    selectedArea = _areaSchedules.keys.first;
    photoLabel = '';
    complaintAddress = '';
    complaintDescription = '';
    notifyListeners();
  }

  bool sendOtp() {
    if (selectedRole != AppRole.user) {
      warningText = 'Only users can create new accounts';
      notifyListeners();
      return false;
    }

    warningText = 'Demo OTP sent: 246810';
    signupOtp = '';
    notifyListeners();
    return true;
  }

  bool verifyOtpAndCreateAccount() {
    if (selectedRole != AppRole.user) {
      warningText = 'Only users can create new accounts';
      notifyListeners();
      return false;
    }

    if (signupName.isEmpty || signupPhone.isEmpty || signupPassword.isEmpty || signupConfirmPassword.isEmpty) {
      warningText = 'Please complete all signup fields';
      notifyListeners();
      return false;
    }

    if (signupPassword != signupConfirmPassword) {
      warningText = 'Passwords do not match';
      notifyListeners();
      return false;
    }

    if (signupOtp != '246810') {
      warningText = 'Invalid OTP';
      notifyListeners();
      return false;
    }

    final newUser = NeerWatchUser(
      name: signupName,
      phone: signupPhone,
      role: AppRole.user,
    );

    _accounts.removeWhere((record) => record.user.phone == newUser.phone);
    _accounts.add(_AccountRecord(user: newUser, password: signupPassword, canSignUp: true));
    currentUser = newUser;
    isAuthenticated = true;
    activeTab = AppTab.home;
    warningText = '';
    notifyListeners();
    return true;
  }

  void submitComplaint() {
    final user = currentUser;
    if (user == null) {
      return;
    }

    complaints.insert(
      0,
      ComplaintItem(
        area: selectedArea,
        type: selectedComplaintType,
        address: complaintAddress,
        description: complaintDescription,
        createdLabel: 'Just now',
        hasPhoto: photoLabel.isNotEmpty,
      ),
    );

    complaintStats = complaintStats.copyWith(
      total: complaintStats.total + 1,
      pending: complaintStats.pending + 1,
    );
    photoLabel = '';
    complaintAddress = '';
    complaintDescription = '';
    notifyListeners();
  }

  void logout() {
    isAuthenticated = false;
    currentUser = null;
    activeTab = AppTab.home;
    loginPhone = '';
    loginPassword = '';
    warningText = '';
    notifyListeners();
  }
}

class NeerWatchScope extends InheritedNotifier<NeerWatchController> {
  const NeerWatchScope({
    super.key,
    required NeerWatchController controller,
    required Widget child,
  }) : super(notifier: controller, child: child);

  static NeerWatchController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<NeerWatchScope>();
    assert(scope != null, 'NeerWatchScope not found in context');
    return scope!.notifier!;
  }
}

class AuthFlowScreen extends StatefulWidget {
  const AuthFlowScreen({super.key});

  @override
  State<AuthFlowScreen> createState() => _AuthFlowScreenState();
}

class _AuthFlowScreenState extends State<AuthFlowScreen> {
  bool _showSignup = false;

  void _toggleSignup([bool? value]) {
    setState(() {
      _showSignup = value ?? !_showSignup;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF8FCFF), Color(0xFFE9F7FF), Color(0xFFFDFEFF)],
        ),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 320),
        child: _showSignup
            ? SignupScreen(key: const ValueKey('signup'), onBackToLogin: () => _toggleSignup(false))
            : LoginScreen(key: const ValueKey('login'), onSignupRequested: () => _toggleSignup(true)),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, required this.onSignupRequested});

  final VoidCallback onSignupRequested;

  @override
  Widget build(BuildContext context) {
    final controller = NeerWatchScope.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Center(
              child: Column(
                children: [
                  Container(
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(colors: [Color(0xFF0B7FCA), Color(0xFF7FD3FF)]),
                      boxShadow: const [BoxShadow(color: Color(0x3347A6E5), blurRadius: 24, offset: Offset(0, 10))],
                    ),
                    child: const Icon(Icons.water_drop_rounded, color: Colors.white, size: 36),
                  ),
                  const SizedBox(height: 14),
                  Text('NeerWatch', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 6),
                  const Text(
                    'Smart Panchayat Water Management System',
                    style: TextStyle(color: Color(0xFF607488), fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select Your Role', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(child: _RoleCard(role: AppRole.user, label: 'User', icon: Icons.person_outline)),
                      const SizedBox(width: 10),
                      Expanded(child: _RoleCard(role: AppRole.incharge, label: 'Incharge', icon: Icons.support_agent_outlined)),
                      const SizedBox(width: 10),
                      Expanded(child: _RoleCard(role: AppRole.admin, label: 'Admin', icon: Icons.admin_panel_settings_outlined)),
                    ],
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    keyboardType: TextInputType.phone,
                    onChanged: controller.setLoginPhone,
                    decoration: const InputDecoration(
                      labelText: 'Phone number',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    obscureText: true,
                    onChanged: controller.setLoginPassword,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: controller.warningText.isEmpty
                        ? const SizedBox.shrink()
                        : Container(
                            key: ValueKey(controller.warningText),
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF0F0),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: const Color(0xFFFFC7C7)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.warning_amber_rounded, color: Color(0xFFE15E5E)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    controller.warningText,
                                    style: const TextStyle(color: Color(0xFFC14D4D), fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    label: 'Login',
                    onPressed: controller.login,
                    leading: const Icon(Icons.lock_open_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(height: 14),
                  Center(
                    child: TextButton(
                      onPressed: controller.selectedRole == AppRole.user
                          ? onSignupRequested
                          : () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Only USER role can sign up')),
                              );
                            },
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(color: Color(0xFF41576C), fontWeight: FontWeight.w600),
                          children: [
                            TextSpan(text: "Doesn't have an account? "),
                            TextSpan(
                              text: 'Sign Up',
                              style: TextStyle(color: Color(0xFF0B7FCA), fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Demo credentials', style: TextStyle(fontWeight: FontWeight.w800)),
                  SizedBox(height: 8),
                  Text('User: 9876543210 / Water@123'),
                  Text('Incharge: 9000011111 / Incharge@123'),
                  Text('Admin: 8000000000 / Admin@123'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({required this.role, required this.label, required this.icon});

  final AppRole role;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final controller = NeerWatchScope.of(context);
    final selected = controller.selectedRole == role;

    return GestureDetector(
      onTap: () => controller.selectRole(role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE7F6FF) : const Color(0xFFF6FAFF),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: selected ? const Color(0xFF92D2FF) : const Color(0xFFE5EEF6)),
          boxShadow: selected ? const [BoxShadow(color: Color(0x2200A0FF), blurRadius: 16, offset: Offset(0, 8))] : const [],
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? const Color(0xFF0B7FCA) : const Color(0xFF67839B)),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: selected ? const Color(0xFF0B7FCA) : const Color(0xFF50667C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key, required this.onBackToLogin});

  final VoidCallback onBackToLogin;

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    for (final node in _otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _syncOtp(NeerWatchController controller) {
    controller.setSignupOtp(_otpControllers.map((value) => value.text).join());
  }

  @override
  Widget build(BuildContext context) {
    final controller = NeerWatchScope.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: widget.onBackToLogin,
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                const Spacer(),
                const Text(
                  'User Sign Up',
                  style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF12324C)),
                ),
                const Spacer(flex: 2),
              ],
            ),
            const SizedBox(height: 8),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Create your user account', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  const Text(
                    'Only USER role can register. Admin and Incharge accounts are managed centrally.',
                    style: TextStyle(color: Color(0xFF607488), height: 1.4),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    onChanged: controller.setSignupName,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    keyboardType: TextInputType.phone,
                    onChanged: controller.setSignupPhone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    obscureText: true,
                    onChanged: controller.setSignupPassword,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    obscureText: true,
                    onChanged: controller.setSignupConfirmPassword,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock_reset_outlined),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text('OTP Verification', style: TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  Row(
                    children: List.generate(6, (index) {
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: index == 5 ? 0 : 8),
                          child: SizedBox(
                            height: 54,
                            child: TextField(
                              controller: _otpControllers[index],
                              focusNode: _otpFocusNodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              decoration: InputDecoration(
                                counterText: '',
                                filled: true,
                                fillColor: const Color(0xFFF4F9FF),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty && index < 5) {
                                  _otpFocusNodes[index + 1].requestFocus();
                                }
                                _syncOtp(controller);
                              },
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    label: 'Send OTP',
                    onPressed: controller.sendOtp,
                    leading: const Icon(Icons.sms_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(height: 10),
                  PrimaryButton(
                    label: 'Verify OTP & Sign Up',
                    onPressed: () {
                      if (controller.verifyOtpAndCreateAccount()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Account created successfully')),
                        );
                      }
                    },
                    leading: const Icon(Icons.verified_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(height: 14),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: controller.warningText.isEmpty
                        ? const SizedBox.shrink()
                        : Container(
                            key: ValueKey(controller.warningText),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF0F0),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: const Color(0xFFFFC7C7)),
                            ),
                            child: Text(
                              controller.warningText,
                              style: const TextStyle(color: Color(0xFFC14D4D), fontWeight: FontWeight.w700),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = NeerWatchScope.of(context);
    final pages = [
      const DashboardScreen(),
      const ComplaintHistoryScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        child: pages[controller.activeTab.index],
      ),
      floatingActionButton: controller.activeTab == AppTab.home
          ? FloatingActionButton.extended(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ComplaintFormScreen()),
                );
              },
              backgroundColor: NeerWatchTheme.skyDeep,
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: const Text(
                'Arise Complaint',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: controller.activeTab.index,
        onDestinationSelected: (index) => controller.selectTab(AppTab.values[index]),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.report_gmailerrorred_outlined),
            selectedIcon: Icon(Icons.report_gmailerrorred_rounded),
            label: 'Complaints',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = NeerWatchScope.of(context);
    final user = controller.currentUser;
    final schedule = controller.selectedSchedule;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF8FCFF), Color(0xFFEAF7FF)],
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _WaterHeader(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Welcome back', style: TextStyle(color: Color(0xFF607488), fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(
                            'Welcome, ${user?.name ?? 'Resident'}',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                    _IconBadge(icon: Icons.notifications_none_rounded),
                    const SizedBox(width: 10),
                    _IconBadge(icon: Icons.person_outline_rounded),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Select Your Area', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: controller.selectedArea,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.map_outlined),
                      ),
                      items: controller.areaOptions
                          .map((area) => DropdownMenuItem<String>(value: area, child: Text(area)))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          controller.selectArea(value);
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 280),
                      child: schedule == null
                          ? const SizedBox.shrink()
                          : GlassTile(
                              key: ValueKey(schedule.area),
                              child: schedule.isScheduled
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const StatusBadge(label: 'Scheduled', active: true),
                                            const Spacer(),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFE6F4FF),
                                                borderRadius: BorderRadius.circular(999),
                                              ),
                                              child: const Text(
                                                'Blue glow active',
                                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF0B7FCA)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 14),
                                        Text(schedule.area, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                                        const SizedBox(height: 8),
                                        _ScheduleRow(label: 'Date', value: schedule.dateLabel),
                                        const SizedBox(height: 8),
                                        _ScheduleRow(label: 'Start Time', value: schedule.startTime),
                                        const SizedBox(height: 8),
                                        _ScheduleRow(label: 'End Time', value: schedule.endTime),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const StatusBadge(label: 'Not Scheduled', active: false),
                                        const SizedBox(height: 14),
                                        Text(schedule.area, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'No supply slot has been assigned for this area yet.',
                                          style: TextStyle(color: Color(0xFF6B7E91), height: 1.45),
                                        ),
                                      ],
                                    ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    title: 'Complaint Summary',
                    subtitle: 'Quick overview of active service issues',
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      MiniStatCard(
                        label: 'Total Complaints',
                        value: '${controller.complaintStats.total}',
                        icon: Icons.report_outlined,
                        tint: const Color(0xFF0B7FCA),
                      ),
                      const SizedBox(width: 12),
                      MiniStatCard(
                        label: 'Solved',
                        value: '${controller.complaintStats.solved}',
                        icon: Icons.verified_outlined,
                        tint: const Color(0xFF1E9A5B),
                      ),
                      const SizedBox(width: 12),
                      MiniStatCard(
                        label: 'Pending',
                        value: '${controller.complaintStats.pending}',
                        icon: Icons.timelapse_rounded,
                        tint: const Color(0xFFF59B23),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(
                      title: 'Water Service Notes',
                      subtitle: 'Calm, water-inspired status indicators',
                    ),
                    const SizedBox(height: 12),
                    _HintRow(
                      icon: Icons.water_drop_outlined,
                      title: 'Scheduled supply',
                      subtitle: 'A blue glowing badge highlights the active window.',
                    ),
                    const SizedBox(height: 12),
                    _HintRow(
                      icon: Icons.bolt_outlined,
                      title: 'Fast complaint flow',
                      subtitle: 'The floating action button opens a premium form.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 92),
          ],
        ),
      ),
    );
  }
}

class ComplaintHistoryScreen extends StatelessWidget {
  const ComplaintHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = NeerWatchScope.of(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF8FCFF), Color(0xFFEAF7FF)],
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            const SectionHeader(
              title: 'Complaint History',
              subtitle: 'Recent reports and live status tracking',
            ),
            const SizedBox(height: 18),
            ...controller.complaints.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: GlassTile(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE5F5FF),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.water_damage_outlined, color: Color(0xFF0B7FCA)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.type, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                                const SizedBox(height: 2),
                                Text(item.area, style: const TextStyle(color: Color(0xFF607488), fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          StatusBadge(label: item.createdLabel, active: true),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(item.description, style: const TextStyle(height: 1.45)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 18, color: Color(0xFF0B7FCA)),
                          const SizedBox(width: 6),
                          Expanded(child: Text(item.address, style: const TextStyle(color: Color(0xFF41576C)))),
                          if (item.hasPhoto) const StatusBadge(label: 'Photo attached', active: true),
                        ],
                      ),
                    ],
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

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = NeerWatchScope.of(context);
    final user = controller.currentUser;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF8FCFF), Color(0xFFEAF7FF)],
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            const SectionHeader(
              title: 'Profile & Settings',
              subtitle: 'Manage your account and security details',
            ),
            const SizedBox(height: 18),
            GlassCard(
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF0B7FCA), Color(0xFF7FD3FF)]),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Icon(Icons.person, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user?.name ?? 'Resident', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text(user?.phone ?? '', style: const TextStyle(color: Color(0xFF607488), fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  StatusBadge(label: _roleLabel(user?.role), active: true),
                ],
              ),
            ),
            const SizedBox(height: 18),
            GlassCard(
              child: Column(
                children: [
                  _SettingsTile(
                    icon: Icons.edit_outlined,
                    title: 'Edit Profile',
                    subtitle: 'Change your display name',
                    onTap: () => _showEditNameSheet(context),
                  ),
                  const Divider(height: 1),
                  _SettingsTile(
                    icon: Icons.lock_reset_outlined,
                    title: 'Change Password',
                    subtitle: 'Update your account password',
                    onTap: () => _showChangePasswordSheet(context),
                  ),
                  const Divider(height: 1),
                  _SettingsTile(
                    icon: Icons.phone_android_outlined,
                    title: 'Update Phone Number',
                    subtitle: 'Replace the registered mobile number',
                    onTap: () => _showUpdatePhoneSheet(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            GlassCard(
              child: _SettingsTile(
                icon: Icons.logout_rounded,
                title: 'Logout',
                subtitle: 'Sign out from this device',
                onTap: controller.logout,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _roleLabel(AppRole? role) {
    switch (role) {
      case AppRole.admin:
        return 'Admin';
      case AppRole.incharge:
        return 'Incharge';
      case AppRole.user:
      case null:
        return 'User';
    }
  }

  void _showEditNameSheet(BuildContext context) {
    final controller = NeerWatchScope.of(context);
    final textController = TextEditingController(text: controller.currentUser?.name ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 18,
            right: 18,
            top: 18,
            bottom: MediaQuery.of(context).viewInsets.bottom + 18,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Edit Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              TextField(controller: textController, decoration: const InputDecoration(labelText: 'Full Name')),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Save Changes',
                onPressed: () {
                  controller.updateCurrentUser(name: textController.text.trim());
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showChangePasswordSheet(BuildContext context) {
    final controller = NeerWatchScope.of(context);
    final passwordController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 18,
            right: 18,
            top: 18,
            bottom: MediaQuery.of(context).viewInsets.bottom + 18,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Change Password', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'New Password'),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Update Password',
                onPressed: () {
                  controller.updateCurrentUser(password: passwordController.text);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showUpdatePhoneSheet(BuildContext context) {
    final controller = NeerWatchScope.of(context);
    final phoneController = TextEditingController(text: controller.currentUser?.phone ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 18,
            right: 18,
            top: 18,
            bottom: MediaQuery.of(context).viewInsets.bottom + 18,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Update Phone Number', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'New Phone Number'),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Update Number',
                onPressed: () {
                  controller.updateCurrentUser(phone: phoneController.text.trim());
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.icon, required this.title, required this.subtitle, required this.onTap});

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFEAF7FF),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: const Color(0xFF0B7FCA)),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }
}

class ComplaintFormScreen extends StatefulWidget {
  const ComplaintFormScreen({super.key});

  @override
  State<ComplaintFormScreen> createState() => _ComplaintFormScreenState();
}

class _ComplaintFormScreenState extends State<ComplaintFormScreen> {
  final List<TextEditingController> _photoPreviewControllers = [];

  @override
  void dispose() {
    for (final controller in _photoPreviewControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = NeerWatchScope.of(context);
    final user = controller.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Arise Complaint'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FCFF), Color(0xFFEAF7FF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Report a water issue', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text(
                    'Your profile details are filled automatically for a smoother civic service flow.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: _ReadOnlyField(
                          label: 'User Name',
                          value: user?.name ?? '',
                          icon: Icons.person_outline,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ReadOnlyField(
                          label: 'Phone Number',
                          value: user?.phone ?? '',
                          icon: Icons.phone_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: controller.selectedArea,
                    decoration: const InputDecoration(
                      labelText: 'Area',
                      prefixIcon: Icon(Icons.map_outlined),
                    ),
                    items: controller.areaOptions
                        .map((area) => DropdownMenuItem<String>(value: area, child: Text(area)))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.selectArea(value);
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: controller.selectedComplaintType,
                    decoration: const InputDecoration(
                      labelText: 'Complaint Type',
                      prefixIcon: Icon(Icons.report_problem_outlined),
                    ),
                    items: controller.complaintTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.selectComplaintType(value);
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: controller.markPhotoAttached,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F9FF),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFDCEBF7)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE1F2FF),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(Icons.cloud_upload_outlined, color: Color(0xFF0B7FCA)),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Upload Photo', style: TextStyle(fontWeight: FontWeight.w800)),
                                const SizedBox(height: 4),
                                Text(
                                  controller.photoLabel.isEmpty
                                      ? 'Photo upload is mandatory. Tap to attach a site photo.'
                                      : controller.photoLabel,
                                  style: const TextStyle(color: Color(0xFF607488), height: 1.35),
                                ),
                              ],
                            ),
                          ),
                          if (controller.photoLabel.isNotEmpty)
                            IconButton(
                              onPressed: controller.removePhotoAttachment,
                              icon: const Icon(Icons.close_rounded),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    maxLines: 2,
                    onChanged: controller.setComplaintAddress,
                    decoration: const InputDecoration(
                      labelText: 'Proper Address',
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    maxLines: 5,
                    onChanged: controller.setComplaintDescription,
                    decoration: const InputDecoration(
                      labelText: 'Complaint Description',
                      alignLabelWithHint: true,
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(bottom: 72),
                        child: Icon(Icons.notes_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  PrimaryButton(
                    label: 'Submit Complaint',
                    onPressed: () {
                      if (controller.photoLabel.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please attach a photo before submitting')),
                        );
                        return;
                      }
                      controller.submitComplaint();
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Complaint submitted successfully')),
                      );
                    },
                    leading: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  const GlassCard({super.key, required this.child, this.padding = const EdgeInsets.all(18)});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFFEAF2F8)),
          boxShadow: const [BoxShadow(color: Color(0x140B2A4D), blurRadius: 24, offset: Offset(0, 14))],
        ),
        padding: padding,
        child: child,
      ),
    );
  }
}

class GlassTile extends StatelessWidget {
  const GlassTile({super.key, required this.child, this.padding = const EdgeInsets.all(16)});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE9F3FB)),
          boxShadow: const [BoxShadow(color: Color(0x0E12415E), blurRadius: 16, offset: Offset(0, 8))],
        ),
        child: child,
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.subtitle, this.trailing});

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.label, this.onPressed, this.leading});

  final String label;
  final VoidCallback? onPressed;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(colors: [NeerWatchTheme.skyDeep, NeerWatchTheme.sky]),
        boxShadow: const [BoxShadow(color: Color(0x332E86D1), blurRadius: 18, offset: Offset(0, 10))],
      ),
      child: SizedBox(
        width: double.infinity,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leading != null) ...[leading!, const SizedBox(width: 10)],
                  Text(
                    label,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFE6F4FF) : const Color(0xFFFFF2E6),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: active ? const Color(0xFF8ECFFF) : const Color(0xFFF2C89A)),
        boxShadow: active ? const [BoxShadow(color: Color(0x2200A0FF), blurRadius: 16, offset: Offset(0, 8))] : const [],
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: active ? NeerWatchTheme.skyDeep : const Color(0xFFB46A1F),
        ),
      ),
    );
  }
}

class MiniStatCard extends StatelessWidget {
  const MiniStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.tint,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GlassTile(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: tint.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: tint, size: 20),
            ),
            const SizedBox(height: 16),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF607488), fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _WaterHeader extends StatelessWidget {
  const _WaterHeader({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _WaveClipper(),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE8F6FF), Color(0xFFBFE8FF), Color(0xFFDBF4FF)],
          ),
        ),
        child: child,
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 34);
    path.quadraticBezierTo(size.width * 0.20, size.height, size.width * 0.50, size.height - 18);
    path.quadraticBezierTo(size.width * 0.82, size.height - 40, size.width, size.height - 10);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4EFF7)),
        boxShadow: const [BoxShadow(color: Color(0x0E12415E), blurRadius: 16, offset: Offset(0, 8))],
      ),
      child: Icon(icon, color: NeerWatchTheme.skyDeep),
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  const _ScheduleRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFF607488), fontWeight: FontWeight.w700),
          ),
        ),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _HintRow extends StatelessWidget {
  const _HintRow({required this.icon, required this.title, required this.subtitle});

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF7FF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: NeerWatchTheme.skyDeep),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(color: Color(0xFF607488), height: 1.3)),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }
}
