import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:ncue_app/src/features/basic/icon_route.dart';
import 'package:ncue_app/src/features/basic/route_view.dart';
import 'package:ncue_app/src/features/basic/sign_in_view.dart';
import 'package:ncue_app/src/features/settings/settings_view.dart';
import 'package:ncue_app/src/features/user/user_model.dart';
import 'package:ncue_app/src/features/user/user_service.dart';

class ProfileView extends RouteView {
  const ProfileView({super.key})
      : super(routeName: '/profile', routeIcon: Icons.account_circle);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  User? user = FirebaseAuth.instance.currentUser;

  String name = "";
  String type = "";
  String uuid = "";

  void load() async {
    UserModel model = await UserService().loadUserData();
    name = model.name;
    type = model.type;
    uuid = model.uuid;
    setState(() {});
  }

  @override
  void initState() {
    load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProfileScreen(
      appBar: AppBar(
        backgroundColor: Colors.red,
      ),
      actions: [
        SignedOutAction((context) {
          Navigator.pushReplacementNamed(context, const SignInView().routeName);
        })
      ],
      children: [
        const Align(
          alignment: Alignment.centerRight,
          child: IconRoute(routeView: SettingsView()),
        ),
        Text("name: $name"),
        Text("uuid: $uuid"),
        Text("type: $type"),
      ],
    );
  }
}
