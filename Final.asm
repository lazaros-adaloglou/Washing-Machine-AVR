;Final.asm
;Adaloglou Lazaros - Anonymus Co-worker
;Electrical Engineering AuTH
;21 / 12 / 2018
;Thessaloniki , Greece
;Clothes Washing Machine / Avr microcontroller ATmega16

start:

   .include "m16def.inc"                                                    ;Include "m16def.inc" file.

   .def Temp1 = r16                                                           
   .def Temp2 = r17
   .def Program = r18 
   .def Delay1 = r19
   .def Delay2 = r20 
   .def Delay3 = r21 
   .def Delay4 = r22 
   .def Delay5 = r23 
   .def Delay6 = r24 
   .def Counter = r25  

reset:

   clr Temp1
   clr Temp2
   clr Program
   clr Delay1   
   clr Delay2
   clr Delay3
   clr Delay4
   clr Delay5
   clr Delay6
   clr Counter
   
   ldi Temp1 , $00
   out DDRB , Temp1

   ldi Temp1 , $ff
   out DDRD , Temp1

   ldi Temp1 , Low(RAMEND)
   out spl , Temp1

   ldi Temp1 , High(RAMEND)
   out sph , Temp1

   clr Temp1
   ldi Temp2 , $ff
   ldi Program , $ff
  
wait_switch_6:

   ldi Temp1 , $ff
   out PortB , Temp1
   in Temp1 , PinD
   andi Temp1 , $40
   cpi Temp1 , $40
   breq wait_switch_6
   jmp release_switch_6

release_switch_6:

   in Temp1 , PinD
   andi Temp1 , $40
   cpi Temp1 , $00
   breq release_switch_6
   ldi Temp1 , $00
   out PortB , Temp1
   jmp countdown_10_1

countdown_10_1:

   cpi Temp2 , $02
   breq countdown_10_2
   ldi Temp2 , $02
   ldi Delay1 , $7a                    
   ldi Delay2 , $c8                   
   ldi Delay3 , $c8                      

wait_program_code:

   in Temp1 , PinD                     
   and Program , Temp1                 
   dec Delay3                          
   brne wait_program_code              
   in Temp1 , PinD                     
   and Program , Temp1                 
   dec Delay2                          
   brne wait_program_code              
   in Temp1 , PinD                     
   and Program , Temp1                 
   dec Delay1                          
   brne wait_program_code              
   jmp wait_switch_6                   

countdown_10_2:

   ldi Delay1 , $7a
   ldi delay2 , $c8
   ldi Delay3 , $c8

wait_switch_1:

   in Temp1 , PinD                     
   andi Temp1 , $02
   cpi Temp1 , $02
   brne release_switch_1               
   dec Delay3                                
   brne wait_switch_1              
   in Temp1 , PinD                           
   andi Temp1 , $02
   cpi Temp1 , $02
   brne release_switch_1               
   dec Delay2                          
   brne wait_switch_1
   in Temp1 , PinD                     
   andi Temp1 , $02
   cpi Temp1 , $02
   brne release_switch_1              
   dec Delay1                          
   brne wait_switch_1
   clr Counter             
   jmp check_prewash

release_switch_1:

   in Temp1 , PinD
   andi Temp1 , $02
   cpi Temp1 , $00
   breq release_switch_1
   cpi Counter , $03
   breq clear_counter_1
   jmp countdown_1_1

clear_counter_1:

   clr Counter
   jmp wait_switch_1

countdown_1_1:

   ldi delay4 , $07
   ldi delay5 , $c8
   ldi delay6 , $c8
   cpi Counter , $01
   breq press_switch_1_off
   jmp press_switch_1_on

press_switch_1_off:

   ldi Temp1 , $ff
   out PortB , Temp1
   in Temp1 , PinD                     
   andi Temp1 , $02
   cpi Temp1 , $02
   brne set_counter_3_0
   dec delay6
   brne press_switch_1_off
   ldi Temp1 , $ff
   out PortB , Temp1
   in Temp1 , PinD                     
   andi Temp1 , $02
   cpi Temp1 , $02
   brne set_counter_3_0
   dec delay5
   brne press_switch_1_off
   ldi Temp1 , $ff
   out PortB , Temp1
   in Temp1 , PinD                     
   andi Temp1 , $02                                   
   cpi Temp1 , $02
   brne set_counter_3_0
   dec delay4
   brne press_switch_1_off
   clr Counter 
   jmp countdown_1_1

set_counter_3_0:

   ldi Counter , $03
   ldi Temp1 , $00
   out PortB ,Temp1
   jmp release_switch_1

