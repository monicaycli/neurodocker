docker run --rm kaczmarj/neurodocker:0.4.3 generate docker \
  -b neurodebian:jessie \
  -p apt \
  -e DOWNLOADS=/tmp/downloads \
  -r 'mkdir -p $DOWNLOADS' \
  -w '$DOWNLOADS' \
  -e FREESURFER_HOME=/usr/local/freesurfer \
  -r 'curl ftp://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/6.0.0/freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz \
  | tar -xz -C /usr/local/' \
  --add-to-entrypoint 'source $FREESURFER_HOME/SetUpFreeSurfer.sh' \
  -e FSLDIR=/usr/local/fsl \
  PATH='$FSLDIR/bin:$PATH' \
  -r 'curl https://fsl.fmrib.ox.ac.uk/fsldownloads/fsl-6.0.0-centos6_64.tar.gz \
  | tar -xz -C /usr/local' \
  --add-to-entrypoint 'source $FSLDIR/etc/fslconf/fsl.sh' \
  -r 'cp /neurodocker/startup.sh /singularity' \
  -r 'mkdir /scratch && mkdir /work && mkdir /apps && mkdir /apps2' \
  -r 'touch $FREESURFER_HOME/license.txt' \
  --install libopenblas-base \
  -e LD_LIBRARY_PATH=/usr/lib/openblas-base/:$LD_LIBRARY_PATH \
  --install git g++ python python-numpy libeigen3-dev zlib1g-dev libqt4-opengl-dev libgl1-mesa-dev libfftw3-dev libtiff5-dev \
  --mrtrix3 version=3.0_RC3 \
  > Dockerfile
