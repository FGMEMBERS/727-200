# Temporary until proper systems are available

var doMagicStartup = func {
	setprop("/controls/engines/engine[0]/starter", "true");
	setprop("/controls/engines/engine[1]/starter", "true");
	setprop("/controls/engines/engine[2]/starter", "true");
	settimer(func {
		setprop("/controls/engines/engine[0]/cutoff", "false");
		setprop("/controls/engines/engine[1]/cutoff", "false");
		setprop("/controls/engines/engine[2]/cutoff", "false");
	}, 10);
}