press_switch_1_on:

   ldi Temp1 , $fd
   out PortB , Temp1
   in Temp1 , PinD                     
   andi Temp1 , $02
   cpi Temp1 , $02
   brne set_counter_3_0
   dec delay6
   brne press_switch_1_on
   ldi Temp1 , $fd
   out PortB , Temp1
   in Temp1 , PinD                     
   andi Temp1 , $02                                         
   cpi Temp1 , $02
   brne set_counter_3_0
   dec delay5
   brne press_switch_1_on
   ldi Temp1 , $fd
   out PortB , Temp1
   in Temp1 , PinD                     
   andi Temp1 , $02
   cpi Temp1 , $02
   brne set_counter_3_0
   dec delay4
   brne press_switch_1_on
   ldi Counter , $01
   jmp countdown_1_1

check_prewash:

   ldi Temp2 , $ff
   and Temp2 , Program
   andi Temp2 , $04
   cpi Temp2 , $00
   breq countdown_4
   clr Temp2
   jmp check_wash

countdown_4:

   clr Temp2
   ldi delay1 , $13
   ldi delay2 , $c8
   ldi delay3 , $c8

prewash:
   
   ldi Temp1 , $fb
   out PortB , Temp1
   in Temp1 , PinD
   andi Temp1 , $01
   cpi Temp1 , $01
   brne set_counter_0
   in Temp1 , PinD
   andi Temp1 , $80
   cpi Temp1 , $80
   brne set_counter_20
   dec delay3
   brne prewash
   ldi Temp1 , $fb
   out PortB , Temp1
   in Temp1 , PinD
   andi Temp1 , $01
   cpi Temp1 , $01
   brne set_counter_0
   in Temp1 , PinD
   andi Temp1 , $80
   cpi Temp1 , $80
   brne set_counter_20
   dec delay2
   brne prewash
   ldi Temp1 , $fb
   out PortB , Temp1
   in Temp1 , PinD
   andi Temp1 , $01
   cpi Temp1 , $01
   brne set_counter_0
   in Temp1 , PinD
   andi Temp1 , $80
   cpi Temp1 , $80
   brne set_counter_20
   dec delay1
   brne prewash
   clr Counter
   jmp check_wash

set_counter_0:

   ldi Counter , $00
   jmp release_switch_0

set_counter_20:

   ldi Counter , $14
   jmp release_switch_7

check_wash:

   ldi Temp2 , $ff
   and Temp2 , Program
   andi Temp2 , $18
   
   cpi Temp2 , $00
   breq set_delay1

   cpi Temp2 , $08
   breq set_delay2

   cpi Temp2 , $10
   breq set_delay3

   cpi Temp2 , $18
   breq set_delay4

set_delay1:

   clr Temp2
   ldi delay1 , $13
   ldi delay2 , $c8
   ldi delay3 , $c8
   jmp wash

set_delay2:
   
   clr Temp2
   ldi delay1 , $26
   ldi delay2 , $c8
   ldi delay3 , $c8
   jmp wash

set_delay3:

   clr Temp2
   ldi delay1 , $38
   ldi delay2 , $c8
   ldi delay3 , $c8
   jmp wash

set_delay4:

   clr Temp2
   ldi delay1 , $54
   ldi delay2 , $c8
   ldi delay3 , $c8
   jmp wash

wash:

   ldi Temp1 , $f7
   out PortB , Temp1
   in Temp1 , PinD
   andi Temp1 , $01
   cpi Temp1 , $01
   brne set_counter_1
   in Temp1 , PinD
   andi Temp1 , $80
   cpi Temp1 , $80
   brne set_counter_21
   dec delay3
   brne wash
   ldi Temp1 , $f7
   out PortB , Temp1
   in Temp1 , PinD
   andi Temp1 , $01
   cpi Temp1 , $01
   brne set_counter_1
   in Temp1 , PinD
   andi Temp1 , $80
   cpi Temp1 , $80
   brne set_counter_21
   dec delay2
   brne wash
   ldi Temp1 , $f7
   out PortB , Temp1
   in Temp1 , PinD
   andi Temp1 , $01
   cpi Temp1 , $01
   brne set_counter_1
   in Temp1 , PinD
   andi Temp1 , $80
   cpi Temp1 , $80
   brne set_counter_21
   dec delay1
   brne wash
   clr Counter
   clr Temp2
   jmp rinse_loop

set_counter_1:

   ldi Counter , $01
   jmp release_switch_0

set_counter_21:

   ldi Counter , $15
   jmp release_switch_7

