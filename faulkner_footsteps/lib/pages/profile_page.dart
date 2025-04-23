import 'package:faulkner_footsteps/app_router.dart';
import 'package:faulkner_footsteps/pages/achievement.dart';
import 'package:faulkner_footsteps/pages/admin_page.dart';
import 'package:faulkner_footsteps/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:faulkner_footsteps/app_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get current user and credentials
      final user = FirebaseAuth.instance.currentUser;
      final email = user?.email;

      if (user != null && email != null) {
        // Reauthenticate user
        final credential = EmailAuthProvider.credential(
          email: email,
          password: _currentPasswordController.text,
        );

        await user.reauthenticateWithCredential(credential);

        // Change password
        await user.updatePassword(_newPasswordController.text);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password successfully updated'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            'Failed to change password. Please check your current password.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToAchievementsPage() {
    // Navigate to achievements page with the app state's historical sites
    final appState = Provider.of<ApplicationState>(context, listen: false);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AchievementsPage(
          displaySites: appState.historicalSites,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    // Get screen width to set explicit width for all cards
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth =
        screenWidth - 32.0; // Account for padding (16px on each side)

    // Check if user is admin based on the static flag in LoginPage
    final isAdmin = LoginPage.isAdmin;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 214, 196),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 107, 79, 79),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 255, 243, 228),
        ),
        title: Text(
          'Profile',
          style: GoogleFonts.ultra(
            textStyle: const TextStyle(
              color: Color.fromARGB(255, 255, 243, 228),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Center the cards
          children: [
            // Email card
            Container(
              width: cardWidth,
              child: Card(
                color: const Color.fromARGB(255, 250, 235, 215),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style: GoogleFonts.ultra(
                          textStyle: const TextStyle(
                            color: Color.fromARGB(255, 72, 52, 52),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user?.email ?? 'Not signed in',
                        style: GoogleFonts.rakkas(
                          textStyle: const TextStyle(
                            color: Color.fromARGB(255, 107, 79, 79),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Admin section (only visible for admins)
            if (isAdmin) ...[
              Container(
                width: cardWidth,
                child: Card(
                  color: const Color.fromARGB(255, 218, 186, 130),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Admin Controls',
                          style: GoogleFonts.ultra(
                            textStyle: const TextStyle(
                              color: Color.fromARGB(255, 72, 52, 52),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(
                              Icons.admin_panel_settings,
                              color: Color.fromARGB(255, 255, 243, 228),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdminListPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 107, 79, 79),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            label: Text(
                              'Admin Dashboard',
                              style: GoogleFonts.rakkas(
                                textStyle: const TextStyle(
                                  color: Color.fromARGB(255, 255, 243, 228),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Achievements card
            Container(
              width: cardWidth,
              child: Card(
                color: const Color.fromARGB(255, 250, 235, 215),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'My Achievements',
                            style: GoogleFonts.ultra(
                              textStyle: const TextStyle(
                                color: Color.fromARGB(255, 72, 52, 52),
                                fontSize: 16,
                              ),
                            ),
                          ),
                          // New achievement button
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 107, 79, 79),
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: Color.fromARGB(255, 255, 243, 228),
                                width: 2.0,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8.0),
                                onTap: _navigateToAchievementsPage,
                                child: Center(
                                  child: Icon(
                                    Icons.emoji_events,
                                    color: Color.fromARGB(255, 255, 243, 228),
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Consumer<ApplicationState>(
                        builder: (context, appState, _) {
                          if (appState.visitedPlaces.isEmpty) {
                            return Text(
                              'You haven\'t visited any historical sites yet.',
                              style: GoogleFonts.rakkas(
                                textStyle: const TextStyle(
                                  color: Color.fromARGB(255, 107, 79, 79),
                                  fontSize: 14,
                                ),
                              ),
                            );
                          }

                          return Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: appState.visitedPlaces.map((place) {
                              return Chip(
                                backgroundColor: Colors.green[100],
                                avatar: Icon(
                                  Icons.emoji_events,
                                  color: Colors.green,
                                  size: 18,
                                ),
                                label: Text(
                                  place,
                                  style: GoogleFonts.rakkas(
                                    textStyle: const TextStyle(
                                      color: Color.fromARGB(255, 72, 52, 52),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                side: BorderSide(color: Colors.green),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Password card
            Container(
              width: cardWidth,
              child: Card(
                color: const Color.fromARGB(255, 250, 235, 215),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Change Password',
                          style: GoogleFonts.ultra(
                            textStyle: const TextStyle(
                              color: Color.fromARGB(255, 72, 52, 52),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _currentPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Current Password',
                            labelStyle: GoogleFonts.rakkas(
                              textStyle: const TextStyle(
                                color: Color.fromARGB(255, 107, 79, 79),
                              ),
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your current password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _newPasswordController,
                          decoration: InputDecoration(
                            labelText: 'New Password',
                            labelStyle: GoogleFonts.rakkas(
                              textStyle: const TextStyle(
                                color: Color.fromARGB(255, 107, 79, 79),
                              ),
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a new password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Confirm New Password',
                            labelStyle: GoogleFonts.rakkas(
                              textStyle: const TextStyle(
                                color: Color.fromARGB(255, 107, 79, 79),
                              ),
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value != _newPasswordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        if (_errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _changePassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 107, 79, 79),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator()
                                : Text(
                                    'Update Password',
                                    style: GoogleFonts.rakkas(
                                      textStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 243, 228),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Logout card
            Container(
              width: cardWidth,
              child: Card(
                color: const Color.fromARGB(255, 250, 235, 215),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account Actions',
                        style: GoogleFonts.ultra(
                          textStyle: const TextStyle(
                            color: Color.fromARGB(255, 72, 52, 52),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(
                            Icons.logout,
                            color: Color.fromARGB(255, 255, 243, 228),
                          ),
                          onPressed: () async {
                            // Show confirmation dialog
                            final bool? shouldLogout = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor:
                                      const Color.fromARGB(255, 238, 214, 196),
                                  title: Text(
                                    'Logout',
                                    style: GoogleFonts.ultra(
                                      textStyle: const TextStyle(
                                        color: Color.fromARGB(255, 107, 79, 79),
                                      ),
                                    ),
                                  ),
                                  content: Text(
                                    'Are you sure you want to logout?',
                                    style: GoogleFonts.rakkas(
                                      textStyle: const TextStyle(
                                        color: Color.fromARGB(255, 107, 79, 79),
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text(
                                        'Cancel',
                                        style: GoogleFonts.rakkas(
                                          textStyle: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 107, 79, 79),
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: Text(
                                        'Logout',
                                        style: GoogleFonts.rakkas(
                                          textStyle: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 107, 79, 79),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (shouldLogout == true) {
                              await FirebaseAuth.instance.signOut();
                              if (mounted) {
                                // Navigate to login page and clear the navigation stack
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  AppRouter.loginPage,
                                  (route) => false,
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 107, 79, 79),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          label: Text(
                            'Log Out',
                            style: GoogleFonts.rakkas(
                              textStyle: const TextStyle(
                                color: Color.fromARGB(255, 255, 243, 228),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
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

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
