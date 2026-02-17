import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class ProfileHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 30);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );
    
    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 60);
    var secondEndPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );
    
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isDarkMode = false;
  final AuthService _authService = AuthService();
  
  String username = "Loading...";
  String email = "";
  String profileImage = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // โหลดข้อมูล User จาก Firebase
  Future<void> _loadUserData() async {
    try {
      final user = _authService.currentUser;
      if (user != null) {
        final userData = await _authService.getUserData(user.uid);
        
        setState(() {
          username = userData?['username'] ?? user.displayName ?? "User";
          email = user.email ?? "";
          profileImage = userData?['profileImage'] ?? "";
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        username = "User";
      });
    }
  }

  // ฟังก์ชัน Logout
  Future<void> _handleLogout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? const Color(0xFF16213e) : Colors.white,
        title: Row(
          children: [
            const Icon(Icons.logout, color: Colors.red),
            const SizedBox(width: 10),
            Text(
              'Logout',
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
            ),
          ],
        ),
        content: Text(
          'คุณต้องการออกจากระบบใช่หรือไม่?',
          style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _authService.signOut();
                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('ไม่สามารถออกจากระบบได้: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('ออกจากระบบ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: isDarkMode ? const Color(0xFF1a1a2e) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Profile", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                isDarkMode = !isDarkMode;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ClipPath(
                  clipper: ProfileHeaderClipper(),
                  child: Container(
                    height: 220,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDarkMode
                            ? [const Color(0xFF16213e), const Color(0xFF0f3460)]
                            : [const Color(0xFF4A90E2), const Color(0xFF0f3460)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50.0,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 47.0,
                          backgroundImage: profileImage.isNotEmpty
                              ? NetworkImage(profileImage)
                              : const NetworkImage(
                                  'https://pbs.twimg.com/media/G-NAI3qaYAA2UEK?format=jpg&name=900x900',
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: isDarkMode ? const Color(0xFF4A90E2) : const Color(0xFF4A90E2),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.edit, color: Colors.white, size: 16.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                print("User Name clicked");
              },
              child: Text(
                username,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              email,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white60 : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? const Color(0xFF4A90E2) : const Color(0xFF4A90E2),
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              onPressed: () {},
              child: const Text(
                "Edit Profile",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 50),
            _buildListTile(
              icon: Icons.person_2_rounded,
              title: "My Profile",
              isDarkMode: isDarkMode,
              onTap: () {
                print("My Profile clicked");
              },
            ),
            const SizedBox(height: 15),
            _buildListTile(
              icon: Icons.mail_rounded,
              title: "Messages",
              isDarkMode: isDarkMode,
              onTap: () {
                print("Messages clicked");
              },
            ),
            const SizedBox(height: 15),
            _buildListTile(
              icon: Icons.favorite_rounded,
              title: "Favourites",
              isDarkMode: isDarkMode,
              onTap: () {
                print("Favourites clicked");
              },
            ),
            const SizedBox(height: 15),
            _buildListTile(
              icon: Icons.location_on_rounded,
              title: "Location",
              isDarkMode: isDarkMode,
              onTap: () {
                print("Location clicked");
              },
            ),
            const SizedBox(height: 15),
            _buildListTile(
              icon: Icons.settings_rounded,
              title: "Settings",
              isDarkMode: isDarkMode,
              onTap: () {
                print("Settings clicked");
              },
            ),
            const SizedBox(height: 30),
            Divider(color: isDarkMode ? Colors.grey[800] : Colors.grey[300]),
            InkWell(
              onTap: _handleLogout,
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 177, 177),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: const Icon(Icons.logout_rounded, color: Colors.white, size: 20.0),
                ),
                title: const Text(
                  "Log out",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF16213e) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color(0xFF0f3460)
                    : const Color(0xFFD6E9FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isDarkMode ? const Color(0xFF4A90E2) : const Color(0xFF4A90E2),
                size: 20.0,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color(0xFF0f3460)
                    : const Color(0xFFF0F4FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: isDarkMode ? Colors.white54 : Colors.grey[400],
                size: 14.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}