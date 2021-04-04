#include <16F877A.h>
#include <string.h>
#fuses HS,NOWDT,NOPROTECT,NOLVP
#use delay(clock = 12000000)
#use rs232(uart1, baud=9600,ERRORS)
unsigned int16 i ;
char *host="192.168.4.1";


void ESP8266_init()
{
 //printf("AT\r\n");delay_ms(500);
 //printf("ATE0\r\n");delay_ms(500);
 //printf("AT+CWMODE=1\r\n");delay_ms(500);
 //printf("AT+CWJAP=\"%s\",\"%s\"\r\n",SSID,PASS);delay_ms(4000); // thay mat khau va tai khoan tuong ung
 //printf("AT+CIPMUX=0\r\n");delay_ms(500);
}


void getRequest(){
  int length; 
  char data[90];
  sprintf(data,"GET /status HTTP/1.1\r\nHost: 192.168.4.1\r\n\r\n");
  printf("AT+CIPSTART=\"TCP\",\"%s\",80\r\n",host);delay_ms(2000); 
  length=strlen(data);
  printf("AT+CIPSEND=%i\r\n",length);delay_ms(500);
  printf(data);delay_ms(1000);
  printf("AT+CIPCLOSE\r\n");delay_ms(200);
}
void main(){
  setup_adc(ADC_CLOCK_DIV_32);         
  setup_adc_ports(AN0);                  
  set_adc_channel(0);                  
  setup_ccp1(CCP_PWM);                  
  setup_timer_2(T2_DIV_BY_16,125,1);//125=12000000/(Hz*16*4) =>1k4 Hz
  delay_ms(100);       
  
 
  while(TRUE){
    i = read_adc();                    
    set_pwm1_duty(i);                   
    delay_ms(10);                       
   }
}

