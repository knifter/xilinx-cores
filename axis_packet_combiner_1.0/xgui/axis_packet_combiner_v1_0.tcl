# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  set PACKETS_PER_PACKET [ipgui::add_param $IPINST -name "PACKETS_PER_PACKET" -parent ${Page_0}]
  set_property tooltip {Amount of packets to be combined in one packet (input packet size can be 1)} ${PACKETS_PER_PACKET}
  set AXIS_TDATA_WIDTH [ipgui::add_param $IPINST -name "AXIS_TDATA_WIDTH" -parent ${Page_0}]
  set_property tooltip {S_AXIS & M_AXIS Data Width} ${AXIS_TDATA_WIDTH}
  set DISCARD_FIRST_PACKET [ipgui::add_param $IPINST -name "DISCARD_FIRST_PACKET" -parent ${Page_0} -widget checkBox]
  set_property tooltip {Discard all data upto first TLAST=1 as it might be an incomplete packet} ${DISCARD_FIRST_PACKET}


}

proc update_PARAM_VALUE.AXIS_TDATA_WIDTH { PARAM_VALUE.AXIS_TDATA_WIDTH } {
	# Procedure called to update AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXIS_TDATA_WIDTH { PARAM_VALUE.AXIS_TDATA_WIDTH } {
	# Procedure called to validate AXIS_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.DISCARD_FIRST_PACKET { PARAM_VALUE.DISCARD_FIRST_PACKET } {
	# Procedure called to update DISCARD_FIRST_PACKET when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DISCARD_FIRST_PACKET { PARAM_VALUE.DISCARD_FIRST_PACKET } {
	# Procedure called to validate DISCARD_FIRST_PACKET
	return true
}

proc update_PARAM_VALUE.PACKETS_PER_PACKET { PARAM_VALUE.PACKETS_PER_PACKET } {
	# Procedure called to update PACKETS_PER_PACKET when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PACKETS_PER_PACKET { PARAM_VALUE.PACKETS_PER_PACKET } {
	# Procedure called to validate PACKETS_PER_PACKET
	return true
}


proc update_MODELPARAM_VALUE.AXIS_TDATA_WIDTH { MODELPARAM_VALUE.AXIS_TDATA_WIDTH PARAM_VALUE.AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.PACKETS_PER_PACKET { MODELPARAM_VALUE.PACKETS_PER_PACKET PARAM_VALUE.PACKETS_PER_PACKET } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PACKETS_PER_PACKET}] ${MODELPARAM_VALUE.PACKETS_PER_PACKET}
}

proc update_MODELPARAM_VALUE.DISCARD_FIRST_PACKET { MODELPARAM_VALUE.DISCARD_FIRST_PACKET PARAM_VALUE.DISCARD_FIRST_PACKET } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DISCARD_FIRST_PACKET}] ${MODELPARAM_VALUE.DISCARD_FIRST_PACKET}
}

