# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Group
  set LabControl_Bus [ipgui::add_group $IPINST -name "LabControl Bus"]
  ipgui::add_param $IPINST -name "LC_ADDRESS" -parent ${LabControl_Bus}
  set TWOS_COMPL [ipgui::add_param $IPINST -name "TWOS_COMPL" -parent ${LabControl_Bus}]
  set_property tooltip {Sign Extend LabControl data up to AXIS data width} ${TWOS_COMPL}

  #Adding Group
  set asdf [ipgui::add_group $IPINST -name "asdf" -display_name {AXI4-Stream}]
  set_property tooltip {AXI4-Stream} ${asdf}
  ipgui::add_param $IPINST -name "AXIS_DATA_WIDTH" -parent ${asdf} -widget comboBox


}

proc update_PARAM_VALUE.AXIS_DATA_WIDTH { PARAM_VALUE.AXIS_DATA_WIDTH } {
	# Procedure called to update AXIS_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXIS_DATA_WIDTH { PARAM_VALUE.AXIS_DATA_WIDTH } {
	# Procedure called to validate AXIS_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.LC_ADDRESS { PARAM_VALUE.LC_ADDRESS } {
	# Procedure called to update LC_ADDRESS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LC_ADDRESS { PARAM_VALUE.LC_ADDRESS } {
	# Procedure called to validate LC_ADDRESS
	return true
}

proc update_PARAM_VALUE.LC_ADDR_WIDTH { PARAM_VALUE.LC_ADDR_WIDTH } {
	# Procedure called to update LC_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LC_ADDR_WIDTH { PARAM_VALUE.LC_ADDR_WIDTH } {
	# Procedure called to validate LC_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.LC_BUS_WIDTH { PARAM_VALUE.LC_BUS_WIDTH } {
	# Procedure called to update LC_BUS_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LC_BUS_WIDTH { PARAM_VALUE.LC_BUS_WIDTH } {
	# Procedure called to validate LC_BUS_WIDTH
	return true
}

proc update_PARAM_VALUE.LC_DATA_WIDTH { PARAM_VALUE.LC_DATA_WIDTH } {
	# Procedure called to update LC_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LC_DATA_WIDTH { PARAM_VALUE.LC_DATA_WIDTH } {
	# Procedure called to validate LC_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.LC_RESV_WIDTH { PARAM_VALUE.LC_RESV_WIDTH } {
	# Procedure called to update LC_RESV_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LC_RESV_WIDTH { PARAM_VALUE.LC_RESV_WIDTH } {
	# Procedure called to validate LC_RESV_WIDTH
	return true
}

proc update_PARAM_VALUE.LC_SBUS_WIDTH { PARAM_VALUE.LC_SBUS_WIDTH } {
	# Procedure called to update LC_SBUS_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LC_SBUS_WIDTH { PARAM_VALUE.LC_SBUS_WIDTH } {
	# Procedure called to validate LC_SBUS_WIDTH
	return true
}

proc update_PARAM_VALUE.TWOS_COMPL { PARAM_VALUE.TWOS_COMPL } {
	# Procedure called to update TWOS_COMPL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TWOS_COMPL { PARAM_VALUE.TWOS_COMPL } {
	# Procedure called to validate TWOS_COMPL
	return true
}


proc update_MODELPARAM_VALUE.AXIS_DATA_WIDTH { MODELPARAM_VALUE.AXIS_DATA_WIDTH PARAM_VALUE.AXIS_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXIS_DATA_WIDTH}] ${MODELPARAM_VALUE.AXIS_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.LC_DATA_WIDTH { MODELPARAM_VALUE.LC_DATA_WIDTH PARAM_VALUE.LC_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LC_DATA_WIDTH}] ${MODELPARAM_VALUE.LC_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.LC_ADDR_WIDTH { MODELPARAM_VALUE.LC_ADDR_WIDTH PARAM_VALUE.LC_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LC_ADDR_WIDTH}] ${MODELPARAM_VALUE.LC_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.LC_ADDRESS { MODELPARAM_VALUE.LC_ADDRESS PARAM_VALUE.LC_ADDRESS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LC_ADDRESS}] ${MODELPARAM_VALUE.LC_ADDRESS}
}

proc update_MODELPARAM_VALUE.LC_BUS_WIDTH { MODELPARAM_VALUE.LC_BUS_WIDTH PARAM_VALUE.LC_BUS_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LC_BUS_WIDTH}] ${MODELPARAM_VALUE.LC_BUS_WIDTH}
}

proc update_MODELPARAM_VALUE.LC_SBUS_WIDTH { MODELPARAM_VALUE.LC_SBUS_WIDTH PARAM_VALUE.LC_SBUS_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LC_SBUS_WIDTH}] ${MODELPARAM_VALUE.LC_SBUS_WIDTH}
}

proc update_MODELPARAM_VALUE.LC_RESV_WIDTH { MODELPARAM_VALUE.LC_RESV_WIDTH PARAM_VALUE.LC_RESV_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LC_RESV_WIDTH}] ${MODELPARAM_VALUE.LC_RESV_WIDTH}
}

proc update_MODELPARAM_VALUE.TWOS_COMPL { MODELPARAM_VALUE.TWOS_COMPL PARAM_VALUE.TWOS_COMPL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TWOS_COMPL}] ${MODELPARAM_VALUE.TWOS_COMPL}
}

