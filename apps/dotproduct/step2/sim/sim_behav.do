vlib work
vlog -sv $env(HFHOME)/apps/dotproduct/step2/rtl/*.v
vlog -sv $env(HFHOME)/apps/dotproduct/step2/rtl/*.sv
vlog -sv $env(HFHOME)/apps/dotproduct/step2/tb/dot16_tb.v
vsim dot16_tb
run -all
quit -code 1
