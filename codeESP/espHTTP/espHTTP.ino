
#include "ESP8266WiFi.h"
#include "ESP8266WebServer.h"


ESP8266WebServer server(80);
String SSIDname="HienDo";
String SSIDpass="01645305146";
String EQUIPname="Quạt Thông Minh";
bool isON1=false;
bool isON2=false;
bool isON3=false;
bool isON4=false;
String ip;
int OnOff(bool isOn){
  if (isOn){
    return 1; 
  }
  return 0;
}
bool isNumber(String s)
{
    for (int i = 0; i < s.length(); i++)
        if (isdigit(s[i]) == false)
            return false;
 
    return true;
}
String toString(bool val){
  if (val){
    return "1";
  }
  return "0";
}
void setup() {
  pinMode(pin1, OUTPUT);
  pinMode(pin2, OUTPUT);
  pinMode(pin3, OUTPUT);
  pinMode(pin4, OUTPUT);
  digitalWrite(pin1, OnOff(isON1));
  digitalWrite(pin2, OnOff(isON2));
  digitalWrite(pin3, OnOff(isON3));
  digitalWrite(pin4, OnOff(isON4));
  Serial.begin(115200);
  WiFi.begin(SSIDname,SSIDpass);  //Connect to the WiFi network
  while (WiFi.status() != WL_CONNECTED) {  //Wait for connection
    delay(500);
    Serial.println("Waiting to connect…");
  }
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());  //Print the local IP
  server.on("/inform", []() {
    String ip=WiFi.localIP().toString();
    server.send(200, "application/json", "{\"name\":\""+EQUIPname+"\",\"ip\":\""+ip+"\"}");
  });
  server.on("/status", []() {
    String json="{\"equip1\":"+toString(isON1)+",\"equip2\":"+toString(isON2)+",\"equip3\":"+toString(isON3)+",\"equip4\":"+toString(isON4)+"}";
    server.send(200, "application/json",json );
  });
   server.on("/control", handleGenericArgs);
   server.on("/edit", editName);
  server.on("/", handleRootPath);    //Associate the handler function to the path
  server.begin();                    //Start the server
  Serial.println("Server listening");
  String ip=WiFi.localIP().toString();
}
void loop() {\
  
  server.handleClient();         //Handling of incoming requests
//  Serial.print("IP address: ");
//  Serial.println(WiFi.localIP());  
}
void handleRootPath() {            //Handler for the rooth path
  server.send(200, "text/plain", "Welcome to Quạt Thông Minh's HomePage!");
}
void handleGenericArgs() { //Handler
  String isRun="0";
  int countParameter=server.args();
  String arr2d[countParameter][2];
  for (int i = 0; i < server.args(); i++) {
    arr2d[0][i]=server.argName(i);
    arr2d[1][i]= server.arg(i);         
  }
  if (arr2d[0][0]=="key"){
   
    
    String getKey=ip+EQUIPname;
    Serial.println(getKey);
    if (arr2d[1][0]==getKey){
      isRun="1";
      if ((arr2d[0][1]=="equip")&&(isNumber(arr2d[1][1]))){
        
        int numEQUIP=arr2d[1][1].toInt();
        switch (numEQUIP){
          case 0:
            isON1=false;
            isON2=false;
            isON3=false;
            isON4=false;
            break;
         case 1:
            isON1=true;
            isON2=false;
            isON3=false;
            isON4=false;
            break;
         case 2:
            isON1=false;
            isON2=true;
            isON3=false;
            isON4=false;
            break;
         case 3:
            isON1=false;
            isON2=false;
            isON3=true;
            isON4=false;
            break;
         case 4:
            isON1=false;
            isON2=false;
            isON3=false;
            isON4=true;
            break;
        }
      }
    };
      digitalWrite(pin1, OnOff(isON1));
      digitalWrite(pin2, OnOff(isON2));
      digitalWrite(pin3, OnOff(isON3));
      digitalWrite(pin4, OnOff(isON4));
  }
  server.send(200, "text/plain", isRun);       //Response to the HTTP request
}
void editName() { //Handler
  String isRun="0";
  int countParameter=server.args();
  String arr2d[countParameter][2];
  for (int i = 0; i < server.args(); i++) {
    arr2d[0][i]=server.argName(i);
    arr2d[1][i]= server.arg(i);         
  }
  if (arr2d[0][0]=="key"){
   
  
    String getKey=ip+EQUIPname;
    Serial.println(getKey);
    if (arr2d[1][0]==getKey){
      isRun="1";
      if ((arr2d[0][1]=="name")){
        isRun="1";
        EQUIPname=arr2d[1][1];
      }
    };
  }
  server.send(200, "text/plain", isRun);       //Response to the HTTP request
}
