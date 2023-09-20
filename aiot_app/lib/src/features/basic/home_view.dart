import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/sensors/sensorsapp.dart';

import '../auth_system/profile_view.dart';
import '../bluetooth/flutterblueapp.dart';
import '../devices/add_device_view.dart';
import '../devices/device_model.dart';
import '../devices/device_service.dart';
import '../mqtt/mqttapp.dart';
import '../settings/settings_view.dart';
import '../item_system/data_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../user/user_model.dart';
import '../user/user_service.dart';
import '../web_view/webview.dart';
import 'route_view.dart';
import 'unit.dart';

class Home extends RouteView {
  const Home({super.key}) : super(routeName: '/home', routeIcon: Icons.home);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<DataItem> items = [];
  UserModel model = UserModel("error", "error");

  Future<void> loadDevices() async {
    items.clear();
    items.add(DataItem("addDevice", [const AddDeviceView(), model], "註冊裝置"));
    items.add(DataItem("route", [const MqttPage()], "MQTT測試"));
    items.add(DataItem("route", [const SensorsPage()], "感應器資料版"));
    items.add(DataItem("route", [const WebViewTest()], "網站版"));
    items.add(DataItem("mqtt", [], "mqtt"));
    List x = [];
    for (DeviceModel device in await DeviceService().loadDeviceData()) {
      if (model.devices.contains(device.uuid)) {
        setState(() {
          x.add(device);
          // items.add(device.toDataItem());
        });
      }
    }

    items.add(DataItem("extend", x, "集合"));
  }

  Future<void> loadAccount() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      model = await UserService().loadUserData(user);
    }
  }

  @override
  void initState() {
    reload();
    super.initState();
  }

  Future<void> reload() async {
    await loadAccount();
    await loadDevices();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${AppLocalizations.of(context)!.appTitle} ${AppLocalizations.of(context)?.localeName.toString() ?? "sss"}"),
        actions: [
          const SettingsView().getIconButton(context),
          const BluetoothView().getIconButton(context),
        ],
      ),
      drawer: const Drawer(child: ProfileView()),
      body: RefreshIndicator(
        onRefresh: () => reload(),
        child: ListView.builder(
          restorationId: 'sampleItemListView',
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            DataItem item = items[index];
            return
                // Dismissible(
                //   key: ValueKey(item),
                //   direction: DismissDirection.endToStart,
                //   onDismissed: (direction) async {
                //     SoundPlayer().play("crystal");
                //   },
                //   child:
                Unit(item: item);
            // );
          },
        ),
      ),
    );
  }
}
