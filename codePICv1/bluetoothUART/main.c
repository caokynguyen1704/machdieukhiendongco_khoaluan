#include <16F877A.h>
#fuses NOWDT,NOPUT,HS,NOPROTECT,NOLVP
#define TB1 pinA2
#define TB2 pinA3
#define TB3 pinA4
#use delay(clock=16000000)
#use rs232(uart,baud=9600,parity=N,bits=8) 
int CR=0;
#INT_RDA
void recive(){
   char BT;
   BT=getc();
   CR=BT;
}
void main(){
   enable_interrupts(GLOBAL)
   while(true){
   }
}
