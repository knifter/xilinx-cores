# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "TWOS_COMPL" -parent ${Page_0}
  ipgui::add_param $IPINST -name "AXIS_TDATA_WIDTH" -parent ${Page_0}
  set CLOCK_DETECT_CYCLES [ipgui::add_param $IPINST -name "CLOCK_DETECT_CYCLES" -parent ${Page_0}]
  set_property tooltip {Amount of aclk cycles to wait for ds_clk for clock-detection} ${CLOCK_DETECT_CYCLES}


}

proc update_PARAM_VALUE.AXIS_TDATA_WIDTH { PARAM_VALUE.AXIS_TDATA_WIDTH } {
	# Procedure called to update AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXIS_TDATA_WIDTH { PARAM_VALUE.AXIS_TDATA_WIDTH } {
	# Procedure called to validate AXIS_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.CLOCK_DETECT_CYCLES { PARAM_VALUE.CLOCK_DETECT_CYCLES } {
	# Procedure called to update CLOCK_DETECT_CYCLES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CLOCK_DETECT_CYCLES { PARAM_VALUE.CLOCK_DETECT_CYCLES } {
	# Procedure called to validate CLOCK_DETECT_CYCLES
	return true
}

proc update_PARAM_VALUE.TWOS_COMPL { PARAM_VALUE.TWOS_COMPL } {
	# Procedure called to update TWOS_COMPL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TWOS_COMPL { PARAM_VALUE.TWOS_COMPL } {
	# Procedure called to validate TWOS_COMPL
	return true
}


proc update_MODELPARAM_VALUE.AXIS_TDATA_WIDTH { MODELPARAM_VALUE.AXIS_TDATA_WIDTH PARAM_VALUE.AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.TWOS_COMPL { MODELPARAM_VALUE.TWOS_COMPL PARAM_VALUE.TWOS_COMPL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TWOS_COMPL}] ${MODELPARAM_VALUE.TWOS_COMPL}
}

proc update_MODELPARAM_VALUE.CLOCK_DETECT_CYCLES { MODELPARAM_VALUE.CLOCK_DETECT_CYCLES PARAM_VALUE.CLOCK_DETECT_CYCLES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CLOCK_DETECT_CYCLES}] ${MODELPARAM_VALUE.CLOCK_DETECT_CYCLES}
}

