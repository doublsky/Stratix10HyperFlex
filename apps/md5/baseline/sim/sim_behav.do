vlib work
vlog $env(HFHOME)/apps/md5/baseline/rtl/*.v
vlog $env(HFHOME)/apps/md5/baseline/tbench/Md5CoreTest.v +incdir+$env(HFHOME)/apps/md5/baseline/tbench
vsim Md5CoreTest
run -all
quit -code 1
