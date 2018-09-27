vlib work
vlog $HFHOME/apps/aes_base/rtl/round.v
vlog $HFHOME/apps/aes_base/rtl/table.v
vlog $HFHOME/apps/aes_base/sim/aes_256.vo 
vlog $HFHOME/apps/aes_base/testbench/test_aes_256.v
vsim -L fourteennm_ver -L altera_mf_ver -L lpm_ver -L altera_ver work.test_aes_256
run -all
