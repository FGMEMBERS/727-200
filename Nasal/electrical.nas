# 727 Electrical System
# Joshua Davidson (it0uchpods)

#############
# Init Vars #
#############

var ac_volt_std = 115;
var ac_volt_min = 110;
var dc_volt_std = 28;
var dc_volt_min = 25;
var dc_amps_std = 150;
var ac_hz_std = 400;

setlistener("/sim/signals/fdm-initialized", func {
	var bustie1_sw = getprop("/controls/electrical/bustie1-switch", 0);
	var bustie2_sw = getprop("/controls/electrical/bustie2-switch", 0);
	var bustie3_sw = getprop("/controls/electrical/bustie3-switch", 0);
	var gentie1_sw = getprop("/controls/electrical/gentie1-switch", 0);
	var gentie2_sw = getprop("/controls/electrical/gentie2-switch", 0);
	var gentie3_sw = getprop("/controls/electrical/gentie3-switch", 0);
	var field1_sw = getprop("/controls/electrical/field1-switch", 0);
	var field2_sw = getprop("/controls/electrical/field2-switch", 0);
	var field3_sw = getprop("/controls/electrical/field3-switch", 0);
	var ess_pwr_knb = getprop("/controls/electrical/essential-pwr-knb", 1);
	var acmeter_knb = getprop("/controls/electrical/acmeter-knb", 1);
	var bustie1 = getprop("/systems/electrical/bustie1", 0);
	var bustie2 = getprop("/systems/electrical/bustie2", 0);
	var bustie3 = getprop("/systems/electrical/bustie3", 0);
	var gentie1 = getprop("/systems/electrical/gentie1", 0);
	var gentie2 = getprop("/systems/electrical/gentie2", 0);
	var gentie3 = getprop("/systems/electrical/gentie3", 0);
	var field1 = getprop("/systems/electrical/field1", 0);
	var field2 = getprop("/systems/electrical/field2", 0);
	var field3 = getprop("/systems/electrical/field3", 0);
	var ac1 = getprop("/systems/electrical/bus/ac1", 0);
	var ac2 = getprop("/systems/electrical/bus/ac2", 0);
	var ac3 = getprop("/systems/electrical/bus/ac3", 0);
	var ac_ess = getprop("/systems/electrical/bus/ac-ess", 0);
	var ac_stby = getprop("/systems/electrical/bus/ac-stby", 0);
	var sync = getprop("/systems/electrical/bus/sync", 0);
	var dc1 = getprop("/systems/electrical/bus/dc1", 0);
	var dc2 = getprop("/systems/electrical/bus/dc2", 0);
	var dc3 = getprop("/systems/electrical/bus/dc3", 0);
	var dc_ess = getprop("/systems/electrical/bus/dc-ess", 0);
	var dc_stby = getprop("/systems/electrical/bus/dc-stby", 0);
	var n2_1 = getprop("/engines/engine[0]/n2");
	var n2_2 = getprop("/engines/engine[1]/n2");
	var n2_3 = getprop("/engines/engine[2]/n2");
});

