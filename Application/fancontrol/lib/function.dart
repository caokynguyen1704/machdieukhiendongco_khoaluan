import 'dart:io';
import 'dart:convert';

sendUdp(String ip, String dataString) {

  var DESTINATION_ADDRESS=InternetAddress(ip);

  RawDatagramSocket.bind(InternetAddress.anyIPv4, 8889).then((RawDatagramSocket udpSocket) {
    udpSocket.broadcastEnabled = true;
    udpSocket.listen((e) {
      Datagram dg = udpSocket.receive();
      if (dg != null) {
        print("received ${dg.data}");
      }
    });
    List<int> data =utf8.encode(dataString);
    udpSocket.send(data, DESTINATION_ADDRESS, 8889);
  });
}