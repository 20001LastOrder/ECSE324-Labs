#include <stdio.h>

#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/pushbuttons.h"

int main() {

	while (1) {
		int slide_switch_v = read_slider_switches_ASM();
		write_LEDs_ASM(slide_switch_v);

		int controlSwitch = slide_switch_v & 512;
		if (controlSwitch == 0) {
			HEX_clear_ASM(63);							//clear all led displays
		} else {
			int hexDisp = slide_switch_v & 15;				//only the last 4 switches 
			int pushButtons = read_PB_data_ASM();
			HEX_write_ASM(pushButtons, hexDisp);
			HEX_clear_ASM(~pushButtons);

			HEX_flood_ASM(48);
		}
		


	}

	return 0;
}
