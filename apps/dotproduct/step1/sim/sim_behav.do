vlib work
vlog -sv $env(HFHOME)/apps/dotproduct/step1/rtl/*.v
vlog -sv $env(HFHOME)/apps/dotproduct/step1/rtl/*.sv
vlog -sv $env(HFHOME)/apps/dotproduct/step1/tb/dot16_tb.v
vsim dot16_tb
run -all
quit -code 1
