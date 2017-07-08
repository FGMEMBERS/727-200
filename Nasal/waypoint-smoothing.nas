################################################################################
#
# Waypoint Smoothing
#
# Copyright (c) 2015, Richard Senior
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
# MA 02110-1301, USA.
#
# Usage:
#
# Add this script to the aircraft-set.xml file, in the Nasal section.
#
# <nasal>
#     <MyAircraft>
#         <file>Nasal/waypoint-smoothing.nas</file>
#     </MyAircraft>
# </nasal>
#
# No other configuration is required. Smoothing is activated with the route
# manager and deactivated when the route is deactivated after landing. This
# assumes the autopilot uses (controls/autoflight/bank-angle-select) for its
# bank angle limits.
#
# Configuration:
#
# The following can be added to the aircraft-set.xml to customize defaults,
# but it is not necessary to do so.
#
# <autopilot>
#     <route-manager>
#         <smoothing>
#             <sharp-turn-threshold type="int">120</sharp-turn-threshold>
#             <sharp-turn-lead-time type="double">5.0</sharp-turn-lead-time>
#             <smooth-turn-lead-time type="double">5.0</smooth-turn-lead-time>
#         </smoothing>
#     </route-manager>
# </autopilot>
#
# A waypoint transition will not be smoothed if the difference between the
# bearing inbound (not necessarily the leg bearing) and the bearing outbound
# is greater than (sharp-turn-threshold). The idea is to allow fly-through
# waypoints as encountered in some STAR routes.

# In the case of sharp turns, the transition is led by a small number of
# seconds (sharp-turn-lead-time) to avoid S-turns at the waypoint.
#
# For smooth turns, a lead time is configurable as (smooth-turn-lead-time) to
# account for the delay in getting in and out of the turn. The early
# transition of a waypoint is calculated with a theoretical turn radius and
# failing to account for a lead-in and lead-out causes the turn to be made
# slightly late. If your aircraft is consistently turning late, increase
# (smooth-turn-lead-time).
#
# Note that turn radius is calculated on the property
# (controls/autoflight/bank-angle-select). It is assumed that this property
# is configured (default is 30) and used to set the bank angle on the
# autopilot. If not, just set it to whatever fixed bank your autopilot uses.
#
# Smoothing can be turned on and off during a route manager flight by setting
# the (autopilot/route-manager/smoothing/enabled) property to 1 and 0
# respectively.
#
# NOTE THAT USING NASAL IN THE ROUTE MANAGER IS NOT THE BEST SOLUTION TO THE
# WAYPOINT SMOOTHING PROBLEM BECAUSE OF NASAL GARBAGE COLLECTION DELAYS. THIS
# SCRIPT SHOULD BE CONSIDERED A TEMPORARY SOLUTION UNTIL WAYPOINT SMOOTHING IS
# BUILT INTO THE AUTOPILOT USING PROPERTY RULES.
#
################################################################################

################################################################################
# Property tree
################################################################################

var manager   = "autopilot/route-manager/";
var route     = "autopilot/route-manager/route/";
var smoothing = "autopilot/route-manager/smoothing/";

props.globals.initNode(smoothing~"enabled", 0, "BOOL");
props.globals.initNode(smoothing~"sharp-turn-threshold", 120.0, "DOUBLE");
props.globals.initNode(smoothing~"sharp-turn-lead-time", 5.0, "DOUBLE");
props.globals.initNode(smoothing~"smooth-turn-lead-time", 5.0, "DOUBLE");

################################################################################
# Helper functions
################################################################################

# Calculate the bearing from one leag bearing to the next
#
# @param from the start bearing
# @to the target bearing
# @return the bearing from start to target, i.e. the turn bearing
#
var bearing = func(from, to)
{
    var a = math.abs(math.mod(from - to, 360));
    var b = math.abs(math.mod(to - from, 360));
    return a < b ? a : b;
}

# Calculate the distance covered in a number of seconds
#
# @param s the number of seconds
# @return the distance covered in nm
#
var distance_in_seconds = func(s)
{
    var gs = getprop("velocities/groundspeed-kt");
    return (s / 3600) * gs;
}

# Check whether waypoint is first waypoint
#
# @param wp the waypoint
# @return true if this is the first waypoint
#
var is_initial_waypoint = func(wp)
{
    return wp == 0;
}