rinse_loop:

   ldi delay1 , $05
   ldi delay2 , $c8
   ldi delay3 , $c8

rinse:

   ldi Temp1 , $ef
   out PortB , Temp1
   in Temp1 , PinD
   andi Temp1 , $01
   cpi Temp1 , $01
   brne set_counter_2
   in Temp1 , PinD
   andi Temp1 , $80
   cpi Temp1 , $80
   brne set_counter_22
   dec delay3
   brne rinse
   ldi Temp1 , $ef
   out PortB , Temp1
   in Temp1 , PinD
   andi Temp1 , $01
   cpi Temp1 , $01
   brne set_counter_2
   in Temp1 , PinD
   andi Temp1 , $80
   cpi Temp1 , $80
   brne set_counter_22
   dec delay2
   brne rinse
   ldi Temp1 , $ef
   out PortB , Temp1
   in Temp1 , PinD
   andi Temp1 , $01
   cpi Temp1 , $01
   brne set_counter_2
   in Temp1 , PinD
   andi Temp1 , $80
   cpi Temp1 , $80
   brne set_counter_22
   dec delay1
   brne rinse
   clr Counter
   clr Temp2
   jmp check_straining

set_counter_2:

   ldi Counter , $02
   jmp release_switch_0

set_counter_22:

   ldi Counter , $16
   jmp release_switch_7

check_straining:

   ldi Temp2 , $ff
   and Temp2 , Program
   andi Temp2 , $20
   cpi Temp2 , $20
   brne straining
   clr Counter
   clr Temp2
   jmp wash_complete

straining_loop:

   clr Temp2
   ldi delay1 , $0a
   ldi delay2 , $c8
   ldi delay3 , $c8

straining:

   ldi Temp1 , $df
   out PortB , Temp1
   in Temp1 , PinD
   andi Temp1 , $01
   cpi Temp1 , $01
   brne set_counter_3
   in Temp1 , PinD
   andi Temp1 , $80
   cpi Temp1 , $80
   brne set_counter_23
   dec delay3
   brne straining
   ldi Temp1 , $df
   out PortB , Temp1
   in Temp1 , PinD
   andi Temp1 , $01
   cpi Temp1 , $01
   brne set_counter_3
   in Temp1 , PinD
   andi Temp1 , $80
   cpi Temp1 , $80
   brne set_counter_23
   dec delay2
   brne straining
   ldi Temp1 , $df
   out PortB , Temp1
   in Temp1 , PinD
   andi Temp1 , $01
   cpi Temp1 , $01
   brne set_counter_3
   in Temp1 , PinD
   andi Temp1 , $80
   cpi Temp1 , $80
   brne set_counter_23
   dec delay1
   brne straining
   clr Counter
   clr Temp2
   jmp wash_complete_loop

set_counter_3:

   ldi Counter , $03
   jmp release_switch_0

set_counter_23:

   ldi Counter , $17
   jmp release_switch_7

wash_complete_loop:

   ldi Temp1 , $7f
   out PortB , Temp1
   ldi delay1 , $66
   ldi delay2 , $c8
   ldi delay3 , $c8

wash_complete:

   dec delay3
   brne wash_complete
   dec delay2
   brne wash_complete
   dec delay1
   brne wash_complete
   jmp exit_loop

exit_loop:

   ldi Temp1 , $ff
   out PortB , Temp1

   jmp exit
      
release_switch_0:

   in Temp1 , PinD
   andi Temp1 , $01
   cpi Temp1 , $00
   breq release_switch_0

   cpi Counter , $00
   breq set_counter_10

   cpi Counter , $01
   breq set_counter_11

   cpi Counter , $02
   breq set_counter_12

   cpi Counter , $03
   breq set_counter_13

   cpi Counter , $0a
   breq go_to_prewash

   cpi Counter , $0b
   breq go_to_wash

   cpi Counter , $0c
   breq go_to_rinse

   cpi Counter , $0d
   breq go_to_straining

   jmp countdown_door

set_counter_10:

   ldi Counter , $0a
   jmp countdown_door

set_counter_11:

   ldi Counter , $0b
   jmp countdown_door

set_counter_12:

   ldi Counter , $0c
   jmp countdown_door

set_counter_13:

   ldi Counter , $0d
   jmp countdown_door

go_to_prewash:

   clr Counter
   jmp prewash

go_to_wash:

   clr Counter
   jmp wash

go_to_rinse:

   clr Counter
   jmp rinse

go_to_straining:

   clr Counter
   jmp straining

