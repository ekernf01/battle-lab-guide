# MARCC Guide
## Using battle-bigmem
-  **Access to server:** to access this server, log in to MARCC using your normal log in, then `ssh battle-bigmem` using your same password
- **I/O issues:** `battle-bigmem` has been known to throw an `I/O error` occassionally and terminate a job, especially when dealing with large I/O operations. For some ideas on how to address this, refer to the MARCC webpage here: https://www.marcc.jhu.edu/bluecrab-storage-guidelines/. These suggestions primarily have to do with where large files are being written to or read from.
## Being a good lab citizen
- **Keep bigmem's cores available:** To help manage your jobs when using `battle-bigmem`, copy the script from `ninjakiller.sh` into your `~/.bashrc` file. After finishing a session on `battle-bigmem`, use `ninjakiller` to list which jobs you still have running and to cancel the ones you no longer need. For help documentation on using the script, simply call `ninjakiller -h`
  - For a full listing of jobs running, use the `htop` command. The `F9` button can be used in `htop` to kill jobs there too
  - To kill all your jobs and logout, run `ninjakiller go`
## Software tips
- How to install software on MARCC (the basic `module load` function, `Singularity` containers, etc)
- Workflow tools like `snakemake`

