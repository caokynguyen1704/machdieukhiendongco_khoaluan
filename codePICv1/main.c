#include <16F877A.h>
#include <stdint.h>
#fuses HS,NOWDT,NOPROTECT,NOLVP
#use delay(clock = 12000000)
unsigned int16 i ;
uint8_t UART_Buffer = 0;
void main(){
  setup_adc(ADC_CLOCK_DIV_32);         
  setup_adc_ports(AN0);                  
  set_adc_channel(0);                  
  setup_ccp1(CCP_PWM);                  
  setup_timer_2(T2_DIV_BY_16,125,1);//125=12000000/(Hz*16*4) =>1k4 Hz
  delay_ms(100);       
  
 
  TRISB = 0x00; // Output Port (4-Pins)
  PORTB = 0x00; // Initially OFF
  
  while(TRUE){
    i = read_adc();                    
    set_pwm1_duty(i);                   
    delay_ms(10);                       
   }
}

