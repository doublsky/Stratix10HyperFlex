vlib work
vlog $env(HFHOME)/apps/md5/step1/rtl/*.v
vlog $env(HFHOME)/common/regchain.v
vlog $env(HFHOME)/apps/md5/step1/tbench/Md5CoreTest.v +incdir+$env(HFHOME)/apps/md5/step1/tbench
vsim Md5CoreTest
run -all
quit -code 1
