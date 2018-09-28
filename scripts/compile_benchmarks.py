"""
Run batch jobs 
"""

import os
import subprocess as sp
import argparse

def compile(src_dir, sim_dir, script_dir, work_dir, args):
    old_path = os.getcwd()

    # create project
    os.chdir(work_dir)
    ip_path = os.path.join(src_dir, "ip")
    if os.path.exists(ip_path):
        ipfiles = os.listdir(os.path.join(src_dir, "ip"))
        for ipfile in ipfiles:
            if ".ip" in ipfile:
                if not os.path.exists(os.path.join(work_dir, ipfile)):
                    os.symlink(os.path.join(src_dir, "ip", ipfile), ipfile)
    batch_tcl_script = os.path.join(script_dir, "create_project.tcl")
    tcl_cmd = "source {}\; create_project {}".format(batch_tcl_script, src_dir)
    sp.check_call("quartus_sh --tcl_eval {}".format(tcl_cmd), shell=True)

    # generate IPs
    if os.path.exists(ip_path):
        sp.check_call(["quartus_ipgenerate", "--generate_project_ip_files", "--simulation=verilog", "top"])
        sp.check_call(["ip-setup-simulation", "--quartus-project=top"])

    # verify correctness
    if not args.no_sim:
        os.chdir(sim_dir)
        sim_script = os.path.join(src_dir, "sim", "sim_behav.do")
        sp.check_call(["vsim", "-c", "-do", sim_script])

    # now compile
    os.chdir(work_dir)
    sp.check_call(["quartus_sh", "--flow", "compile", "top"])

    # design space exploration
    if not args.no_dse:
        sp.check_call([
            "quartus_dse",
            "--num-seeds", str(args.num_seeds),
            "--num-concurrent", "2",
            "--explore", "seed",
            "top"
        ])

    # all done, go back to original dir
    os.chdir(old_path)


if __name__ == "__main__":
    # cli parser
    parser = argparse.ArgumentParser(description="run batch compilation.")
    parser.add_argument("jobs", help="path to job list file")
    parser.add_argument("--hfhome", default=".", help="path to root of hyperflex home dir, default to current directory")
    parser.add_argument("--sim-dir", default="./sim", help="path to sim dir, default to ./sim under current directory")
    parser.add_argument("--syn-dir", default="./syn", help="path to syn dir, default to ./syn under current directory")
    parser.add_argument("--no-sim", action="store_true", help="do not simulate functionality")
    parser.add_argument("--no-dse", action="store_true", help="do not run design space exp")
    parser.add_argument("--num-seeds", type=int, default=5, help="number of seeds in dse, default to 5")
    args = parser.parse_args()

    # turn relative path to absolute
    args.hfhome = os.path.abspath(args.hfhome)
    args.sim_dir = os.path.abspath(args.sim_dir)
    args.syn_dir = os.path.abspath(args.syn_dir)

    # add hfhome to env
    os.environ["HFHOME"] = args.hfhome

    # iterate jobs
    with open(args.jobs, "r") as job_list:
        for job in job_list:
            job = job.rstrip()
            # get sources
            src_dir = os.path.join(args.hfhome, "apps", job)
            if not os.path.isdir(src_dir):
                raise Exception("Source directory for job {} does not exist".format(job))
    
            # create work dir
            work_dir = os.path.join(args.syn_dir, job)
            if not os.path.isdir(work_dir):
                os.makedirs(work_dir)
    
            # create sim dir
            sim_dir = os.path.join(args.sim_dir, job)
            if not os.path.isdir(sim_dir):
                os.makedirs(sim_dir)
    
            # get script_dir
            script_dir = os.path.join(args.hfhome, "scripts")
            if not os.path.isdir(script_dir):
                raise Exception("Scripts directory does not exist")
    
            # now compile
            compile(src_dir, sim_dir, script_dir, work_dir, args)
