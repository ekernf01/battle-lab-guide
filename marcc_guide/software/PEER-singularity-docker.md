# Installing PEER by using Singularity

Numerous people have had [issues](https://github.com/mz2/peer/issues/4#issuecomment-445119210) installing PEER according to the official [instructions](https://github.com/PMBio/peer/wiki/Installation-instructions)

We can install PEER on MARCC via [docker file](https://github.com/RTIInternational/code_docker_lib/blob/master/peer/Dockerfile) / [docker hub](https://hub.docker.com/r/bryancquach/peer) and singularity. Check the installation by going through the [PEER Tutorial](https://github.com/PMBio/peer/wiki/Tutorial).

Installing PEER
```bash
# load singularity
module load singularity/2.6.0

# download docker image from dockerhub
singularity pull docker://bryancquach/peer:1.3
```

Run PEER as command line tool from the container
```bash
singularity run peer-1.3.simg --help
```

Run PEER in R
```bash
# Start a bash shell within the container
singularity shell peer-1.3.simg

# Start R
R
> library(peer)
> help(peer)
```

Run PEER in python. Note that PEER is only compatible with python 2
```bash
# Start a bash shell within the container
singularity shell peer-1.3.simg

# Start python
python
>>> import peer
>>> help(peer)
```
