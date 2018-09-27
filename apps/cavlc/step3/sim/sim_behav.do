vlib work
vlog $env(HFHOME)/apps/cavlc/step3/rtl/*.v +incdir+$env(HFHOME)/apps/cavlc/step3/inc
vlog $env(HFHOME)/common/regchain.v
vlog $env(HFHOME)/apps/cavlc/step3/tbench/*.v +incdir+$env(HFHOME)/apps/cavlc/step3/inc
cp $env(HFHOME)/apps/cavlc/step3/tbench/input_gen/in.txt ./
vsim cavlc_tb
run -all
set rc [ catch { diff -q out.txt $env(HFHOME)/apps/cavlc/step3/tbench/input_gen/c_out.txt } ]
quit -code $rc