countdown_door:

   ldi delay4 , $07
   ldi delay5 , $c8
   ldi delay6 , $c8
   cpi Temp2 , $01
   breq open_door_off
   jmp open_door_on

open_door_off:

   ldi Temp1 , $ff
   out PortB , Temp1
   in Temp1 , PinD
   andi Temp1 , $01
   cpi Temp1 , $01
   brne check_stage
   dec delay6
   brne open_door_off
   ldi Temp1 , $ff
   out PortB , Temp1
   in Temp1 , PinD
   andi Temp1 , $01
   cpi Temp1 , $01
   brne check_stage
   dec delay6
   brne open_door_off
   ldi Temp1 , $ff
   out PortB , Temp1
   in Temp1 , PinD
   andi Temp1 , $01
   cpi Temp1 , $01
   brne check_stage
   dec delay6
   brne open_door_off
   clr Temp2
   jmp countdown_door

check_stage:
   
   jmp release_switch_0 
   
open_door_on:

   ldi Temp1 , $fe
   out PortB , Temp1
   in Temp1 , PinD
   andi Temp1 , $01
   cpi Temp1 , $01
   brne check_stage
   dec delay6
   brne open_door_on
   ldi Temp1 , $fe
   out PortB , Temp1
   in Temp1 , PinD
   andi Temp1 , $01
   cpi Temp1 , $01
   brne check_stage
   dec delay6
   brne open_door_on
   ldi Temp1 , $fe
   out PortB , Temp1
   in Temp1 , PinD
   andi Temp1 , $01
   cpi Temp1 , $01
   brne check_stage
   dec delay6
   brne open_door_on
   ldi Temp2 , $01
   jmp countdown_door

release_switch_7:

   in Temp1 , PinD
   andi Temp1 , $80
   cpi Temp1 , $00
   breq release_switch_7

   cpi Counter , $14
   breq set_counter_30

   cpi Counter , $15
   breq set_counter_31

   cpi Counter , $16
   breq set_counter_32

   cpi Counter , $17
   breq set_counter_33

   cpi Counter , $1e
   breq go_to_prewash_1

   cpi Counter , $1f
   breq go_to_wash_1

   cpi Counter , $20
   breq go_to_rinse_1

   cpi Counter , $21
   breq go_to_straining_1

   jmp countdown_water

set_counter_30:

   ldi Counter , $1e
   jmp countdown_water

set_counter_31:

   ldi Counter , $1f
   jmp countdown_water

set_counter_32:

   ldi Counter , $20
   jmp countdown_water

set_counter_33:

   ldi Counter , $21
   jmp countdown_water

go_to_prewash_1:

   clr Counter
   jmp prewash

go_to_wash_1:

   clr Counter
   jmp wash

go_to_rinse_1:

   clr Counter
   jmp rinse

go_to_straining_1:

   clr Counter
   jmp straining

countdown_water:

   ldi delay4 , $07
   ldi delay5 , $c8
   ldi delay6 , $c8
   cpi Temp2 , $01
   breq water_supply_off
   jmp water_supply_on

water_supply_off:

   ldi Temp1 , $bf
   out PortB , Temp1
   in Temp1 , PinD
   andi Temp1 , $80
   cpi Temp1 , $80
   brne check_stage_1
   dec delay6
   brne water_supply_off
   ldi Temp1 , $bf
   out PortB , Temp1
   in Temp1 , PinD
   andi Temp1 , $80
   cpi Temp1 , $80
   brne check_stage_1
   dec delay5
   brne water_supply_off
   ldi Temp1 , $bf
   out PortB , Temp1
   in Temp1 , PinD
   andi Temp1 , $80
   cpi Temp1 , $80
   brne check_stage_1
   dec delay4
   brne water_supply_off
   clr Temp2
   jmp countdown_water

check_stage_1:
   
   jmp release_switch_7 
   
water_supply_on:

   ldi Temp1 , $bd
   out PortB , Temp1
   in Temp1 , PinD
   andi Temp1 , $80
   cpi Temp1 , $80
   brne check_stage_1
   dec delay6
   brne water_supply_on
   ldi Temp1 , $bd
   out PortB , Temp1
   in Temp1 , PinD
   andi Temp1 , $80
   cpi Temp1 , $80
   brne check_stage_1
   dec delay5
   brne water_supply_on
   ldi Temp1 , $bd
   out PortB , Temp1
   in Temp1 , PinD
   andi Temp1 , $80
   cpi Temp1 , $80
   brne check_stage_1
   dec delay4
   brne water_supply_on
   ldi Temp2 , $01
   jmp countdown_water

exit:

   rjmp exit
