# Computing cluster guide

Cloud computing is notoriously expensive. As a more affordable way to access large-scale computing, the Battle Lab invests in a share of the resources at a JHU-wide computing cluster. There is extensive info on the [Advanced Research Computing at Hopkins site](https://www.arch.jhu.edu/tutorials/). This is a typical academic computing cluster, with the following typical features:

- You would typically log in with ssh, landing in a shell in a Linux operating system. 
- It is a multi-user system, so many people are logged in issuing commands at once.

Because it is a multi-user system:

- it would disrupt other users' work if you run compute-heavy commands directly after login. Instead, you should describe your resource needs to a load balancer called Slurm, and it will put you in the queue and try to schedule you some time.
- there is a limited ability to install your own software. Common solutions are conda, renv, venv, and singularity, all of which allow you to install software in a project-specific way instead of globally.

Look at their [guide](https://www.arch.jhu.edu/guide/) and [tutorials](https://www.arch.jhu.edu/tutorials/) for details. 

TODO: update these dead links

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
 - [Snakemake: A template to develop and run your project on MARCC](https://github.com/battle-lab/snakemake)
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
 - **Record any data you put in `lab_data` in the README file there**: In an effort to keep track of all the data we have accumulated as a lab and to reduce redundancy, any time you add data to the `/work-zfs/abattle4/lab_data` directory, please put a `README` file in the directory with your data and a note in the `/work-zfs/abattle4/lab_data/README` file to document it. Thanks!
## TODO
- How to install software on MARCC (the basic `module load` function, `Singularity` containers, etc)
- Workflow tools like `snakemake`

