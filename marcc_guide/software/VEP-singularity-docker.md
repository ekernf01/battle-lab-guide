# Installing VEP by using Singularity


## Installing VEP
```bash
# Set custom temporary folder to cache downloads. Recommended if you run out of storage when pulling the docker container.
export SINGULARITY_CACHEDIR=~/scratch/tmp
mkdir -p SINGULARITY_CACHEDIR

# Pull the container
singularity pull docker://ensemblorg/ensembl-vep

# Start a bash shell within the container
singularity shell ensembl-vep.simg

# Inside the bash shell, navigate to VEP repo
cd /opt/vep/src/ensembl-vep

# Set location for downloading cache and plugins. Skip if default folder `$HOME/.vep` has enough space.
CACHE=/scratch/groups/abattle4/victor/vep_cache
ln -s $CACHE $HOME/.vep

# Download cache for GRCh38. It will take up 15GB and be saved to default folder `$HOME/.vep`
perl INSTALL.pl -a c -s homo_sapiens -y GRCh38
```
**Remember to exit the container when done installing and setting up VEP**


## Running VEP with singularity
```bash
singularity exec ensembl-vep.simg vep -i [input.vcf] [other vep arguments]
```


## Installing loftee
```bash
# create Plugins folder inside the cache folder
mkdir -p $HOME/.vep/Plugins

# clone loftee repo and switch to GRCh38 branch
git clone https://github.com/konradjk/loftee
cd loftee
git pull
git checkout grch38

# download required GERP scores bigwig
wget https://personal.broadinstitute.org/konradk/loftee_data/GRCh38/gerp_conservation_scores.homo_sapiens.GRCh38.bw
```


## Run VEP with loftee
```bash
singularity exec ensembl-vep.simg vep -i [input.vcf] --format vcf --output_file [output.vcf] --vcf --cache --plugin LoF,loftee_path:$HOME/.vep/Plugins/loftee/ --dir_plugins $HOME/.vep/Plugins/loftee/
```
