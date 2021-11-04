import 'dart:convert';
import 'dart:io';
import 'dart:math';
// import 'package:fancontrol/function.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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

var mode = "Chế Độ Bình Thường";
var wifiName = "Null";

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 1;
  var ip = "192.168.4.1";
  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  Color BgColor(int index) {
    if (index == selectedIndex) {
      return Colors.white;
    }
    return Colors.black;
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  sendUdp(String ip, String dataString) {
    int port = 20001;
    RawDatagramSocket.bind(InternetAddress.anyIPv4, port).then((socket) {
      socket.send(Utf8Codec().encode(dataString), InternetAddress(ip), port);
      socket.listen((event) {
        if (event == RawSocketEvent.write) {
          socket.close();
          print("single closed");
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var title =
        new Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Smart Fan",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Text(
            "Vì cuộc sống hiện đại",
            style: TextStyle(
                fontSize: 17, color: Colors.grey, fontWeight: FontWeight.bold),
          )
        ],
      ),
      Icon(
        Icons.wifi,
        color: Colors.blue,
      ),
    ]);
    var normalMode = new Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RaisedButton(
              color: Colors.blue,
              onPressed: () {
                sendUdp(ip, "<SPEED<25");
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0)),
              padding: const EdgeInsets.all(0.0),
              child: Ink(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100.0)),
                ),
                child: Container(
                    padding: EdgeInsets.all(2),
                    width: MediaQuery.of(context).size.width / 2 / 3,
                    height: MediaQuery.of(context).size.height / 20,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Icon(
                          Icons.looks_one_rounded,
                          size: MediaQuery.of(context).size.width / 25,
                          color: Colors.black,
                        ),
                        Text(
                          'Mức 1',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 40,
                              color: Colors.black),
                        ),
                      ],
                    )),
              ),
            ),
            RaisedButton(
              color: Colors.blue,
              onPressed: () {
                sendUdp(ip, "<SPEED<50");
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0)),
              padding: const EdgeInsets.all(0.0),
              child: Ink(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100.0)),
                ),
                child: Container(
                    padding: EdgeInsets.all(2),
                    width: MediaQuery.of(context).size.width / 2 / 3,
                    height: MediaQuery.of(context).size.height / 20,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Icon(
                          Icons.looks_two_rounded,
                          size: MediaQuery.of(context).size.width / 25,
                          color: Colors.black,
                        ),
                        Text(
                          'Mức 2',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 40,
                              color: Colors.black),
                        ),
                      ],
                    )),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RaisedButton(
              color: Colors.blue,
              onPressed: () {
                sendUdp(ip, "<SPEED<75");
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0)),
              padding: const EdgeInsets.all(0.0),
              child: Ink(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100.0)),
                ),
                child: Container(
                    padding: EdgeInsets.all(2),
                    width: MediaQuery.of(context).size.width / 2 / 3,
                    height: MediaQuery.of(context).size.height / 20,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Icon(
                          Icons.looks_3,
                          size: MediaQuery.of(context).size.width / 25,
                          color: Colors.black,
                        ),
                        Text(
                          'Mức 3',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 40,
                              color: Colors.black),
                        ),
                      ],
                    )),
              ),
            ),
            RaisedButton(
              color: Colors.blue,
              onPressed: () {
                sendUdp(ip, "<SPEED<100");
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0)),
              padding: const EdgeInsets.all(0.0),
              child: Ink(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100.0)),
                ),
                child: Container(
                    padding: EdgeInsets.all(2),
                    width: MediaQuery.of(context).size.width / 2 / 3,
                    height: MediaQuery.of(context).size.height / 20,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Icon(
                          Icons.looks_4,
                          size: MediaQuery.of(context).size.width / 25,
                          color: Colors.black,
                        ),
                        Text(
                          'Mức 4',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 40,
                              color: Colors.black),
                        ),
                      ],
                    )),
              ),
            ),
          ],
        )
      ],
    );
    var timerMode = new Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RaisedButton(
              color: Colors.blue,
              onPressed: () {
                sendUdp(ip, "<TIMER<30");
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0)),
              padding: const EdgeInsets.all(0.0),
              child: Ink(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100.0)),
                ),
                child: Container(
                    padding: EdgeInsets.all(2),
                    width: MediaQuery.of(context).size.width / 2 / 3,
                    height: MediaQuery.of(context).size.height / 20,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Icon(
                          Icons.more_time_rounded,
                          size: MediaQuery.of(context).size.width / 25,
                          color: Colors.black,
                        ),
                        Text(
                          '30p',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 40,
                              color: Colors.black),
                        ),
                      ],
                    )),
              ),
            ),
            RaisedButton(
              color: Colors.blue,
              onPressed: () {
                sendUdp(ip, "<TIMER<60");
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0)),
              padding: const EdgeInsets.all(0.0),
              child: Ink(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100.0)),
                ),
                child: Container(
                    padding: EdgeInsets.all(2),
                    width: MediaQuery.of(context).size.width / 2 / 3,
                    height: MediaQuery.of(context).size.height / 20,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Icon(
                          Icons.more_time_rounded,
                          size: MediaQuery.of(context).size.width / 25,
                          color: Colors.black,
                        ),
                        Text(
                          '1h',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 40,
                              color: Colors.black),
                        ),
                      ],
                    )),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RaisedButton(
              color: Colors.blue,
              onPressed: () {
                sendUdp(ip, "<TIMER<120");
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0)),
              padding: const EdgeInsets.all(0.0),
              child: Ink(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100.0)),
                ),
                child: Container(
                    padding: EdgeInsets.all(2),
                    width: MediaQuery.of(context).size.width / 2 / 3,
                    height: MediaQuery.of(context).size.height / 20,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Icon(
                          Icons.more_time_rounded,
                          size: MediaQuery.of(context).size.width / 25,
                          color: Colors.black,
                        ),
                        Text(
                          '2h',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 40,
                              color: Colors.black),
                        ),
                      ],
                    )),
              ),
            ),
            RaisedButton(
              color: Colors.blue,
              onPressed: () {
                sendUdp(ip, "<TIMER<240");
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0)),
              padding: const EdgeInsets.all(0.0),
              child: Ink(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100.0)),
                ),
                child: Container(
                    padding: EdgeInsets.all(2),
                    width: MediaQuery.of(context).size.width / 2 / 3,
                    height: MediaQuery.of(context).size.height / 20,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Icon(
                          Icons.more_time_rounded,
                          size: MediaQuery.of(context).size.width / 25,
                          color: Colors.black,
                        ),
                        Text(
                          '4h',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 40,
                              color: Colors.black),
                        ),
                      ],
                    )),
              ),
            ),
          ],
        )
      ],
    );
    var modeBtn = new Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        FlatButton(
          minWidth: MediaQuery.of(context).size.width / 3.2,
          height: MediaQuery.of(context).size.width / 3.2,
          color: Colors.blue,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(40.0)),
          child: Column(
            children: [
              Icon(
                Icons.grass,
                color: Colors.white,
                size: MediaQuery.of(context).size.width / 15,
              ),
              Text(
                "Gió tự nhiên",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width / 30),
              )
            ],
          ),
          onPressed: () {
            sendUdp(ip, "<MODE<NATURALWIND");
          },
        ),
        FlatButton(
          minWidth: MediaQuery.of(context).size.width / 3.2,
          height: MediaQuery.of(context).size.width / 3.2,
          color: Colors.blue,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(40.0)),
          child: Column(
            children: [
              Icon(
                Icons.control_camera_sharp,
                color: Colors.white,
                size: MediaQuery.of(context).size.width / 15,
              ),
              Text(
                "Bình thường",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width / 30),
              )
            ],
          ),
          onPressed: () {
            sendUdp(ip, "<MODE<NORMALWIND");
          },
        ),
        FlatButton(
          minWidth: MediaQuery.of(context).size.width / 3.2,
          height: MediaQuery.of(context).size.width / 3.2,
          color: Colors.blue,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(40.0)),
          child: Column(
            children: [
              Icon(
                Icons.timer,
                color: Colors.white,
                size: MediaQuery.of(context).size.width / 15,
              ),
              Text(
                "Hẹn giờ",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width / 30),
              )
            ],
          ),
          onPressed: () {
            sendUdp(ip, "<MODE<TIMER");
          },
        )
      ],
    );
    var screenInform = Column(children: [
      Container(
          width: MediaQuery.of(context).size.width / 1.1,
          height: MediaQuery.of(context).size.height / 8,
          margin: EdgeInsets.only(bottom: 10, top: 10),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.white,
              // border: Border.all(
              //     color: Colors.blue, // Set border color
              //     width: 3.0),
              borderRadius: BorderRadius.all(
                  Radius.circular(40.0)), // Set rounded corner radius
              boxShadow: [
                BoxShadow(blurRadius: 10, offset: Offset(1, 3))
              ] // Make rounded corner of border
              ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "IP: ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${ip}",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Chế Độ: ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${mode}",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Wifi: ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${wifiName}",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ],
          ))
    ]);
    var power = new Row(
      children: [
        RaisedButton(
          color: Colors.red,
          onPressed: () {
            sendUdp(ip, "<POWER<1");
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
          padding: const EdgeInsets.all(0.0),
          child: Ink(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100.0)),
            ),
            child: Container(
                padding: EdgeInsets.all(2),
                width: MediaQuery.of(context).size.width / 2 / 3,
                height: MediaQuery.of(context).size.height / 20,
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Icon(
                      Icons.power_settings_new,
                      size: MediaQuery.of(context).size.width / 25,
                      color: Colors.white,
                    ),
                    Text(
                      'Nguồn',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 40,
                          color: Colors.white),
                    ),
                  ],
                )),
          ),
        )
      ],
    );
    var changeSpeedWind =
        new Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Container(
          width: MediaQuery.of(context).size.width / 1.7,
          padding: EdgeInsets.only(top: 50),
          child: SleekCircularSlider(
              initialValue: 0,
              min: 0,
              max: 100,
              appearance: CircularSliderAppearance(
                  size: MediaQuery.of(context).size.width / 2,
                  infoProperties: InfoProperties(
                    bottomLabelText: "Tốc Độ",
                    bottomLabelStyle:
                        TextStyle(color: Colors.blue, fontSize: 30),
                  ),
                  customColors: CustomSliderColors(
                      dotColor: Colors.blue,
                      hideShadow: true,
                      trackColor: Colors.grey[200],
                      progressBarColor: Colors.blue)),
              onChange: (double value) {
                int giatri = value.ceil();
                if (value > 100) {
                  giatri = 100;
                } else if (value < 0) {
                  giatri = 0;
                }

                sendUdp(ip, "<SPEED<${giatri / 2}");
              }))
    ]);
    var switchBtn = Column(
      children: [
        power,
        Text(
          "MODE",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        normalMode,
        Text(
          "TIMER",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        timerMode,
      ],
    );
    var getIpPage = new Container(
      child: Column(
        children: [
          title,
          Container(
            child: screenInform,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 5,
          ),
          Container(
              child: Row(
            children: [changeSpeedWind, switchBtn],
          )),
          modeBtn,
        ],
      ),
    );
    return Scaffold(
      //appBar: AppBar(title: Text(widget.title),),
      body: Container(
        child: getIpPage,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: BgColor(0),
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
          BottomNavigationBarItem(
            backgroundColor: BgColor(1),
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: BgColor(2),
            icon: Icon(Icons.update_outlined),
            label: 'Update',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey[400],
        onTap: _onItemTapped,
        //backgroundColor: Colors.grey,
      ),
    );
  }
}
