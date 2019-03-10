#include <stdio.h>
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/pushbuttons.h"

int main() {
	int ten_ms = 0;
	int s = 0;
	int m = 0;
	
	// use as a boolean control
	int cont = 0;

	//config stop watch
	HPS_TIM_config_t stop_watch;
	stop_watch.tim = TIM0;
	stop_watch.timeout = 10000;
	stop_watch.LD_en = 1;
	stop_watch.INT_en = 1;
	stop_watch.enable = 1;

	//config button signal
	HPS_TIM_config_t button_signal;
	button_signal.tim = TIM1;
	button_signal.timeout = 3000;
	button_signal.LD_en = 1;
	button_signal.INT_en = 1;
	button_signal.enable = 1;

	//set up watch
	HPS_TIM_config_ASM(&stop_watch);
	HPS_TIM_config_ASM(&button_signal);

	while (1) {
		if (cont && HPS_TIM_read_INT_ASM(TIM0)) {
			HPS_TIM_clear_INT_ASM(TIM0);
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

		// for push buttons
		if (HPS_TIM_read_INT_ASM(TIM1)) {
			HPS_TIM_clear_INT_ASM(TIM1);
			if (read_PB_edgecap_ASM(PB0)) {
				PB_clear_edgecap_ASM(PB0);
				cont = 1;
			}

			if (read_PB_edgecap_ASM(PB1)) {
				PB_clear_edgecap_ASM(PB1);
				cont = 0;
			}

			if (read_PB_edgecap_ASM(PB2)) {
				PB_clear_edgecap_ASM(PB2);
				ten_ms = 0;
				s = 0;
				m = 0;
				HEX_write_ASM(63, 0);
			}
		}
	}

	
}