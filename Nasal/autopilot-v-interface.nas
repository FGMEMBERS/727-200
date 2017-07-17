# 727 Block V Autopilot
# IT-AUTOFLIGHT Based
# Joshua Davidson (it0uchpods)

var pitch_knob = func {
	if (getprop("/autopilot-v/pitch-knob") == 1) {
		if (getprop("/it-autoflight/output/vert") == 0) {
			setprop("/autopilot-v/alt-sel-btn", 0);
		}
		setprop("/it-autoflight/input/vert", 5);
	} else if (getprop("/autopilot-v/pitch-knob") == 2) {
		if (getprop("/it-autoflight/output/vert") == 0) {
			setprop("/autopilot-v/alt-sel-btn", 0);
		}
		setprop("/it-autoflight/input/vert", 4);
	} else if (getprop("/autopilot-v/pitch-knob") == 3) {
		if (getprop("/it-autoflight/output/vert") == 0) {
			setprop("/autopilot-v/alt-sel-btn", 0);
		}
		setprop("/it-autoflight/input/vert", 1);
	} else if (getprop("/autopilot-v/pitch-knob") == 4) {
		if (getprop("/it-autoflight/output/vert") == 0) {
			setprop("/autopilot-v/alt-sel-btn", 0);
		}
		setprop("/it-autoflight/input/vert", 6);
	} else if (getprop("/autopilot-v/pitch-knob") == 5) {
		setprop("/autopilot-v/pitch-knob", 4);
	}
}

setlistener("/autopilot-v/pitch-knob", func {
	pitch_knob();
});

var roll_knob = func {
	if (getprop("/autopilot-v/roll-knob") == 1) {
		setprop("/autopilot-v/hdg-sel-btn", 0);
		setprop("/it-autoflight/input/lat", 1);
		setprop("/it-autoflight/settings/slave-gps-nav", 1);
		setprop("/it-autoflight/input/lat", 2);
	} else if (getprop("/autopilot-v/roll-knob") == 2) {
		setprop("/autopilot-v/hdg-sel-btn", 0);
		setprop("/it-autoflight/settings/slave-gps-nav", 0);
		setprop("/it-autoflight/input/lat", 2);
	} else if (getprop("/autopilot-v/roll-knob") == 3) {
		setprop("/autopilot-v/hdg-sel-btn", 0);
		setprop("/it-autoflight/input/lat", 1);
	} else if (getprop("/autopilot-v/roll-knob") == 4) {
		setprop("/it-autoflight/input/vert", 2);
	} else if (getprop("/autopilot-v/roll-knob") == 5) {
		setprop("/it-autoflight/input/vert", 2);
	}
}

setlistener("/autopilot-v/roll-knob", func {
	roll_knob();
});

setlistener("/autopilot-v/hdg-sel-btn", func {
	if (getprop("/autopilot-v/hdg-sel-btn") == 1) {
		setprop("/it-autoflight/input/lat", 0);
	} else if (getprop("/autopilot-v/hdg-sel-btn") == 0) {
		setprop("/it-autoflight/input/lat", 0);
		roll_knob();
	}
});

setlistener("/autopilot-v/alt-sel-btn", func {
	if (getprop("/autopilot-v/alt-sel-btn") == 1) {
		setprop("/it-autoflight/input/alt-arm", 1);
	} else if (getprop("/autopilot-v/alt-sel-btn") == 0) {
		setprop("/it-autoflight/input/alt-arm", 0);
		if (getprop("/it-autoflight/output/vert") != 0) {
			pitch_knob();
		}
	}
});

var altCapture = func {
	setprop("/autopilot-v/pitch-knob", 3);
	setprop("/autopilot-v/alt-sel-btn", 1);
	setprop("/it-autoflight/input/vert", 3);
}
