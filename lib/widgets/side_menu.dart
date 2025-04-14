import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vas/controllers/login_controller.dart';
import 'package:vas/controllers/trip_from_controller.dart';
import 'package:vas/widgets/trip_details_widget.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  String? token;
  String? employeeId;
  String? name;
  String? roleId;

  final LoginController loginController  = LoginController();
  TripController tripController = Get.find<TripController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      employeeId = prefs.getString("employeeId");
      name = prefs.getString("name");
      roleId = prefs.getString("roleId");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
           UserAccountsDrawerHeader(

            decoration: const BoxDecoration(color: Colors.blue),
            accountName: Text(name??'', style: const TextStyle(fontSize: 18)),
            accountEmail: null,
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.blue),
            ),
          ),
          _buildExpandableTile("Dashboard ", [
            _buildSubMenuItem("Post Data Testing", Icons.arrow_right, () {})
          ]),
          _buildExpandableTile("Settings ", [
            _buildSubMenuItem("Master Data", Icons.arrow_right, () {
              Navigator.pop(context); // Close drawer
              Navigator.pushNamed(context, '/master_data_screen'); // N
            })
          ]),
          _buildExpandableTile("Management ", [
            _buildSubMenuItem("Change Password", Icons.arrow_right, () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/change_password');
            })
          ]),
          _buildExpandableTile("Fuel ", [
            _buildSubMenuItem("Generate Fuel Entry Ticket", Icons.arrow_right, () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/fuel_ticket_entry_screen');
            })
          ]),
          _buildExpandableTile("Cases ", [
            _buildSubMenuItem("Login Report Self", Icons.arrow_right, () {
              Navigator.pushNamed(context, '/login_report_screen'); // N

            }),
            // _buildSubMenuItem("Live Case ", Icons.arrow_right, () {}),
            _buildSubMenuItem("Manage Trip ", Icons.arrow_right, () {
              Navigator.pop(context); // Close drawer

              if (tripController.tripStatus.value==1){
                Navigator.pushNamed(context, '/manage_trip_arrival_departure_close_screen'); // N

             }else{
               Navigator.pushNamed(context, '/manage_trip'); // N
             }

            }),
            // _buildSubMenuItem("Live Case ", Icons.arrow_right, () {}),
            // _buildSubMenuItem("Case Registration ", Icons.arrow_right, () {}),
            _buildSubMenuItem("Case Registration New", Icons.arrow_right, () {
              Navigator.pop(context); // Close drawer
              Navigator.pushNamed(context, '/case_registration_new'); // N
            }),
          ]),
          ListTile(
            title: const Text("FAQ"),
            onTap: () {},
          ),
          ListTile(
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            leading: const Icon(Icons.logout, color: Colors.red),
            onTap: loginController.logoutUser,
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableTile(String title, List<Widget> children) {
    return ExpansionTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      leading: const Icon(Icons.arrow_forward_ios, size: 18),
      children: children,
    );
  }

  Widget _buildSubMenuItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, size: 18,color: Colors.transparent,),
      title: Text(title),
      onTap: onTap,
    );
  }
}
