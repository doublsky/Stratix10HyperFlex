proc make_generic_assignments {} {
    set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
	set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 256
    set_global_assignment -name EDA_SIMULATION_TOOL "ModelSim-Altera (Verilog)"
    set_global_assignment -name EDA_TIME_SCALE "1 ps" -section_id eda_simulation
    set_global_assignment -name EDA_OUTPUT_DATA_FORMAT "VERILOG HDL" -section_id eda_simulation
    set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
    set_global_assignment -name MAX_CORE_JUNCTION_TEMP 100
    set_global_assignment -name POWER_AUTO_COMPUTE_TJ OFF
    set_global_assignment -name TOP_LEVEL_ENTITY top
    set_instance_assignment -name VIRTUAL_PIN ON -to * -entity top
    set_global_assignment -name FLOW_DISABLE_ASSEMBLER ON
    set_global_assignment -name FLOW_ENABLE_POWER_ANALYZER ON
}

proc make_S10_assignments {} {
	set_global_assignment -name FAMILY "Stratix 10"
	set_global_assignment -name DEVICE "1SG280LN3F43E1VG"	;# fastest
	#set_global_assignment -name DEVICE "1SG280LN3F43E3VG"	;# slowest

    set_global_assignment -name AUTO_SHIFT_REGISTER_RECOGNITION OFF
    set_global_assignment -name ALLOW_POWER_UP_DONT_CARE ON
    set_global_assignment -name SYNCHRONIZATION_REGISTER_CHAIN_LENGTH 1
    set_instance_assignment -name SYNCHRONIZER_IDENTIFICATION OFF -to * -entity top

    set_global_assignment -name FLOW_ENABLE_HYPER_RETIMER_FAST_FORWARD ON
}

proc create_project { src_dir } {
	project_new -overwrite top

    append inc_dir $src_dir "/inc"
    set_global_assignment -name SEARCH_PATH $inc_dir
    global env
    append common_dir $env(HFHOME) "/common"
    set_global_assignment -name SEARCH_PATH $common_dir

    append rtl_dir $src_dir "/rtl"
    foreach rtl [glob -nocomplain -dir $rtl_dir *.v] {
        set_global_assignment -name VERILOG_FILE $rtl
    }
    foreach rtl [glob -nocomplain -dir $rtl_dir *.sv] {
        set_global_assignment -name SYSTEMVERILOG_FILE $rtl
    }

    append sdc_dir $src_dir "/sdc"
    foreach sdc [glob -nocomplain -dir $sdc_dir *.sdc] {
        set_global_assignment -name SDC_FILE $sdc
    }

    foreach ip [glob -nocomplain -dir . *.ip] {
        set_global_assignment -name IP_FILE $ip
    }

    make_generic_assignments
    make_S10_assignments

	project_close
}
