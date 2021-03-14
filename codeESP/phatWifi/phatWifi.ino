#include "ESP8266WiFi.h"
#include "ESP8266WebServer.h"
ESP8266WebServer server(80);

String nameSSID="";
String passSSID="";

void WEBconnectWiFi() { 
  String isRun="0";
  int countParameter=server.args();
  String arr2d[2][countParameter];
  for (int i = 0; i < server.args(); i++) {
    arr2d[0][i]=server.argName(i);
    arr2d[1][i]= server.arg(i);         
  }
  if (arr2d[0][0]=="key"){
    String getKey="12345";
    Serial.println(getKey);
    if (arr2d[1][0]==getKey){
      isRun="1";
      if ((arr2d[0][1]=="name")&&(arr2d[0][2]=="pass")){
        nameSSID=arr2d[1][1];
        passSSID=arr2d[1][2];
          WiFi.begin(nameSSID,passSSID);
    while (WiFi.status() != WL_CONNECTED) { 
      delay(500);
      Serial.println("Waiting to connect…");
      
    }
    Serial.print("IP address: ");
    Serial.println(WiFi.localIP());
    WiFi.disconnect(true);
      }
    }
  }
  server.send(200, "text/plain", isRun);       //Response to the HTTP request
}
void setup() {
  Serial.begin(9600);
  if (nameSSID==""){
    WiFi.softAP("FanControl", "admin");
    Serial.print("IP address: ");
  Serial.println(WiFi.softAPIP());
    
  }else{
    WiFi.begin(nameSSID,passSSID);
    while (WiFi.status() != WL_CONNECTED) { 
      delay(500);
      Serial.println("Waiting to connect…");
    }
    Serial.print("IP address: ");
    Serial.println(WiFi.localIP());
  }
  
  server.on("/connect", WEBconnectWiFi);
  server.begin(); 
}

void loop() {
  server.handleClient();
}
