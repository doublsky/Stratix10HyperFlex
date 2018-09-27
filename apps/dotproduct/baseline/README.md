Simulation of baseline dotproduct will not work out-of-box because it contains IPs.
There are two workarounds.

### Generate IP from Quartus
One can generate a `LPM_MULT` IP from Quartus and following link to simulte the required IP.

https://www.intel.com/content/dam/www/programmable/us/en/pdfs/literature/ug/ug-20093.pdf

### Use Behavior-equivalent RTL
Use `rtl/mBit_nMult.simv` instead of `rtl/mBit_nMult.v` for simulation.
