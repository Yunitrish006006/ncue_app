import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/models/room_model.dart';
import 'package:ncue.aiot_app/src/features/basic/units/type_tile.dart';
import 'package:ncue.aiot_app/src/features/devices/add_device_view.dart';

import '../basic/views/route_view.dart';

class RoomDetailsView extends RouteView {
  const RoomDetailsView({key})
      : super(key,
            routeName: '/room_detail_view',
            routeIcon: Icons.medical_information);

  @override
  State<RoomDetailsView> createState() => _DeviceDetailsViewState();
}

class _DeviceDetailsViewState extends State<RoomDetailsView> {
  List<Widget> items = [];
  RoomModel model = RoomModel();
  bool isFirstLoad = true;
  @override
  void initState() {
    super.initState();
  }

  Future<void> reload(BuildContext context) async {
    items.clear();
    Map<String, dynamic> arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    await RoomModel().read(arguments['data'] as String).then((room) async {
      items.add(Text(room.name));
      items.add(Text(room.uuid));
      items.add(TypeTile(
          name: "房間內裝置",
          children: (room.devices.map((e) => e.getUnit(context, () {
                setState(() {});
                room.update();
              }))).toList()));
      items.add(const AddDeviceView()
          .getUnit(context, data: {'data': room}, customName: "註冊裝置"));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isFirstLoad) {
      Future.delayed(const Duration(seconds: 1), () async {
        await reload(context).then((value) {
          setState(() {
            isFirstLoad = false;
          });
        });
      });
    }
    return Scaffold(
        appBar: AppBar(
          title: const FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(children: [
              Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text("房間內容", style: TextStyle(fontSize: 30)),
                ),
              )
            ]),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return Future.delayed(const Duration(seconds: 1), () async {
              await reload(context).then((value) {
                setState(() {});
              });
            });
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(20.0),
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: items[index],
              );
            },
          ),
        ));
  }
}
