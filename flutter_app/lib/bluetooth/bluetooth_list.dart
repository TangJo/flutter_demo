import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class NearbyBluetoothList extends StatefulWidget {
  @override
  _NearbyBluetoothList createState() => _NearbyBluetoothList();
}

class _NearbyBluetoothList extends State<NearbyBluetoothList> {
  List<String> devices = [];
  var isScanning = true;

  void refreshBluetoothList() {
    setState(() {});
  }

  _NearbyBluetoothList() {
    startScan();
  }

  void startScan() {
    isScanning = true;
    FlutterBlue.instance.stopScan().then((value) {
      FlutterBlue.instance
          .startScan(timeout: Duration(seconds: 4))
          .whenComplete(() {
        print("startScan Complete");
        isScanning = false;
        refreshBluetoothList();
      });
    });

    FlutterBlue.instance.scanResults.listen((results) {
      results.forEach((element) {
        print("startScan results:$element");
        devices.add(element.device.id.id);
        refreshBluetoothList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Row titleRow = new Row(
      children: [
        new Expanded(
          child: new IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/home");
              },
              iconSize: 16,
              icon: ImageIcon(AssetImage("images/icon_back.png"))),
          flex: 1,
        ),
        new Expanded(
            child: new Center(
              child: new Text("Nearby Bluetooth"),
            ),
            flex: 8),
        new Expanded(
          child: new IconButton(
              onPressed: () {
                devices.clear();
                startScan();
              },
              iconSize: 16,
              color: Colors.blue,
              icon: ImageIcon(AssetImage("images/icon_refresh.png"))),
          flex: 1,
        ),
      ],
    );

    Container topView = new Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      height: 45,
      child: titleRow,
    );

    Container centerView = new Container(
        height: 40,
        //73000000
        color: Color.fromARGB(5, 0, 0, 0),
        child: new Container(
          margin: EdgeInsets.only(left: 10, top: 8),
          child: new Row(
            children: [
              new Text(
                "Holster Bluetooth",
                style: TextStyle(color: Color.fromARGB(73, 0, 0, 0)),
              ),
              new Container(
                margin: EdgeInsets.only(left: 5),
                child: isScanning
                    ? new Image.asset(
                        'images/icon_loading.png',
                        width: 12,
                        height: 12,
                      )
                    : new Text(""),
              )
            ],
          ),
        ));

    MaterialButton connectButton = new MaterialButton(
      textColor: Colors.white,
      color: Colors.blueAccent,
      height: 28,
      minWidth: 30,
      //圆角
      shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(50))),
      onPressed: () {
        Navigator.of(context).pushNamed("/home");
      },
      child: new Text("CONNECT"),
    );

    Widget buildListData(String title) {
      return new ListTile(
        title: new Text(title,
            style: new TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12.0,
                color: Color.fromARGB(88, 0, 0, 0))),
        leading: new Image.asset(
          "images/icon_holster.png",
          height: 15,
          width: 15,
        ),
        trailing: connectButton,
      );
    }

    List<Widget> list = <Widget>[];

    devices.forEach((element) {
      print("devices name:$element");
      list.add(buildListData(element.toString()));
    });

    var divideTiles =
        ListTile.divideTiles(context: context, tiles: list).toList();

    ListView listView = new ListView(
      children: divideTiles,
    );

    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
        child: SafeArea(
          top: true,
          child: Offstage(),
        ),
      ),
      body: new Column(
        children: [
          topView,
          Divider(
            height: 0.5,
            //是控件的高，并不是线的高度，绘制的线居中。
            thickness: 1,
            //线的高度
            color: Color.fromARGB(73, 0, 0, 0),
          ),
          centerView,
          new Expanded(child: listView)
        ],
      ),
    );
  }
}
