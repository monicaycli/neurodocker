# fsl6_freesurfer6

## Base Image
- neurodebian:jessie

## Additional Software Installed
- [FSL 6.0.0](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki)
- [FreeSurfer 6.0.0](https://surfer.nmr.mgh.harvard.edu/fswiki/FreeSurferWiki)

## Important Directories, Files, and Variables
- `FREESURFER_HOME="/usr/local/freesurfer"`
- `FSLDIR="/usr/local/fsl"`
- `/scratch`
- `/work`
- `/apps`
- `/apps2`
- `/neurodocker/startup.sh`
- `/singularity`

## General Info
- This Docker image is readily compatible to Singularity, such that the
  "runscript" (`/singularity`) is available and identical to the Docker
  entrypoint (`/neurodocker/startup.sh`)
- The file system structure is optimized to work with common high-performance
  computing clusters (e.g., the `/scratch` directory)
- By default, running the container launches `/bin/bash` if no additional
  argument is provided
