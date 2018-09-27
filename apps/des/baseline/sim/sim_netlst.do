vlib work
vlog $env(HFHOME)/apps/des/baseline/rtl/*.v
vlog $env(HFHOME)/apps/des/baseline/bench/test_des.v
vsim -L fourteennm_ver -L altera_mf_ver -L lpm_ver -L altera_ver test_des
run -all
