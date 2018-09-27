vlib work
vlog -sv $env(HFHOME)/apps/dotproduct/baseline/rtl/*.v
vlog -sv $env(HFHOME)/apps/dotproduct/baseline/rtl/*.sv
vlog -sv $env(HFHOME)/apps/dotproduct/baseline/tb/dot16_tb.v
vsim -L lpm_ver dot16_tb
run -all
quit -code 1
