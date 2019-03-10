#include <stdio.h>
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/ISRs.h"
#include "./drivers/inc/int_setup.h"

int main() {
	int ten_ms = 0;
	int s = 0;
	int m = 0;

	// use as a boolean control
	int cont = 0;

	//set interrupt
	int_setup(2, (int[]) { 199, 73 });
	//config stop watch
	HPS_TIM_config_t stop_watch;
	stop_watch.tim = TIM0;
	stop_watch.timeout = 10000;
	stop_watch.LD_en = 1;
	stop_watch.INT_en = 1;
	stop_watch.enable = 1;

	//enbale push button interrupt
	enable_PB_INT_ASM(PB2 | PB1 | PB0);

	//set up watch
	HPS_TIM_config_ASM(&stop_watch);

	while (1) {
		if (hps_tim0_int_flag) {
			hps_tim0_int_flag = 0;
			if (cont) {
				ten_ms += 1;	//increment 10 ms
				if (ten_ms >= 100) {
					ten_ms = 0;
					s += 1;
					if (s >= 60) {
						s = 0;
						m += 1;
					}
				}
				HEX_write_ASM(HEX0, ten_ms % 10);
				HEX_write_ASM(HEX1, ten_ms / 10);
				HEX_write_ASM(HEX2, s % 10);
				HEX_write_ASM(HEX3, s / 10);
				HEX_write_ASM(HEX4, m % 10);
				HEX_write_ASM(HEX5, m / 10);
			}
		}

		// for push buttons
		if (hps_pb_int_flag) {
			int flag = hps_pb_int_flag;
			hps_pb_int_flag = 0;

			// handle flag for button 1
			if ((flag & 1) == 1) {
				cont = 1;
			}

			// handle flag for button 2
			if ((flag & 2) == 2) {
				cont = 0;
			}

			if ((flag & 4) == 4) {
				ten_ms = 0;
				s = 0;
				m = 0;
				HEX_write_ASM(63, 0);
			}
		}
	}


}