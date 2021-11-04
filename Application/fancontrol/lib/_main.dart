import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:ping_discover_network/ping_discover_network.dart';
import 'package:gateway/gateway.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:wifi/wifi.dart';
import 'package:wifi_configuration/wifi_configuration.dart';

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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Điều Khiển Thiết Bị',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        title: 'Điều Khiển Thiết Bị',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameWIFI = new TextEditingController();
  TextEditingController passWIFI = new TextEditingController();
  TextEditingController nameEdit = new TextEditingController();
  TextEditingController passEdit = new TextEditingController();
  List<WifiResult> ssidList = [];
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
  int isPass = 0;
  String pass = "";
  bool truePass = false;
  double windLv = 0;
  bool changeWifi = false;
  bool isSet = false;
  connect2Esp() async {
    setState(() {
      loadText = "Đang kết nối";
      isLoad = true;
    });
    var response = await http.get("http://" + ip + "/inform");
    var status = await http.get("http://" + ip + "/status");
    setState(() {
      isLoad = false;
    });
    if (status.statusCode == 200) {
      var giaima_status = Utf8Decoder().convert(status.bodyBytes);
      var json_status = jsonDecode(giaima_status);
      json_status = json_status["data"];
      windLv = json_status["wind"].toDouble();
    }
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var giaima = Utf8Decoder().convert(response.bodyBytes);
      var json = jsonDecode(giaima);
      print("json:  ${json["data"]}");
      json = json["data"];
      // convert.jsonDecode(response.body);
      nameEquip = json['name'];
      isPass = json["isPass"];
      if (isPass == 0) {
        truePass = true;
      }

      isCn = true;
      return 1;
    } else {
      return 0;
    }
  }

  connect2Esp_noload() async {
    if (ip != "") {
      var response = await http.get("http://" + ip + "/inform");
      var status = await http.get("http://" + ip + "/status");

      if ((response.statusCode == 200) && ((status.statusCode == 200))) {
        var jsonResponse = jsonDecode(response.body);
        var giaima = Utf8Decoder().convert(response.bodyBytes);
        var json = jsonDecode(giaima);
        var giaima_status = Utf8Decoder().convert(status.bodyBytes);
        var json_status = jsonDecode(giaima_status);
        print(json_status);
        setState(() {
          json_status = json_status["data"];
          windLv = json_status["wind"].toDouble();
          json = json["data"];
          nameEquip = json['name'];
          isPass = json["isPass"];
        });
        return 1;
      } else {
        return 0;
      }
    }
  }

  updateData() {
    Timer.periodic(Duration(seconds: 1), (timer) async {
      await connect2Esp_noload();
    });
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

  void loadData() async {
    Wifi.list('').then((list) {
      setState(() {
        ssidList = list;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _checkIP();
    updateData();
    loadData();
  }

  setWind(int value) {
    var response = http.get("http://" + ip + "/wind?pass=&wind=${value}");
    // if (response.statusCode == 200) {
    //   print("ok");
    // } else {
    //   print("not ok");
    // }
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

  changeWifiFunc() async {
    if (nameWIFI.text != "") {
      var response = await http.get("http://" +
          ip +
          "/connect?pass=&nameW=${nameWIFI.text}&passW=${passWIFI.text}");
      if (response.statusCode == 200) {
        print(response.body);
        setState(() {
          changeWifi = false;
        });
      } else {
        print("not ok");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var boardInform = new Container(
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
                    icon: Icon(Icons.wifi, size: 10),
                    onPressed: () async {
                      setState(() {
                        changeWifi = !(changeWifi);
                      });
                    },
                    label: Text("Wifi", style: TextStyle(fontSize: 8)),
                    color: Colors.yellow[700],
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(50.0))),
              ),
              SizedBox(
                width: 75, // <-- match_parent
                height: 22,
                child: FlatButton.icon(
                    icon: Icon(Icons.power_off, size: 10),
                    onPressed: () {},
                    label: Text("Tắt Máy", style: TextStyle(fontSize: 8)),
                    color: Colors.red[700],
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
      boardInform,
      Container(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Bạn đang kết nối tới ${nameEquip}"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SleekCircularSlider(
                    initialValue: windLv,
                    appearance: CircularSliderAppearance(
                        infoProperties: InfoProperties(
                            bottomLabelText: "Tốc độ gió tối đa"),
                        customColors: CustomSliderColors(
                            trackColor: Colors.grey,
                            progressBarColor: Colors.blue)),
                    onChange: (double value) {
                      setWind(value.toInt());
                    }),
                Container(
                  height: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 150, // <-- match_parent
                        height: 50,
                        child: FlatButton.icon(
                            icon: Icon(Icons.ac_unit),
                            onPressed: () => turnMode(2),
                            label: Text("Gió Tự Nhiên"),
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(50.0))),
                      ),
                      SizedBox(
                        width: 150, // <-- match_parent
                        height: 50,
                        child: FlatButton.icon(
                            icon: Icon(Icons.timer),
                            onPressed: () => turnMode(3),
                            label: Text("Hẹn Giờ"),
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(50.0))),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100, // <-- match_parent
                  height: 50,
                  child: FlatButton.icon(
                      icon: Icon(Icons.ac_unit),
                      onPressed: () => setWind(30),
                      label: Text("30%"),
                      color: Colors.blue[100],
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(50.0))),
                ),
                SizedBox(
                  width: 100, // <-- match_parent
                  height: 50,
                  child: FlatButton.icon(
                      icon: Icon(Icons.ac_unit),
                      onPressed: () => setWind(60),
                      label: Text("60%"),
                      color: Colors.blue[100],
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(50.0))),
                ),
                SizedBox(
                  width: 100, // <-- match_parent
                  height: 50,
                  child: FlatButton.icon(
                      icon: Icon(Icons.ac_unit),
                      onPressed: () => setWind(90),
                      label: Text("90%"),
                      color: Colors.blue[100],
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(50.0))),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 100, // <-- match_parent
                  height: 50,
                  child: FlatButton.icon(
                      icon: Icon(Icons.ac_unit),
                      onPressed: () => setWind(0),
                      label: Text("OFF"),
                      color: Colors.red[100],
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(50.0))),
                ),
              ],
            )
          ],
        ),
      ),
      isEdit ? editName : Container(),
    ]);
    var passInput = new Container(
      child: Column(
        children: [
          Text("Nhập mật khẩu"),
          TextField(
            controller: passEdit,
            decoration: InputDecoration(hintText: "Nhập:"),
          )
        ],
      ),
    );
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
          ? truePass
              ? Stack(children: [
                  controlForm,
                  changeWifi
                      ? Center(
                          child: Stack(
                          children: [
                            Container(
                                height: 250,
                                width: 300,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Center(
                                    child: Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Kết Nối WIFI",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Container(
                                        width: 200,
                                        child: TextField(
                                          controller: nameWIFI,
                                          decoration: InputDecoration(
                                              hintText: "TÊN SSID"),
                                        ),
                                      ),
                                      Container(
                                        width: 200,
                                        child: TextField(
                                          controller: passWIFI,
                                          decoration: InputDecoration(
                                              hintText: "MẬT KHẨU SSID"),
                                        ),
                                      ),
                                      FlatButton(
                                          onPressed: changeWifiFunc,
                                          child: Text("Kết nối"))
                                    ],
                                  ),
                                ))),
                            Positioned(
                              child: CloseButton(
                                color: Colors.red,
                                onPressed: () {
                                  setState(() {
                                    changeWifi = false;
                                  });
                                },
                              ),
                            )
                          ],
                        ))
                      : SizedBox(),
                ])
              : passInput
          : Center(
              child: isLoad
                  ? bodyProgress
                  : Stack(children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
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
                    ])),
      floatingActionButton: FloatingActionButton(
        onPressed: _checkIP,
        tooltip: 'Làm mới',
        child: Icon(Icons.refresh_outlined),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
