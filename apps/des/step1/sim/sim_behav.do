vlib work
vlog $env(HFHOME)/apps/des/step1/rtl/*.v
vlog $env(HFHOME)/common/regchain.v
vlog $env(HFHOME)/apps/des/step1/bench/des_test_po.v
vsim test
run -all
quit -code 1
