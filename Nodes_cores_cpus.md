(written by Ashis S. in January 2021)
# Nodes / cores / CPUs:
This [reddit post](https://www.reddit.com/r/HPC/comments/ag86bc/node_cpu_core_thread/) has a good brief description of nodes, cores, cpus, and threads. I'm copying it here:
```
Briefly: A node is the physical box containing a computer. An hpc cluster usually has several nodes.
Each motherboard in each node might have several sockets and can have a cpu chip in each socket.
Each cpu has multiple cores.
Depending on your configuration each core can run multiple threads to have several processes running at once (our cluster has multi threading turned off so 1core=1thread).
```

In informal words, each computer has a physical computing unit or a processing unit that can perform only one basic operation (add, subtract, or, xor, etc.) at a time. It is called a `core.`

Our laptops or personal computers come with 2-cores (dual-core), 4-cores (quad-core), 5-cores, etc. These cores do not work independently, rather work in a coordinated way. A `CPU` does the coordination between these cores.
A `node` is a physical box with multiple CPUs (essentially many cores), memories and hard-disks. Of course, the node coordinates them. battle-bigmem is such a node, bc-login02 is another such node.
Finally, a `cluster` has multiple nodes.

Note that early computers had only one core, but still we could run multiple programs. CPU intelligently shares the core among multiple programs. Say program-A used the core for 5 ms, then program-B for 3ms, again program-A for 2 ms, and so on. The switching between programs is so fast that we do not notice any change. This is called `threading`. It does not increase the total computing capacity, rather shares the same capacity. In fact, threading has additional cost of program-switching decreasing the total capacity. Some special hardware makes threading more efficient. While threading can be effective especially with intensive I/O operations, it does not increase computing capacity. These days when we say multi-threads, we often mean multi-cores that offer true parallel executions (not pseudo-parallel).

## Programming / Coding:
While there are many hierarchies as described above, we generally do not think of these hierarchies when we write a program. From a program's perspective, it needs memories and cores (computing power) -- no matter which hierarchy (cluster/node/cpu) manages them. (This is a simplified view of programming. Of course, we can efficiently handle these hierarchies in our programs).

Each program -- a sequence of instructions -- generally uses a single core. Even if we have multiple cores, we generally cannot run these instructions in parallel. In some cases, we are able to run instructions in parallel if those instructions do not depend on each other. R's parallel package, Python's multiprocessing package, etc. support running such parallel instructions (of course, there are other packages). Generally, we have to mention how many cores we want to use for parallel execution. If we do not mention, the package uses a default number of cores. Often the default number is the number of cores available (this is the case for mclapply() function in R).

Running multiple instructions in parallel would reduce the total time to complete a program. For example, if one core takes 100 min to finish a job, 4-cores might finish it in 100/4=25 min. But remember that not all instructions can run in parallel. Also, there is an additional cost of dispatching the instructions to different cores and then collecting outcomes from each of them. So, in practice, it would take >25 min. Running parallel instructions might also need more memory than sequential instructions.

## Running jobs on MARCC:
When we run jobs on MARCC or any cluster, we have to mention how many cores and how much memory we will use, because the cluster needs to assign these resources for us. The cluster would charge us for these resources.
We should ask for exactly the number of cores and memories we plan to use. If our program does not use multiple cores at a time, we should ask for only one core. If we ask more, extra cores will simply be wasted though we will be charged :disappointed:.
Though the number of cores and the amount of memories are two different concepts, MARCC associates them in their charging policy. For 1 core corresponds to ~4.5GB (4916MB) memory in most partitions (shared/lrgmem/debug), ~3.5GB (3583MB) in express/skylake. For simplicity, let's say each core corresponds to 4GB for the rest of the discussion. If we request 2 cores, we will be automatically assigned 2*4=8GB memory. If we request 10GB memory, we will automatically assigned ceiling(10/4)=3 cores. Once, someone from MARCC told me to ignore memory, to use just cores to allocate necessary resources.
Note: this association between cores and memories is only for MARCC's charging policy, it does not determine how many cores our programs will use. For example, if our program uses only 1 core (no parallel programming), but it uses 10GB memory, we have to ask for 3 cores. Two cores will remain unused. If possible, we should parallelize our programs to use those 2 cores.
As I said before, generally our program cares about the total memory and the total number of cores. It does not care about if the memories/cores are coming from a single CPU or multiple. So, we need not care about memory-per-cpu, memory-per-node, or core-per-node as long as the total amount is ok. Those who carefully utilize memory-per-core-level details, please ignore this discussion-- you know what you are doing.
So, I find the following variables useful when I submit a job on MARCC.

* --nodes: number of nodes
* --ntasks: number of tasks (cores) per node
* --time: total time
* --mem: total memory per node
* 
`nodes * ntasks` determines the total number of cores. I generally use nodes=1. MARCC has some guidelines on how to use nodes and ntasks when you use many cores. I can't find it though. Given the total memory is associated with the total number of cores, I completely ignore mem.
A typical slurm job script header looks like below:

```
#!/bin/sh
#SBATCH --partition=express
#SBATCH --workdir=/work-zfs/abattle4/ashis/progres/scnet/gtex_v7/Muscle_Skeletal.v7.corrected.VAR.500/jobs
#SBATCH --time=0:30:0
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --job-name=Muspcorr
#SBATCH --output=/work-zfs/abattle4/ashis/progres/scnet/gtex_v7/Muscle_Skeletal.v7.corrected.VAR.500/jobs/myscript.sh.%j.out
#SBATCH --error=/work-zfs/abattle4/ashis/progres/scnet/gtex_v7/Muscle_Skeletal.v7.corrected.VAR.500/jobs/ myscript.sh.%j.err
Note: useful details about running jobs on marcc are available here: https://www.marcc.jhu.edu/getting-started/running-jobs/. For further details, have a look at the slurm manual: https://slurm.schedmd.com/sbatch.html.
```
