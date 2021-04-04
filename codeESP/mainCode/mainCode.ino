
#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>

//---------Khai báo biến mặc định------------------
ESP8266WebServer server(80);
int pinSS=3;
String WIFIname; //tên wifi
String WIFIpass; //mật khẩu wifi
String EQUIPname="Quạt Thông Minh"; //tên thiết bị
String EQUIPpass; //mật khẩu thiết bị
String ip;
String ipHost;
bool isPass;
bool isHost;
String funcRun[5][2];
String windLV="0";
//--------------------------------------------------
bool checkPass(String pass){
  if ((EQUIPpass=="")||(EQUIPpass==pass)){
    return true;
  }
  return false;
}
int checkArr(String nameFunc){
  int sizeArr = sizeof funcRun / sizeof *funcRun;
  if (sizeArr>0){
    for (int i=0;i<sizeArr;i++){
      if (funcRun[i][0]==nameFunc){
        return i;
      }
    }
  }
  return -1;
}
int findNull(){
  int sizeArr = sizeof funcRun / sizeof *funcRun;
  if (sizeArr>0){
    for (int i=0;i<sizeArr;i++){
      if (funcRun[i][0]==""){
        return i;
      }
    }
  }
  return -1;
}
//----------Các page của WEBSERVER------------------
void informPage(){ //Trang hiển thị thông tin
  String jsonRep;
  int countParameter=server.args();
  String arr2d[countParameter][2];
  for (int i = 0; i < server.args(); i++) {
    arr2d[i][0]=server.argName(i);
    arr2d[i][1]= server.arg(i);         
  }
  if (((arr2d[0][0]=="pass")&&(checkPass(arr2d[0][1])))||(EQUIPpass=="")){
    if (EQUIPpass==""){
      isPass=false;
    }else{
      isPass=true;
    }
    String data="{\"name\":\""+EQUIPname+"\",\"isHost\":"+isHost+",\"isPass\":"+isPass+",\"ipHost\":\""+ipHost+"\",\"ip\":\""+ip+"\"}";
    jsonRep="{\"code\":0,\"msg\":\"Thành công\",\"data\":"+data+"}";
  }else{
    jsonRep="{\"code\":99,\"msg\":\"Sai mã xác thực\"}";
  }
  server.send(200,"application/json",jsonRep);
}
void change_passPage(){ //Trang đổi mật khẩu truy cập
  String jsonRep;
  int countParameter=server.args();
  String arr2d[countParameter][2];
  for (int i = 0; i < server.args(); i++) {
    arr2d[i][0]=server.argName(i);
    arr2d[i][1]= server.arg(i);         
  }
  if (((arr2d[0][0]=="pass")&&(checkPass(arr2d[0][1])))||(EQUIPpass=="")){
    if ((arr2d[1][0]=="newpass")){
      EQUIPpass=arr2d[1][1];
      jsonRep="{\"code\":0,\"msg\":\"Thành công\"}";
    }else{
      jsonRep="{\"code\":404,\"msg\":\"Lỗi không xác định\"}";
    }
  }else{
    jsonRep="{\"code\":99,\"msg\":\"Sai mã xác thực\"}";
  }
  server.send(200,"application/json",jsonRep);
}
void requestPage(){ //Trang gửi giao thức HTTP
  String jsonRep;
  int countParameter=server.args();
  String arr2d[countParameter][2];
  for (int i = 0; i < server.args(); i++) {
    arr2d[i][0]=server.argName(i);
    arr2d[i][1]= server.arg(i);         
  }
  if ((((arr2d[0][0]=="pass")&&(checkPass(arr2d[0][1])))||(EQUIPpass==""))&&(countParameter==3)){
    if ((arr2d[1][0]=="func")&&((arr2d[2][0]=="val"))){
       int val=checkArr(arr2d[1][1]);
       if (val==-1){
        int save=findNull();
        if (save==-1){
          jsonRep="{\"code\":999,\"msg\":\"Lỗi dữ liệu\"}";
        }else{
          funcRun[save][0]=arr2d[1][1];
          funcRun[save][1]=arr2d[2][1];
          jsonRep="{\"code\":0,\"msg\":\"Thành công\"}";
        }
      }else{
        funcRun[val][1]=arr2d[2][1];
        jsonRep="{\"code\":0,\"msg\":\"Thành công\"}";
      }
    }else{
      jsonRep="{\"code\":404,\"msg\":\"Lỗi không xác định\"}";
    }
  }else{
    jsonRep="{\"code\":99,\"msg\":\"Sai mã xác thực hoặc dữ liệu\"}";
  }
  
  server.send(200,"application/json",jsonRep);
}
void statusPage(){ //Trang hiển thị trạng thái
  String jsonRep;
  int countParameter=server.args();
  String arr2d[countParameter][2];
  for (int i = 0; i < server.args(); i++) {
    arr2d[i][0]=server.argName(i);
    arr2d[i][1]= server.arg(i);         
  }
  if (((arr2d[0][0]=="pass")&&(checkPass(arr2d[0][1])))||(EQUIPpass=="")){
    String str="\"wind\":"+windLV;
    for (int i=0;i<5;i++){
      
        if (funcRun[i][0]!=""){
          str=str+",\""+funcRun[i][0]+"\":"+funcRun[i][1];
        }

    }
    String data="{"+str+"}";
    jsonRep="{\"code\":0,\"msg\":\"Thành công\",\"data\":"+data+"}";
  }else{
    jsonRep="{\"code\":99,\"msg\":\"Sai mã xác thực\"}";
  }
  server.send(200,"application/json",jsonRep);
}
void connectPage(){ //Trang đổi wifi
  String jsonRep;
  int countParameter=server.args();
  String arr2d[countParameter][2];
  for (int i = 0; i < server.args(); i++) {
    arr2d[i][0]=server.argName(i);
    arr2d[i][1]= server.arg(i);         
  }
  if (((arr2d[0][0]=="pass")&&(checkPass(arr2d[0][1])))||(EQUIPpass=="")){
    if ((arr2d[1][0]=="nameW")&&(arr2d[2][0]=="passW")){
      WiFi.begin(arr2d[1][1],arr2d[2][1]);
      while (WiFi.status() != WL_CONNECTED) {  //Wait for connection
        delay(500);
        Serial.println("Waiting to connect…");
      }
      isHost=false;
      ip=WiFi.localIP().toString();
      Serial.println(WiFi.localIP());
      jsonRep="{\"code\":0,\"msg\":\"Thành công\"}";
    }else{
      jsonRep="{\"code\":404,\"msg\":\"Lỗi không xác định\"}";
    }
  }else{
    jsonRep="{\"code\":99,\"msg\":\"Sai mã xác thực\"}";
  }
  server.send(200,"application/json",jsonRep);
}
void windPage(){ //Trang chỉnh tốc độ gió
  String jsonRep;
  int countParameter=server.args();
  String arr2d[countParameter][2];
  for (int i = 0; i < server.args(); i++) {
    arr2d[i][0]=server.argName(i);
    arr2d[i][1]= server.arg(i);         
  }
  if (((arr2d[0][0]=="pass")&&(checkPass(arr2d[0][1])))||(EQUIPpass=="")){
    if (arr2d[1][0]=="wind"){
      if (arr2d[1][1].toInt()>=0){
        windLV=arr2d[1][1];
        if (windLV.toInt()>100){
          windLV="100";
        }
      }
    }
  }else{
    jsonRep="{\"code\":99,\"msg\":\"Sai mã xác thực\"}";
  }
  server.send(200,"application/json",jsonRep);
}
//--------------------------------------------------
void setup() {
  Serial.begin(115200);
  pinMode(1, OUTPUT);
  pinMode(pinSS, OUTPUT);
  digitalWrite(SS,LOW);
  analogWrite(1, 0);
  bool isCreated=WiFi.softAP (EQUIPname);
  if (isCreated){
    isHost=true;
    ipHost=WiFi.softAPIP().toString();
    ip=ipHost;
    Serial.println(ipHost);
  }
  server.on("/inform",informPage);
  server.on("/newpass",change_passPage);
  server.on("/request",requestPage);
  server.on("/status",statusPage);
  server.on("/connect",connectPage);
  server.on("/wind",windPage);
  server.begin();
}

void loop() {
  server.handleClient();
  //digitalWrite(1,HIGH);
  analogWrite(1, 1023*windLV.toInt()/100);
  if (windLV.toInt()==0){
    digitalWrite(pinSS,LOW);
  }else{
    digitalWrite(pinSS,HIGH);
  }
}
