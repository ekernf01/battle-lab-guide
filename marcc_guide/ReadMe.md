# MARCC Guide
## Scientific Computing resources
If you have questions about using Linux on MARCC, check out the tutorials provided by the MARCC group here: https://www.marcc.jhu.edu/training/tutorial-series/
and here: https://marcc-hpc.github.io/esc/. Core topics include: *custom environments, SLURM scheduling, singularity containers, code profiling and parallelization*.
Resources for many other common lab questions are available here too, including:
 - [Getting started](https://www.marcc.jhu.edu/training/intro-sessions/)
 - [Upload/download files to MARCC via command line (see *Storing and accessing data*)](https://www.marcc.jhu.edu/getting-started/basic/) or [via Globus](https://www.marcc.jhu.edu/transfer-data-globus/)
 - [Issues installing *packages in R*?](https://www.marcc.jhu.edu/managing-r-packages-a-case-study/)
 - [Can't run a program or need a *docker/singularity*?](https://www.marcc.jhu.edu/managing-r-packages-a-case-study/)
 - [Interactive sessions in RStudio or Jupyter Notebooks](https://www.marcc.jhu.edu/getting-started/interactive-development/)
 - [Managing multiple jobs in an interactive node *(screen/htop)*](https://www.marcc.jhu.edu/simple-profiling-with-the-top-utility/)
 - [Submitted jobs taking too long to start](https://www.marcc.jhu.edu/job-priority-and-the-slurm-scheduler/)
 - [Clean up your home directory if you get locked out (via *Globus*)](https://www.marcc.jhu.edu/troubleshoot/globus-clean-home/)
 - [I/O Issues](https://www.marcc.jhu.edu/bluecrab-storage-guidelines/)
 
Lab members have compiled other resources that may be useful for various jobs, including:
 - [Installing snakemake](https://github.com/battle-lab/battle-lab-guide/blob/master/marcc_guide/software/install_snakemake.md)
 - [Visualizing images on MARCC via X11 forwarding](https://github.com/battle-lab/battle-lab-guide/blob/master/marcc_guide/x11_forwarding.md)
 - [Install PEER using Singularity](https://github.com/battle-lab/battle-lab-guide/blob/master/marcc_guide/software/PEER-singularity-docker.md)

## Using battle-bigmem
-  **Access to server:** to access this server, log in to MARCC using your normal log in, then `ssh battle-bigmem` using your same password
- **I/O issues:** `battle-bigmem` has been known to throw an `I/O error` occassionally and terminate a job, especially when dealing with large I/O operations. For some ideas on how to address this, refer to the MARCC webpage here: https://www.marcc.jhu.edu/bluecrab-storage-guidelines/. These suggestions primarily have to do with where large files are being written to or read from.
- **Interactive sessions:** Since the standard SLURM job scheduler doesn't work on `bigmem`, to call an Rstudio interactive session simply use the direct command `rstudio_server_start` instead of an `sbatch` command.
- **Multiplexing/running multiple jobs at once:** there are several approaches to doing this, including `nohup` + `&`, or multiplexers like `tmux` or `screen`. Check out the (Additional Resources Page)[https://github.com/battle-lab/battle-lab-guide/blob/master/marcc_guide/additional_resources.md] for some good tutorials on these.
## Being a good lab citizen
- **Keep bigmem's cores available:** To help manage your jobs when using `battle-bigmem`, copy the script from `ninjakiller.sh` into your `~/.bashrc` file. After finishing a session on `battle-bigmem`, use `ninjakiller` to list which jobs you still have running and to cancel the ones you no longer need. For help documentation on using the script, simply call `ninjakiller -h`
  - For a full listing of jobs running, use the `htop` command. The `F9` button can be used in `htop` to kill jobs there too
  - To kill all your jobs and logout, run `ninjakiller go`
## TODO
- How to install software on MARCC (the basic `module load` function, `Singularity` containers, etc)
- Workflow tools like `snakemake`

