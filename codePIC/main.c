#include <16F877A.h>
#fuses HS,NOWDT,NOPROTECT,NOLVP
#device ADC = 10
#use delay(clock = 12000000)
 
unsigned int16 i ;
void main(){
  setup_adc(ADC_CLOCK_DIV_32);           // Set ADC conversion time to 32Tosc
  setup_adc_ports(AN0);                  // Configure AN0 as analog
  set_adc_channel(0);                    // Select channel AN0
  setup_ccp1(CCP_PWM);                   // Configure CCP1 as a PWM
  //setup_timer_2(T2_DIV_BY_16, 250, 1);   // Set PWM frequency to 500Hz
   setup_timer_2(T2_DIV_BY_16,125,1);
  delay_ms(100);                         // Wait 100ms
  while(TRUE){
    i = read_adc();                      // Read from AN0 and store in i
    set_pwm1_duty(i);                    // PWM1 duty cycle set
    delay_ms(10);                        // Wait 10ms
   }
}
