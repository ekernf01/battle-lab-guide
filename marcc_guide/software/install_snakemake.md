# Steps to install snakemake on MARCC

```bash
##########################################################
### load required modules                              ###
##########################################################

# load anaconda module version >= 4.6.0
module load  anaconda

# load python
module load python/3.7.4-anaconda 

############################################################
### create and activate a custom conda environment       ###
### to install/update packages without admin privilege   ###
### following instructions from                          ###
### https://www.marcc.jhu.edu/python-environments/.      ###
### see section "Case B. Custom conda environments"      ###
############################################################

# go to a directory to create conda 
# NOTE: MARCC recommends creating conda environments inside ~/work/code/
cd /home-1/asaha6@jhu.edu/python_env/conda # remember to change the directory

# create reqs.yaml file with basic packages
printf "dependencies:\n\
  - python=3.7\n\
  - matplotlib\n\
  - scipy\n\
  - numpy\n\
  - nb_conda_kernels\n\
  - au-eoed::gnu-parallel\n\
  - h5py\n\
  - pip\n\
  - pip:\n\
    - sphinx" > reqs.yaml
    
# install conda environment
conda env update --file reqs.yaml -p ./my_conda_env

# activate conda environment
conda activate /home-net/home-1/asaha6@jhu.edu/python_env/conda/my_conda_env

##############################################################################
### install snakemake using the new enviroment following instructions from ###
### https://snakemake.readthedocs.io/en/stable/tutorial/tutorial.html      ###
##############################################################################

# install mamba
conda install -c conda-forge mamba

# install snakemake using mamba
mamba create -c conda-forge -c bioconda -n snakemake snakemake

# exit from current environment
conda deactivate

# activate snakemake 
conda activate snakemake

# now you may run snakemake commands. test if help works.
snakemake --help
```
