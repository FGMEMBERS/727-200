# B727 Main Libraries
# Joshua Davidson (it0uchpods)

#######################
# Various Other Stuff #
#######################
 
var systemsInit = func {
	setprop("/systems/electrical/bus-volts", 1);
    setprop("/systems/electrical/outputs/mk-viii", 28);
    setprop("/systems/electrical/outputs/efis", 28);
#	systems.ELEC.init();
	systems.HYD.init();
	systems.HEAT.init();
	autopilot_v.ap_init();
	var autopilot = gui.Dialog.new("sim/gui/dialogs/autopilot/dialog", "Aircraft/727-200/Systems/autopilot-dlg.xml");
	systemsLoop.start();
}

setlistener("/sim/signals/fdm-initialized", func {
	systemsInit();
});

var systemsLoop = maketimer(0.1, func {
	systems.HYD.loop();
	systems.HEAT.loop();
	
	var V = getprop("/velocities/groundspeed-kt");

	if (V > 15) {
		setprop("/systems/shake/effect", 1);
	} else {
		setprop("/systems/shake/effect", 0);
	}
});

if (getprop("/controls/flight/auto-coordination") == 1) {
	setprop("/controls/flight/auto-coordination", 0);
	setprop("/controls/flight/aileron-drives-tiller", 1);
} else {
	setprop("/controls/flight/aileron-drives-tiller", 0);
}

setprop("/systems/acconfig/libraries-loaded", 1);
