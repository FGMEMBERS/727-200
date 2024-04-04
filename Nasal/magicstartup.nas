var doMagicStartup = func {
	setprop("/controls/hydraulic/a-eng1-pump", 1);
	setprop("/controls/hydraulic/a-eng2-pump", 1);
	setprop("/controls/hydraulic/b-elec1-pump", 1);
	setprop("/controls/hydraulic/b-elec2-pump", 1);
	setprop("/controls/engines/engine[0]/cutoff", "false");
	setprop("/controls/engines/engine[1]/cutoff", "false");
	setprop("/controls/engines/engine[2]/cutoff", "false");
	setprop("/fdm/jsbsim/propulsion/set-running", 0);
	setprop("/fdm/jsbsim/propulsion/set-running", 1);
	setprop("/fdm/jsbsim/propulsion/set-running", 2);
	gui.popupTip("This plane is outdated and may not work properly anymore, please update to the newer 727");
}