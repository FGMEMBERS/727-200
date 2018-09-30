# 727 Heating
# Jonathan Redpath

var oat = getprop("/environment/temperature-degc");
var L1Anti = 0;
var L2Anti = 0;
var R1Anti = 0;
var R2Anti = 0;
var L1temp = 0;
var L2temp = 0;
var L3temp = 0;
var L4temp = 0;
var L5temp = 0;
var R1temp = 0;
var R2temp = 0;
var R3temp = 0;
var R4temp = 0;
var R5temp = 0;
var L1sw = 0;
var L2sw = 0;
var R1sw = 0;
var R2sw = 0;
var test = 0;
var ovht1 = 0;
var ovht2 = 0;
var ovht3 = 0;
var ovht4 = 0;
var heatingfactor = 0;
var oat = 0;
densityAtmo = 0;
ambientTemp = 0;
var maxTemp = 43;
var ovhtDisco = 58;
var EyeBrowMax = 38;
var cabinTemp = 21;
var densityAtmo = 0;
var ambientTemp = 0;
	
var HEAT = {
	init: func() {
		# basic system
		setprop("/systems/heat/window/L1antiIce", 0); # we will assume sys 1 controls the windows and sys 2 the eyebrows
		setprop("/systems/heat/window/L2antiIce", 0);
		setprop("/systems/heat/window/R1antiIce", 0);
		setprop("/systems/heat/window/R2antiIce", 0);
		# temperatures
		setprop("/systems/heat/window/L1temp", oat);
		setprop("/systems/heat/window/L2temp", oat);
		setprop("/systems/heat/window/L3temp", oat);
		setprop("/systems/heat/window/L4temp", oat);
		setprop("/systems/heat/window/L5temp", oat);
		setprop("/systems/heat/window/R1temp", oat);
		setprop("/systems/heat/window/R2temp", oat);
		setprop("/systems/heat/window/R3temp", oat);
		setprop("/systems/heat/window/R4temp", oat);
		setprop("/systems/heat/window/R5temp", oat);
		# overhead panel switches
		setprop("/controls/heat/window/switches/L1", 0);
		setprop("/controls/heat/window/switches/L2", 0);
		setprop("/controls/heat/window/switches/R1", 0);
		setprop("/controls/heat/window/switches/R2", 0);
		setprop("/controls/heat/window/switches/test", 0); # can be -1 or 1 or 0
		# lamps
		setprop("/controls/heat/window/lamps/L1ovht", 0);
		setprop("/controls/heat/window/lamps/L2ovht", 0);
		setprop("/controls/heat/window/lamps/R1ovht", 0);
		setprop("/controls/heat/window/lamps/L2ovht", 0);
		setprop("/controls/heat/window/lamps/L1on", 0);
		setprop("/controls/heat/window/lamps/L2on", 0);
		setprop("/controls/heat/window/lamps/R1on", 0);
		setprop("/controls/heat/window/lamps/R2on", 0);
	},
	loop: func() {
		L1Anti = getprop("/systems/heat/window/L1antiIce");
		L2Anti = getprop("/systems/heat/window/L2antiIce");
		R1Anti = getprop("/systems/heat/window/R1antiIce");
		R2Anti = getprop("/systems/heat/window/R2antiIce");
		L1temp = getprop("/systems/heat/window/L1temp");
		L2temp = getprop("/systems/heat/window/L2temp");
		L3temp = getprop("/systems/heat/window/L3temp");
		L4temp = getprop("/systems/heat/window/L4temp");
		L5temp = getprop("/systems/heat/window/L5temp");
		R1temp = getprop("/systems/heat/window/R1temp");
		R2temp = getprop("/systems/heat/window/R2temp");
		R3temp = getprop("/systems/heat/window/R3temp");
		R4temp = getprop("/systems/heat/window/R4temp");
		R5temp = getprop("/systems/heat/window/R5temp");
		L1sw = getprop("/controls/heat/window/switches/L1");
		L2sw = getprop("/controls/heat/window/switches/L2");
		R1sw = getprop("/controls/heat/window/switches/R1");
		R2sw = getprop("/controls/heat/window/switches/R2");
		test = getprop("/controls/heat/window/switches/test");
		ovht1 = getprop("/controls/heat/window/lamps/L1ovht");
		ovht2 = getprop("/controls/heat/window/lamps/L2ovht");
		ovht3 = getprop("/controls/heat/window/lamps/R1ovht");
		ovht4 = getprop("/controls/heat/window/lamps/L2ovht");
		heatingfactor = getprop("/systems/heat/heatingfactor");
		oat = getprop("environment/temperature-degc");
		maxTemp = 43;
		ovhtDisco = 58;
		EyeBrowMax = 38;
		cabinTemp = 21;
		densityAtmo = getprop("atmosphere/rho-slugs_ft3");
		ambientTemp = getprop("environment/temperature-degc");
		# ac1 = getprop("/systems/electrical/bus/ac1");
		# ac2 = getprop("/systems/electrical/bus/ac2");
		# ac3 = getprop("/systems/electrical/bus/ac3");
		
		if (L1sw and !ovht1) {
			setprop("/systems/heat/window/L1antiIce", 1);
		}
		
		if (L2sw and !ovht2) {
			setprop("/systems/heat/window/L2antiIce", 1);
		}
		
		if (R1sw and !ovht3) {
			setprop("/systems/heat/window/R1antiIce", 1);
		}
		
		if (R2sw and !ovht4) {
			setprop("/systems/heat/window/R2antiIce", 1);
		}
		
		if (L1Anti and L1temp < maxTemp) {
			setprop("/systems/heat/window/L1temp", L1temp + heatingfactor);
		} else if (L1Anti and L1temp >= maxTemp) {
			setprop("/systems/heat/window/L1temp", maxTemp);
		} else if (!L1Anti and L1temp >= oat) {
			setprop("/systems/heat/window/L1temp", L1temp - heatingfactor);
		} else if (!L1Anti and L1temp <= oat) {
			setprop("/systems/heat/window/L1temp", oat);
		} else {
			print("Heating: Unknown condition!")
		}
		
		if (L1Anti and L2temp < maxTemp) {
			setprop("/systems/heat/window/L2temp", L2temp + heatingfactor);
		} else if (L1Anti and L2temp >= maxTemp) {
			setprop("/systems/heat/window/L2temp", maxTemp);
		} else if (!L1Anti and L2temp >= oat) {
			setprop("/systems/heat/window/L2temp", L2temp - heatingfactor);
		} else if (!L1Anti and L2temp <= oat) {
			setprop("/systems/heat/window/L2temp", oat);
		} else {
			print("Heating: Unknown condition!")
		}
		
		setprop("/systems/heat/window/L3temp", oat); # Window 3 on both sides has no heating
		
		if (R1Anti and R1temp < maxTemp) {
			setprop("/systems/heat/window/R1temp", R1temp + heatingfactor);
		} else if (R1Anti and R1temp >= maxTemp) {
			setprop("/systems/heat/window/R1temp", maxTemp);
		} else if (!R1Anti and R1temp >= oat) {
			setprop("/systems/heat/window/R1temp", R1temp - heatingfactor);
		} else if (!R1Anti and R1temp <= oat) {
			setprop("/systems/heat/window/R1temp", oat);
		} else {
			print("Heating: Unknown condition!")
		}
		
		if (R1Anti and R2temp < maxTemp) {
			setprop("/systems/heat/window/R2temp", R2temp + heatingfactor);
		} else if (R1Anti and R2temp >= maxTemp) {
			setprop("/systems/heat/window/R2temp", maxTemp);
		} else if (!R1Anti and R2temp >= oat) {
			setprop("/systems/heat/window/R2temp", R2temp - heatingfactor);
		} else if (!R1Anti and R2temp <= oat) {
			setprop("/systems/heat/window/R2temp", oat);
		} else {
			print("Heating: Unknown condition!")
		}
		
		setprop("/systems/heat/window/R3temp", oat); # Window 3 on both sides has no heating
		
		if (L2Anti and L4temp < EyeBrowMax) {
			setprop("/systems/heat/window/L4temp", L4temp + heatingfactor);
		} else if (L2Anti and L4temp >= EyeBrowMax) {
			setprop("/systems/heat/window/L4temp", EyeBrowMax);
		} else if (!L2Anti and L4temp >= oat) {
			setprop("/systems/heat/window/L4temp", L4temp - heatingfactor);
		} else if (!L2Anti and L4temp <= oat) {
			setprop("/systems/heat/window/L4temp", oat);
		} else {
			print("Heating: Unknown condition!")
		}
		
		if (L2Anti and L5temp < EyeBrowMax) {
			setprop("/systems/heat/window/L5temp", L5temp + heatingfactor);
		} else if (L2Anti and L5temp >= EyeBrowMax) {
			setprop("/systems/heat/window/L5temp", EyeBrowMax);
		} else if (!L2Anti and L5temp >= oat) {
			setprop("/systems/heat/window/L5temp", L5temp - heatingfactor);
		} else if (!L2Anti and L5temp <= oat) {
			setprop("/systems/heat/window/L5temp", oat);
		} else {
			print("Heating: Unknown condition!")
		}
		
		if (R2Anti and R4temp < EyeBrowMax) {
			setprop("/systems/heat/window/R4temp", R4temp + heatingfactor);
		} else if (R2Anti and R4temp >= EyeBrowMax) {
			setprop("/systems/heat/window/R4temp", EyeBrowMax);
		} else if (!R2Anti and R4temp >= oat) {
			setprop("/systems/heat/window/R4temp", R4temp - heatingfactor);
		} else if (!R2Anti and R4temp <= oat) {
			setprop("/systems/heat/window/R4temp", oat);
		} else {
			print("Heating: Unknown condition!")
		}
		
		if (R2Anti and R5temp < EyeBrowMax) {
			setprop("/systems/heat/window/R5temp", R5temp + heatingfactor);
		} else if (R2Anti and R5temp >= EyeBrowMax) {
			setprop("/systems/heat/window/R5temp", EyeBrowMax);
		} else if (!R2Anti and R5temp >= oat) {
			setprop("/systems/heat/window/R5temp", R5temp - heatingfactor);
		} else if (!R2Anti and R5temp <= oat) {
			setprop("/systems/heat/window/R5temp", oat);
		} else {
			print("Heating: Unknown condition!")
		}
		
		if (test == -1) { # ovht test
			setprop("/controls/heat/window/lamps/L1ovht", 1);
			setprop("/controls/heat/window/lamps/L2ovht", 1);
			setprop("/controls/heat/window/lamps/R1ovht", 1);
			setprop("/controls/heat/window/lamps/L2ovht", 1);
			setprop("/controls/heat/window/lamps/L1on", 0);
			setprop("/controls/heat/window/lamps/L2on", 0);
			setprop("/controls/heat/window/lamps/R1on", 0);
			setprop("/controls/heat/window/lamps/R2on", 0);
		}
		
		if (test == 1) { # power test
			setprop("/controls/heat/window/lamps/L1on", 1);
			setprop("/controls/heat/window/lamps/L2on", 1);
			setprop("/controls/heat/window/lamps/R1on", 1);
			setprop("/controls/heat/window/lamps/R2on", 1);
		}
		
		if (test == 0) {
			if (L1temp > 63) {
				setprop("/controls/heat/window/lamps/L1ovht", 1);
				setprop("/systems/heat/window/L1antiIce", 0);
			} else {
				setprop("/controls/heat/window/lamps/L1ovht", 0);
			}
			if (L2temp > 63) {
				setprop("/controls/heat/window/lamps/L2ovht", 1);
				setprop("/systems/heat/window/L2antiIce", 0);
			} else {
				setprop("/controls/heat/window/lamps/L2ovht", 0);
			}
			if (R1temp > 63) {
				setprop("/controls/heat/window/lamps/R1ovht", 1);
				setprop("/systems/heat/window/R1antiIce", 0);
			} else {
				setprop("/controls/heat/window/lamps/R1ovht", 0);
			}
			if (R2temp > 63) {
				setprop("/controls/heat/window/lamps/R2ovht", 1);
				setprop("/systems/heat/window/R2antiIce", 0);
			} else {
				setprop("/controls/heat/window/lamps/R2ovht", 0);
			}
			
			if (!L1sw) {
				setprop("/controls/heat/window/lamps/L1on", 0);
			} else if (L1sw) {
				setprop("/controls/heat/window/lamps/L1on", 1);
			}
			if (!L2sw) {
				setprop("/controls/heat/window/lamps/L2on", 0);
			} else if (L2sw) {
				setprop("/controls/heat/window/lamps/L2on", 1);
			}
			if (!R1sw) {
				setprop("/controls/heat/window/lamps/R1on", 0);
			} else if (R1sw) {
				setprop("/controls/heat/window/lamps/R1on", 1);
			}
			if (!R2sw) {
				setprop("/controls/heat/window/lamps/R2on", 0);
			} else if (R2sw) {
				setprop("/controls/heat/window/lamps/R2on", 1);
			}
		}
	},
};
