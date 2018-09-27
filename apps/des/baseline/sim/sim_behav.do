vlib work
vlog $env(HFHOME)/apps/des/baseline/rtl/*.v
vlog $env(HFHOME)/apps/des/baseline/bench/des_test_po.v
vsim test
run -all
quit -code 1
