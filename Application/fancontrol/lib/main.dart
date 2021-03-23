import 'package:fancontrol/wwmain.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:ping_discover_network/ping_discover_network.dart';
import 'package:gateway/gateway.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

void main() {
  runApp(MyApp());
}

Future printIps() async {
  for (var interface in await NetworkInterface.list()) {
    print('== Interface: ${interface.name} ==');
    for (var addr in interface.addresses) {
      print(
          '${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}');
    }
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Điều Khiển Thiết Bị',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Điều Khiển Thiết Bị'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameEdit = new TextEditingController();
  bool isEdit = false;
  bool isHaveIP = false;
  String ip = "";
  int _counter = 0;
  bool isLoad = false;
  bool isCnBtn = false;
  List<String> iplist = [""];
  String nameEquip = "";
  String loadText = "";
  bool isCn = false;

  connect2Esp() async {
    setState(() {
      loadText = "Đang kết nối";
      isLoad = true;
    });
    var response = await http.get("http://" + ip + "/inform");
    setState(() {
      isLoad = false;
    });
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var giaima = Utf8Decoder().convert(response.bodyBytes);
      var json = jsonDecode(giaima);
      print("json:  ${json}");
      // convert.jsonDecode(response.body);
      nameEquip = json['name'];
      print(nameEquip);
      isCn = true;
      return 1;
    } else {
      return 0;
    }
  }

  void _checkIP() async {
    setState(() {
      loadText = "Vui lòng chờ";
      isLoad = true;
    });
    isHaveIP = false;
    _counter = 0;
    isCnBtn = false;
    iplist = [""];
    nameEquip = "";
    isCn = false;
    ip = "";
    Gateway gt = await Gateway.info;
    print(gt.ip);
    const port = 80;
    String gateway = "";
    for (int i = 0; i < gt.ip.length - 2; i++) {
      gateway = gateway + gt.ip[i];
    }
    print(gateway);
    final stream0 = NetworkAnalyzer.discover2(
      gateway,
      port,
      timeout: Duration(milliseconds: 5000),
    );
    int found = 0;
    stream0.listen((NetworkAddress addr) {
      //print('${addr.ip}:$port');
      if (addr.exists) {
        found++;
        print('Found device: ${addr.ip}:$port');
        if (iplist.contains(addr.ip)) {
          print("Trùng");
        } else {
          iplist.add(addr.ip);
        }
      }
    }).onDone(() {
      print('Finish. Found $found device(s)');
      setState(() {
        isLoad = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _checkIP();
  }

  turnMode(int value) async {
    var response = await http
        .get("http://" + ip + "/control?key=${nameEquip}&equip=${value}");
    if (response.statusCode == 200) {
      print("ok");
    } else {
      print("not ok");
    }
  }

  changeName() async {
    var response = await http
        .get("http://" + ip + "/edit?key=${nameEquip}&name=${nameEdit.text}");
    if (response.statusCode == 200) {
      print("ok");
    } else {
      print("not ok");
    }
    connect2Esp();
    setState(() {
      isEdit = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var boardInform = new Container(
        width: 300,
        margin: const EdgeInsets.all(30.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(width: 3.0),
          borderRadius: BorderRadius.all(
              Radius.circular(30.0) //                 <--- border radius here
              ),
        ),
        child: Column(children: [
          Text(
            "Tên thiết bị: $nameEquip",
            style: TextStyle(fontSize: 15.0),
          ),
          Text(
            "IP thiết bị: $ip",
            style: TextStyle(fontSize: 15.0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 75, // <-- match_parent
                height: 22,
                child: FlatButton.icon(
                    icon: Icon(Icons.edit, size: 10),
                    onPressed: () {
                      setState(() {
                        isEdit = !(isEdit);
                        print(isEdit);
                      });
                    },
                    label: Text("Đổi tên", style: TextStyle(fontSize: 8)),
                    color: Colors.yellow[700],
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(50.0))),
              ),
              SizedBox(
                width: 75, // <-- match_parent
                height: 22,
                child: FlatButton.icon(
                    icon: Icon(Icons.restore, size: 10),
                    onPressed: () {},
                    label: Text("Restart", style: TextStyle(fontSize: 8)),
                    color: Colors.yellow[700],
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(50.0))),
              ),
            ],
          )
        ]));
    var editName = new Stack(
      children: [
        Column(
          children: [
            Container(
                width: 200,
                child: TextField(
                  controller: nameEdit,
                  decoration: InputDecoration(hintText: 'Tên mới'),
                )),
            SizedBox(
              width: 65, // <-- match_parent
              height: 22,
              child: FlatButton.icon(
                  icon: Icon(Icons.edit_outlined, size: 10),
                  onPressed: changeName,
                  label: Text("Đổi", style: TextStyle(fontSize: 8)),
                  color: Colors.red[700],
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(50.0))),
            ),
          ],
        )
      ],
    );
    var controlForm = new Column(children: [
      Container(
        height: 240,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Bạn đang kết nối tới ${nameEquip}"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 150, // <-- match_parent
                  height: 50,
                  child: FlatButton.icon(
                      icon: Icon(Icons.looks_one_outlined),
                      onPressed: () => turnMode(1),
                      label: Text("Chế độ 1"),
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(50.0))),
                ),
                SizedBox(
                  width: 150, // <-- match_parent
                  height: 50,
                  child: FlatButton.icon(
                      icon: Icon(Icons.looks_two_outlined),
                      onPressed: () => turnMode(2),
                      label: Text("Chế độ 2"),
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(50.0))),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 150, // <-- match_parent
                  height: 50,
                  child: FlatButton.icon(
                      icon: Icon(Icons.looks_3_outlined),
                      onPressed: () => turnMode(3),
                      label: Text("Chế độ 3"),
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(50.0))),
                ),
                SizedBox(
                  width: 150, // <-- match_parent
                  height: 50,
                  child: FlatButton.icon(
                      icon: Icon(Icons.looks_4_outlined),
                      onPressed: () => turnMode(4),
                      label: Text("Chế độ 4"),
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(50.0))),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120, // <-- match_parent
                  height: 50,
                  child: FlatButton.icon(
                      icon: Icon(Icons.offline_bolt_outlined),
                      onPressed: () => turnMode(0),
                      label: Text("Turn Off"),
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(50.0))),
                ),
              ],
            ),
          ],
        ),
      ),
      boardInform,
      isEdit ? editName : Container(),
    ]);

    var bodyProgress = new Container(
      child: new Stack(
        children: <Widget>[
          new Container(
            alignment: AlignmentDirectional.center,
            decoration: new BoxDecoration(
              color: Colors.white70,
            ),
            child: new Container(
              decoration: new BoxDecoration(
                  color: Colors.transparent, //blue[200],
                  borderRadius: new BorderRadius.circular(10.0)),
              width: 300.0,
              height: 200.0,
              alignment: AlignmentDirectional.center,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Center(
                    child: new SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: new CircularProgressIndicator(
                        value: null,
                        strokeWidth: 7.0,
                      ),
                    ),
                  ),
                  new Container(
                    margin: const EdgeInsets.only(top: 25.0),
                    child: new Center(
                      child: new Text(
                        loadText,
                        style: new TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: isCn
          ? controlForm
          : Center(
              child: isLoad
                  ? bodyProgress
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SleekCircularSlider(
                            appearance: CircularSliderAppearance(),
                            onChange: (double value) {
                              print(value);
                            }),
                        Text(
                          'Thiết bị bạn đang kết nối:',
                        ),
                        new DropdownButton<String>(
                          items: iplist.map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != "") {
                              isCnBtn = true;
                            } else if (val.length < 3) {
                              isCnBtn = false;
                            } else {
                              isCnBtn = false;
                            }
                            setState(() {
                              ip = val;
                            });
                          },
                          value: ip,
                        ),
                        isCnBtn
                            ? FlatButton.icon(
                                onPressed: connect2Esp,
                                icon: Icon(Icons.connected_tv),
                                label: Text("Kết nối"))
                            : Text("Vui lòng chọn thiết bị"),
                      ],
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _checkIP,
        tooltip: 'Làm mới',
        child: Icon(Icons.refresh_outlined),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