var elec_init = func {
	setprop("/controls/electrical/bustie1-switch", 0);
	setprop("/controls/electrical/bustie2-switch", 0);
	setprop("/controls/electrical/bustie3-switch", 0);
	setprop("/controls/electrical/gentie1-switch", 0);
	setprop("/controls/electrical/gentie2-switch", 0);
	setprop("/controls/electrical/gentie3-switch", 0);
	setprop("/controls/electrical/field1-switch", 0);
	setprop("/controls/electrical/field2-switch", 0);
	setprop("/controls/electrical/field3-switch", 0);
	setprop("/controls/electrical/essential-pwr-knb", 1);
	setprop("/controls/electrical/acmeter-knb", 1);
	setprop("/systems/electrical/bustie1", 0);
	setprop("/systems/electrical/bustie2", 0);
	setprop("/systems/electrical/bustie3", 0);
	setprop("/systems/electrical/gentie1", 0);
	setprop("/systems/electrical/gentie2", 0);
	setprop("/systems/electrical/gentie3", 0);
	setprop("/systems/electrical/field1", 0);
	setprop("/systems/electrical/field2", 0);
	setprop("/systems/electrical/field3", 0);
	setprop("/systems/electrical/bus/ac1", 0);
	setprop("/systems/electrical/bus/ac2", 0);
	setprop("/systems/electrical/bus/ac3", 0);
	setprop("/systems/electrical/bus/ac-ess", 0);
	setprop("/systems/electrical/bus/ac-stby", 0);
	setprop("/systems/electrical/bus/sync", 0);
	setprop("/systems/electrical/bus/dc1", 0);
	setprop("/systems/electrical/bus/dc2", 0);
	setprop("/systems/electrical/bus/dc3", 0);
	setprop("/systems/electrical/bus/dc-ess", 0);
	setprop("/systems/electrical/bus/dc-stby", 0);
	# Below are standard FG Electrical stuff to keep things working when the plane is powered
    setprop("/systems/electrical/outputs/adf", 0);
    setprop("/systems/electrical/outputs/audio-panel", 0);
    setprop("/systems/electrical/outputs/audio-panel[1]", 0);
    setprop("/systems/electrical/outputs/autopilot", 0);
    setprop("/systems/electrical/outputs/avionics-fan", 0);
    setprop("/systems/electrical/outputs/beacon", 0);
    setprop("/systems/electrical/outputs/bus", 0);
    setprop("/systems/electrical/outputs/cabin-lights", 0);
    setprop("/systems/electrical/outputs/dme", 0);
    setprop("/systems/electrical/outputs/efis", 0);
    setprop("/systems/electrical/outputs/flaps", 0);
    setprop("/systems/electrical/outputs/fuel-pump", 0);
    setprop("/systems/electrical/outputs/fuel-pump[1]", 0);
    setprop("/systems/electrical/outputs/gps", 0);
    setprop("/systems/electrical/outputs/gps-mfd", 0);
    setprop("/systems/electrical/outputs/hsi", 0);
    setprop("/systems/electrical/outputs/instr-ignition-switch", 0);
    setprop("/systems/electrical/outputs/instrument-lights", 0);
    setprop("/systems/electrical/outputs/landing-lights", 0);
    setprop("/systems/electrical/outputs/map-lights", 0);
    setprop("/systems/electrical/outputs/mk-viii", 0);
    setprop("/systems/electrical/outputs/nav", 0);
    setprop("/systems/electrical/outputs/nav[1]", 0);
    setprop("/systems/electrical/outputs/pitot-head", 0);
    setprop("/systems/electrical/outputs/stobe-lights", 0);
    setprop("/systems/electrical/outputs/tacan", 0);
    setprop("/systems/electrical/outputs/taxi-lights", 0);
    setprop("/systems/electrical/outputs/transponder", 0);
    setprop("/systems/electrical/outputs/turn-coordinator", 0);
	elec_timer.start();
}

######################
# Main Electric Loop #
######################

var master_elec = func {
	bustie1_sw = getprop("/controls/electrical/bustie1-switch", 0);
	bustie2_sw = getprop("/controls/electrical/bustie2-switch", 0);
	bustie3_sw = getprop("/controls/electrical/bustie3-switch", 0);
	gentie1_sw = getprop("/controls/electrical/gentie1-switch", 0);
	gentie2_sw = getprop("/controls/electrical/gentie2-switch", 0);
	gentie3_sw = getprop("/controls/electrical/gentie3-switch", 0);
	field1_sw = getprop("/controls/electrical/field1-switch", 0);
	field2_sw = getprop("/controls/electrical/field2-switch", 0);
	field3_sw = getprop("/controls/electrical/field3-switch", 0);
	ess_pwr_knb = getprop("/controls/electrical/essential-pwr-knb", 1);
	acmeter_knb = getprop("/controls/electrical/acmeter-knb", 1);
	bustie1 = getprop("/systems/electrical/bustie1", 0);
	bustie2 = getprop("/systems/electrical/bustie2", 0);
	bustie3 = getprop("/systems/electrical/bustie3", 0);
	gentie1 = getprop("/systems/electrical/gentie1", 0);
	gentie2 = getprop("/systems/electrical/gentie2", 0);
	gentie3 = getprop("/systems/electrical/gentie3", 0);
	field1 = getprop("/systems/electrical/field1", 0);
	field2 = getprop("/systems/electrical/field2", 0);
	field3 = getprop("/systems/electrical/field3", 0);
	ac1 = getprop("/systems/electrical/bus/ac1", 0);
	ac2 = getprop("/systems/electrical/bus/ac2", 0);
	ac3 = getprop("/systems/electrical/bus/ac3", 0);
	ac_ess = getprop("/systems/electrical/bus/ac-ess", 0);
	ac_stby = getprop("/systems/electrical/bus/ac-stby", 0);
	sync = getprop("/systems/electrical/bus/sync", 0);
	dc1 = getprop("/systems/electrical/bus/dc1", 0);
	dc2 = getprop("/systems/electrical/bus/dc2", 0);
	dc3 = getprop("/systems/electrical/bus/dc3", 0);
	dc_ess = getprop("/systems/electrical/bus/dc-ess", 0);
	dc_stby = getprop("/systems/electrical/bus/dc-stby", 0);
	n2_1 = getprop("/engines/engine[0]/n2");
	n2_2 = getprop("/engines/engine[1]/n2");
	n2_3 = getprop("/engines/engine[2]/n2");
}

###################
# Update Function #
###################

var update_electrical = func {
	master_elec();
}

##########
# Timers #
##########

var elec_timer = maketimer(0.2, update_electrical);