# Check whether waypoint is last waypoint
#
# @param wp the waypoint
# @return true if this is the last waypoint
#
var is_final_waypoint = func(wp)
{
    var final_wp = getprop(route, "num") - 1;
    return wp == final_wp;
}

# Get true airspeed
#
# @return true airspeed in knots
#
var tas = func()
{
    return getprop("instrumentation/airspeed-indicator/true-speed-kt");
}

# Calculate theoretical turn radius from true airspeed and bank angle
#
# @param tas true airspeed in knots
# @param bank_angle bank angle for autopilot turns
# @return theoretical turn radius in nm
#
var turn_radius_nm = func(tas, bank_angle)
{
    var g = 9.8066;                         # Gravitational acceleration (m/s^2)
    var v = tas * NM2M / 3600;              # Velocity (m/s)
    var a = D2R * bank_angle;               # Bank angle (radians)
    var r = (v * v) / (math.tan(a) * g);    # r = v^2 / tan(a) * g
    return r * M2NM;                        # Convert back to nm
}

################################################################################
# Waypoint Smoothing
################################################################################

# Check whether leg data is on next waypoint
#
# Version 3.4.0 of Flightgear changed the way leg data is stored in the
# route manager so that it is on the to waypoint rather than the from
# waypoint.
#
var leg_data_on_next_waypoint = func()
{
    var version = getprop("sim/version/flightgear");
    return cmp(version, '3.4.0') >= 0 or substr(version, 0, 2) == "20";
}

var smooth = func()
{
    setprop(smoothing~"active", 1);
    var enabled = getprop(smoothing, "enabled") or 0;
    if (!enabled) {
        setprop(smoothing~"active", 0);
        logprint(3, "Waypoint smoothing deactivated");
        return;
    }

    var wp = getprop(manager, "current-wp");
    var active = getprop(manager, "active");
    var airborne = getprop(manager, "airborne");
    var enroute = !is_initial_waypoint(wp) and !is_final_waypoint(wp);

    if (active and airborne and enroute and wp != nil) {
        var nw = wp + 1;
        var th = getprop("orientation/heading-deg");
        var ix = leg_data_on_next_waypoint() ? nw : wp;
        var nh = getprop(route, "wp["~ix~"]/leg-bearing-true-deg");
        var turn = bearing(from: nh, to: th);
        var dtw = getprop(manager, "wp/dist") or 9999;
        var sht = getprop(smoothing, "sharp-turn-threshold");
        if (turn < sht) {
            var sml = getprop(smoothing, "smooth-turn-lead-time");
            var a = getprop("controls/autoflight/bank-angle-select") or 30.0;
            var R = turn_radius_nm(tas(), a);
            var d = R * math.tan(D2R * turn / 2);
            var l = distance_in_seconds(sml);
            if (dtw <= d + l) {
                setprop(manager, "current-wp", nw);
            }
        } else {
            var shl = getprop(smoothing, "sharp-turn-lead-time");
            var l = distance_in_seconds(shl);
            if (dtw <= l) {
                setprop(manager, "current-wp", nw);
            }
        }
    }
    settimer(smooth, 1);
}

# Helper function to start smoothing if it is not already active
#
var start_smoothing = func()
{
    var active = getprop(manager, "smoothing/active") or 0;
    if (!active) {
        smooth();
        logprint(3, "Waypoint smoothing activated");
    }
}

################################################################################
# Listeners
################################################################################

var start_listeners = func()
{
    # Listener to enable smoothing when route manager is activated
    # and deactivate it when the route is deactivated
    #
    setlistener(manager~"active", func(route_manager_active) {
        setprop(smoothing~"enabled", route_manager_active.getValue());
    }, startup = 0, runtime = 0);

    # Listener to re-enable smoothing if the enabled flag is set true.
    # This might happen if smoothing is disabled during a flight and then
    # reactivated. Only activates smoothing if route manager is active.
    #
    setlistener(smoothing~"enabled", func(smoothing_enabled) {
        if (smoothing_enabled.getValue() and getprop(manager, "active")) {
            start_smoothing();
        }
    }, startup = 0, runtime = 0);
}

setlistener("sim/signals/reinit", func(status) {
    if (!status.getValue())
        start_listeners();
}, startup = 1, runtime = 0);

logprint(3, "Waypoint smoothing loaded");
