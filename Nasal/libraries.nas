# B727 Main Libraries
# Joshua Davidson (it0uchpods)

# :)
print(" ______ ___ ______    ___   ___   ___  ");
print("|____  |__ \____  |  |__ \ / _ \ / _ \ ");
print("    / /   ) |  / /_____ ) | | | | | | |");
print("   / /   / /  / /______/ /| | | | | | |");
print("  / /   / /_ / /      / /_| |_| | |_| |");
print(" /_/   |____/_/      |____|\___/ \___/ ");
print("-----------------------------------------------------------------------");
print("(c) 2017 Joshua Davidson");
print("-----------------------------------------------------------------------");
print(" ");

#######################
# Various Other Stuff #
#######################
 
setlistener("/sim/signals/fdm-initialized", func {
	setprop("/systems/electrical/bus-volts", 1);
    setprop("/systems/electrical/outputs/mk-viii", 28);
#	systems.elec_init();
	systems.hyd_init();
	autopilot_v.ap_init();
	var autopilot = gui.Dialog.new("sim/gui/dialogs/autopilot/dialog", "Aircraft/727-200/Systems/autopilot-dlg.xml");
	librariesLoop.start();
});

var librariesLoop = maketimer(0.1, func {
	var V = getprop("/velocities/groundspeed-kt");

	if (V > 15) {
		setprop("/systems/shake/effect", 1);
	} else {
		setprop("/systems/shake/effect", 0);
	}
});

var aglgears = func {
    var agl = getprop("/position/altitude-agl-ft") or 0;
    var aglft = agl - 19.801;  # is the position from the Boeing 727 above ground
    var aglm = aglft * 0.3048;
    setprop("/position/gear-agl-ft", aglft);
    setprop("/position/gear-agl-m", aglm);

    settimer(aglgears, 0.01);
}

aglgears();

