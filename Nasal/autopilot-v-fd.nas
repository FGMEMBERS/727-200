# 727 Block V Autopilot/Flight Director
# Custom Flight Director Functions
# Joshua Davidson (it0uchpods)

var fd_init = func {
	setprop("/autopilot-v/internal/fd-alt", 10000);
	setprop("/autopilot-v/internal/fd-lat", 4);
	setprop("/autopilot-v/internal/fd-vert", 4);
	setprop("/autopilot-v/internal/fd-loc-armed", 0);
	setprop("/autopilot-v/internal/fd-appr-armed", 0);
}

setlistener("/autopilot-v/fd-mode-knob", func {
	fd_update();
});

var fd_update = func {
	var fdset = getprop("/autopilot-v/fd-mode-knob");
	if (fdset == 1) {
		setprop("/autopilot-v/internal/fd-loc-armed", 0);
		setprop("/autopilot-v/internal/fd-appr-armed", 0);
		setprop("/autopilot-v/internal/fd-lat", 1);
		setprop("/autopilot-v/internal/fd-vert", 3);
	} else if (fdset == 2) {
		setprop("/autopilot-v/internal/fd-loc-armed", 0);
		setprop("/autopilot-v/internal/fd-appr-armed", 0);
		setprop("/autopilot-v/internal/fd-lat", 4);
		setprop("/autopilot-v/internal/fd-vert", 4);
		setprop("/autopilot-v/fd/alt-hld", 0);
	} else if (fdset == 3) {
		sync_pitch();
		setprop("/autopilot-v/internal/fd-loc-armed", 0);
		setprop("/autopilot-v/internal/fd-appr-armed", 0);
		setprop("/autopilot-v/internal/fd-lat", 0);
		setprop("/autopilot-v/internal/fd-vert", 1);
	} else if (fdset == 4) {
		sync_pitch();
		setprop("/autopilot-v/internal/fd-appr-armed", 1);
		setprop("/autopilot-v/internal/fd-vert", 1);
		if (getprop("/autopilot-v/internal/fd-lat") == 2) {
			# Do nothing because VOR/LOC is active
		} else {
			setprop("/instrumentation/nav[0]/signal-quality-norm", 0);
			setprop("/instrumentation/nav[1]/signal-quality-norm", 0);
			setprop("/autopilot-v/internal/fd-loc-armed", 1);
		}
	} else if (fdset == 5) {
		if (getprop("/autopilot-v/internal/fd-vert") == 4) {
			setprop("/autopilot-v/internal/fd-vert", 1);
		}
		if (getprop("/autopilot-v/internal/fd-lat") == 2) {
			# Do nothing because VOR/LOC is active
		} else {
			setprop("/instrumentation/nav[0]/signal-quality-norm", 0);
			setprop("/instrumentation/nav[1]/signal-quality-norm", 0);
			setprop("/autopilot-v/internal/fd-loc-armed", 1);
		}
		if (getprop("/autopilot-v/internal/fd-vert") == 2 or getprop("/autopilot-v/internal/fd-appr-armed") == 1) {
			# Do nothing because G/S is active
		} else {
			setprop("/instrumentation/nav[0]/gs-rate-of-climb", 0);
			setprop("/instrumentation/nav[1]/gs-rate-of-climb", 0);
			setprop("/autopilot-v/internal/fd-appr-armed", 1);
		}
	}
}

setlistener("/autopilot-v/fd/alt-hld", func {
	if (getprop("/autopilot-v/fd-mode-knob") != 2) {
		if (getprop("/autopilot-v/fd/alt-hld") == 1) {
			setprop("/autopilot-v/internal/fd-alt", int((getprop("/instrumentation/altimeter/indicated-altitude-ft")+50)/100)*100);
			setprop("/autopilot-v/internal/fd-vert", 0);
		} else if (getprop("/autopilot-v/fd/alt-hld") == 0) {
			if (getprop("/autopilot-v/internal/fd-vert") != 2 and getprop("/autopilot-v/internal/fd-vert") != 4) {
				fd_update();
			}
		}
	} else {
		setprop("/autopilot-v/fd/alt-hld", 0);
	}
});

var sync_pitch = func {
	if (getprop("/it-autoflight/output/vert") != 6) {
		var pnow = math.round(getprop("/orientation/pitch-deg"));
		setprop("/it-autoflight/input/pitch-deg", pnow);
	}
}

# LOC and ILS arming
setlistener("/autopilot-v/internal/fd-loc-armed", func {
	check_fd_arms();
});

setlistener("/autopilot-v/internal/fd-appr-armed", func {
	check_fd_arms();
});

var check_fd_arms = func {
	if (getprop("/autopilot-v/internal/fd-loc-armed") or getprop("/autopilot-v/internal/fd-appr-armed")) {
		update_fd_armst.start();
	} else {
		update_fd_armst.stop();
	}
}

var update_fd_arms = func {
	if (getprop("/autopilot-v/internal/fd-loc-armed")) {
		locdefl = getprop("/instrumentation/nav[0]/heading-needle-deflection-norm");
		locdefl_b = getprop("/instrumentation/nav[1]/heading-needle-deflection-norm");
		if ((locdefl < 0.9233) and (getprop("/instrumentation/nav[0]/signal-quality-norm") > 0.99) and (getprop("/it-autoflight/settings/use-nav2-radio") == 0)) {
			make_fd_loc_active();
		} else if ((locdefl_b < 0.9233) and (getprop("/instrumentation/nav[1]/signal-quality-norm") > 0.99) and (getprop("/it-autoflight/settings/use-nav2-radio") == 1)) {
			make_fd_loc_active();
		} else {
			return 0;
		}
	}
	if (getprop("/autopilot-v/internal/fd-appr-armed")) {
		signal = getprop("/instrumentation/nav[0]/gs-needle-deflection-norm");
		signal_b = getprop("/instrumentation/nav[1]/gs-needle-deflection-norm");
		if (((signal < 0 and signal >= -0.30) or (signal > 0 and signal <= 0.30)) and (getprop("/it-autoflight/settings/use-nav2-radio") == 0) and (getprop("/autopilot-v/internal/fd-lat") == 2)) {
			make_fd_appr_active();
		} else if (((signal_b < 0 and signal_b >= -0.30) or (signal_b > 0 and signal_b <= 0.30)) and (getprop("/it-autoflight/settings/use-nav2-radio") == 1) and (getprop("/autopilot-v/internal/fd-lat") == 2)) {
			make_fd_appr_active();
		} else {
			return 0;
		}
	}
}

var make_fd_loc_active = func {
	setprop("/autopilot-v/internal/fd-loc-armed", 0);
	setprop("/autopilot-v/internal/fd-lat", 2);
}

var make_fd_appr_active = func {
	setprop("/autopilot-v/internal/fd-appr-armed", 0);
	setprop("/autopilot-v/internal/fd-vert", 2);
	setprop("/autopilot-v/fd/alt-hld", 0);
}


# Timers
var update_fd_armst = maketimer(0.5, update_fd_arms);
