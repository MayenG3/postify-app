import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:postify_app/controllers/profile_controller.dart';
import 'package:postify_app/widgets/profile/logout_dialog.dart';
import 'package:postify_app/widgets/profile/profile_header.dart';
import 'package:postify_app/widgets/profile/profile_item.dart';
import 'package:postify_app/services/user_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final int userId;
  
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final client = GraphQLProvider.of(context).value;
    _controller = ProfileController(
      userService: UserService(client: client),
    );
    _controller.fetchUserData(context, widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Perfil',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.red),
              onPressed: () => _showLogoutDialog(context),
            ),
          ],
        ),
        body: Consumer<ProfileController>(
          builder: (context, controller, _) {
            if (controller.isLoading || controller.userData == null) {
              return const Center(child: CircularProgressIndicator());
            }
            
            return RefreshIndicator(
              onRefresh: () => controller.fetchUserData(context, widget.userId),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    ProfileHeader(
                      profilePic: controller.userData!['profile_pic'],
                      name: '${controller.userData!['name']} ${controller.userData!['lastname']}',
                      username: '@${controller.userData!['username']}',
                    ),
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ProfileItem(
                            title: 'Nombre',
                            value: controller.userData!['name'],
                            icon: Icons.person,
                            onEdit: () => controller.editField(
                              context: context,
                              userId: widget.userId,
                              field: 'name',
                              currentValue: controller.userData!['name'],
                            ),
                          ),
                          ProfileItem(
                            title: 'Apellido',
                            value: controller.userData!['lastname'],
                            icon: Icons.person,
                            onEdit: () => controller.editField(
                              context: context,
                              userId: widget.userId,
                              field: 'lastname',
                              currentValue: controller.userData!['lastname'],
                            ),
                            isLast: false,
                          ),
                          ProfileItem(
                            title: 'Usuario',
                            value: controller.userData!['username'],
                            icon: Icons.alternate_email,
                            onEdit: () => controller.editField(
                              context: context,
                              userId: widget.userId,
                              field: 'username',
                              currentValue: controller.userData!['username'],
                            ),
                            isLast: false,
                          ),
                          ProfileItem(
                            title: 'Correo electrónico',
                            value: controller.userData!['email'],
                            icon: Icons.email,
                            onEdit: () => controller.editField(
                              context: context,
                              userId: widget.userId,
                              field: 'email',
                              currentValue: controller.userData!['email'],
                            ),
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => LogoutDialog(
        onConfirm: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false,
          );
        },
      ),
    );
  }
}