vlib work
vlog $env(HFHOME)/apps/cavlc/baseline/rtl/*.v +incdir+$env(HFHOME)/apps/cavlc/baseline/inc
vlog $env(HFHOME)/apps/cavlc/baseline/tbench/*.v +incdir+$env(HFHOME)/apps/cavlc/baseline/inc
cp $env(HFHOME)/apps/cavlc/baseline/tbench/input_gen/in.txt ./
vsim cavlc_tb
run -all
set rc [ catch { diff -q out.txt $env(HFHOME)/apps/cavlc/baseline/tbench/input_gen/c_out.txt } ]
quit -code $rc
