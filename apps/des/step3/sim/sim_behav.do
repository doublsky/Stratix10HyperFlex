vlib work
vlog $env(HFHOME)/apps/des/step3/rtl/*.v
vlog $env(HFHOME)/common/regchain.v
vlog $env(HFHOME)/apps/des/step3/bench/des_test_po.v
vsim test
run -all
quit -code 1
