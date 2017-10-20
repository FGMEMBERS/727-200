# 727 Block V Autopilot/Flight Director
# IT-AUTOFLIGHT Based
# (c) Joshua Davidson (it0uchpods)

var pitch_knob = func {
	if (getprop("/it-autoflight/output/ap") == 1) {
		if (getprop("/autopilot-v/pitch-knob") == 1) {
			if (getprop("/it-autoflight/output/vert") == 0) {
				setprop("/autopilot-v/alt-sel-btn", 0);
			}
			if (getprop("/it-autoflight/output/vert") != 5) {
				setprop("/it-autoflight/input/vert", 5);
			}
		} else if (getprop("/autopilot-v/pitch-knob") == 2) {
			if (getprop("/it-autoflight/output/vert") == 0) {
				setprop("/autopilot-v/alt-sel-btn", 0);
			}
			if (getprop("/it-autoflight/output/vert") != 4) {
				setprop("/it-autoflight/input/vert", 4);
			}
		} else if (getprop("/autopilot-v/pitch-knob") == 3) {
			if ((getprop("/it-autoflight/output/vert") != 1 and getprop("/it-autoflight/output/vert") != 0) or getprop("/autopilot-v/alt-sel-btn") == 0) {
				setprop("/it-autoflight/input/vert", 1);
			}
		} else if (getprop("/autopilot-v/pitch-knob") == 4) {
			if (getprop("/it-autoflight/output/vert") == 0) {
				setprop("/autopilot-v/alt-sel-btn", 0);
			}
			if (getprop("/it-autoflight/output/vert") != 6) {
				setprop("/it-autoflight/input/vert", 6);
			}
		} else if (getprop("/autopilot-v/pitch-knob") == 5) {
			setprop("/autopilot-v/pitch-knob", 4);
		}
	} else {
		setprop("/autopilot-v/pitch-knob", 3);
	}
}

setlistener("/autopilot-v/pitch-knob", func {
	pitch_knob();
});

var roll_knob = func {
	if (getprop("/it-autoflight/output/ap") == 1) {
		if (getprop("/autopilot-v/roll-knob") == 1) {
			if (getprop("/autopilot-v/hdg-sel-btn") == 1) {
				setprop("/autopilot-v/hdg-sel-btn", 0);
			}
			setprop("/it-autoflight/input/lat", 1);
			setprop("/it-autoflight/settings/slave-gps-nav", 1);
			setprop("/it-autoflight/input/lat", 2);
			if (getprop("/it-autoflight/output/vert") == 2) {
				pitch_knob();
			}
		} else if (getprop("/autopilot-v/roll-knob") == 2) {
			if (getprop("/autopilot-v/hdg-sel-btn") == 1) {
				setprop("/autopilot-v/hdg-sel-btn", 0);
			}
			setprop("/it-autoflight/settings/slave-gps-nav", 0);
			setprop("/it-autoflight/input/lat", 2);
			if (getprop("/it-autoflight/output/vert") == 2) {
				pitch_knob();
			}
		} else if (getprop("/autopilot-v/roll-knob") == 3) {
			setprop("/it-autoflight/settings/slave-gps-nav", 0);
			if (getprop("/autopilot-v/hdg-sel-btn") != 1) {
				setprop("/it-autoflight/input/lat", 1);
			}
			if (getprop("/it-autoflight/output/vert") == 2) {
				pitch_knob();
			}
		} else if (getprop("/autopilot-v/roll-knob") == 4) {
			setprop("/it-autoflight/settings/slave-gps-nav", 0);
			setprop("/it-autoflight/input/vert", 2);
		} else if (getprop("/autopilot-v/roll-knob") == 5) {
			setprop("/it-autoflight/settings/slave-gps-nav", 0);
			setprop("/it-autoflight/input/vert", 2);
		}
	} else {
		setprop("/autopilot-v/roll-knob", 3);
	}
}

setlistener("/autopilot-v/roll-knob", func {
	roll_knob();
});

setlistener("/autopilot-v/hdg-sel-btn", func {
	if (getprop("/it-autoflight/output/ap") == 1) {
		if (getprop("/autopilot-v/hdg-sel-btn") == 1) {
			setprop("/autopilot-v/roll-knob", 3);
			setprop("/it-autoflight/input/lat", 0);
		} else if (getprop("/autopilot-v/hdg-sel-btn") == 0) {
			roll_knob();
		}
	} else {
		if (getprop("/autopilot-v/hdg-sel-btn") == 1) {
			setprop("/autopilot-v/hdg-sel-btn", 0);
		}
	}
});

setlistener("/autopilot-v/alt-sel-btn", func {
	if (getprop("/it-autoflight/output/ap") == 1) {
		if (getprop("/autopilot-v/alt-sel-btn") == 1) {
			setprop("/it-autoflight/input/alt-arm", 1);
		} else if (getprop("/autopilot-v/alt-sel-btn") == 0) {
			setprop("/it-autoflight/input/alt-arm", 0);
			if (getprop("/it-autoflight/output/vert") == 0) {
				pitch_knob();
			}
		}
	} else {
		if (getprop("/autopilot-v/alt-sel-btn") == 1) {
			setprop("/autopilot-v/alt-sel-btn", 0);
		}
	}
});

var altCapture = func {
	altcaptt.stop();
	setprop("/autopilot-v/pitch-knob", 3);
	setprop("/it-autoflight/input/vert", 3);
}
