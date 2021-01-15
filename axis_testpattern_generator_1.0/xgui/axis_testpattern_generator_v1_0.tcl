# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "M00_AXIS_TDATA_WIDTH" -parent ${Page_0} -widget comboBox

  set COUNTER_START [ipgui::add_param $IPINST -name "COUNTER_START"]
  set_property tooltip {Where to begin counting} ${COUNTER_START}
  set COUNTER_END [ipgui::add_param $IPINST -name "COUNTER_END"]
  set_property tooltip {Where to end counting} ${COUNTER_END}
  set COUNTER_INCR [ipgui::add_param $IPINST -name "COUNTER_INCR"]
  set_property tooltip {Every clock counter increments by} ${COUNTER_INCR}
  ipgui::add_param $IPINST -name "DIVIDER"

}

proc update_PARAM_VALUE.COUNTER_END { PARAM_VALUE.COUNTER_END } {
	# Procedure called to update COUNTER_END when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.COUNTER_END { PARAM_VALUE.COUNTER_END } {
	# Procedure called to validate COUNTER_END
	return true
}

proc update_PARAM_VALUE.COUNTER_INCR { PARAM_VALUE.COUNTER_INCR } {
	# Procedure called to update COUNTER_INCR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.COUNTER_INCR { PARAM_VALUE.COUNTER_INCR } {
	# Procedure called to validate COUNTER_INCR
	return true
}

proc update_PARAM_VALUE.COUNTER_START { PARAM_VALUE.COUNTER_START } {
	# Procedure called to update COUNTER_START when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.COUNTER_START { PARAM_VALUE.COUNTER_START } {
	# Procedure called to validate COUNTER_START
	return true
}

proc update_PARAM_VALUE.DIVIDER { PARAM_VALUE.DIVIDER } {
	# Procedure called to update DIVIDER when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DIVIDER { PARAM_VALUE.DIVIDER } {
	# Procedure called to validate DIVIDER
	return true
}

proc update_PARAM_VALUE.M00_AXIS_TDATA_WIDTH { PARAM_VALUE.M00_AXIS_TDATA_WIDTH } {
	# Procedure called to update M00_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.M00_AXIS_TDATA_WIDTH { PARAM_VALUE.M00_AXIS_TDATA_WIDTH } {
	# Procedure called to validate M00_AXIS_TDATA_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.M00_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.M00_AXIS_TDATA_WIDTH PARAM_VALUE.M00_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.M00_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.M00_AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.COUNTER_START { MODELPARAM_VALUE.COUNTER_START PARAM_VALUE.COUNTER_START } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.COUNTER_START}] ${MODELPARAM_VALUE.COUNTER_START}
}

proc update_MODELPARAM_VALUE.COUNTER_END { MODELPARAM_VALUE.COUNTER_END PARAM_VALUE.COUNTER_END } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.COUNTER_END}] ${MODELPARAM_VALUE.COUNTER_END}
}

proc update_MODELPARAM_VALUE.COUNTER_INCR { MODELPARAM_VALUE.COUNTER_INCR PARAM_VALUE.COUNTER_INCR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.COUNTER_INCR}] ${MODELPARAM_VALUE.COUNTER_INCR}
}

proc update_MODELPARAM_VALUE.DIVIDER { MODELPARAM_VALUE.DIVIDER PARAM_VALUE.DIVIDER } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DIVIDER}] ${MODELPARAM_VALUE.DIVIDER}
}
