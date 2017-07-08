var rudder_listener=nil;
var aileron_listener=nil;
var aileron_transfer=nil;

var rudder_steering=func() {
	if (getprop("voodoomaster/steering-mode-rudder")) {
		setprop("voodoomaster/steering-mode-aileron", 'false');
		if (aileron_transfer != nil) {
			removelistener(aileron_transfer);
			aileron_transfer=nil;
		}
	}
}

var aileron_steering=func() {
	if (getprop("voodoomaster/steering-mode-aileron")) {
		setprop("voodoomaster/steering-mode-rudder", 'false');
		aileron_transfer=setlistener("controls/flight/aileron", rudder_it);
	}
}

var rudder_it=func() {
print("ticker");
	var theWheel=getprop("voodoomaster/steering-wheel");
	if (getprop("gear/gear["~theWheel~"]/wow")) {
		setprop("controls/flight/rudder", getprop("controls/flight/aileron"));
	}
}

rudder_listener=setlistener("voodoomaster/steering-mode-rudder", rudder_steering);
aileron_listener=setlistener("voodoomaster/steering-mode-aileron", aileron_steering);

