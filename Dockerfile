# Generated by Neurodocker version 0.4.3-2-g01cdd22
# Timestamp: 2019-05-06 19:20:14 UTC
# 
# Thank you for using Neurodocker. If you discover any issues
# or ways to improve this software, please submit an issue or
# pull request on our GitHub repository:
# 
#     https://github.com/kaczmarj/neurodocker

FROM neurodebian:jessie

ARG DEBIAN_FRONTEND="noninteractive"

ENV LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    ND_ENTRYPOINT="/neurodocker/startup.sh"
RUN export ND_ENTRYPOINT="/neurodocker/startup.sh" \
    && apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           apt-utils \
           bzip2 \
           ca-certificates \
           curl \
           locales \
           unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG="en_US.UTF-8" \
    && chmod 777 /opt && chmod a+s /opt \
    && mkdir -p /neurodocker \
    && if [ ! -f "$ND_ENTRYPOINT" ]; then \
         echo '#!/usr/bin/env bash' >> "$ND_ENTRYPOINT" \
    &&   echo 'set -e' >> "$ND_ENTRYPOINT" \
    &&   echo 'if [ -n "$1" ]; then "$@"; else /usr/bin/env bash; fi' >> "$ND_ENTRYPOINT"; \
    fi \
    && chmod -R 777 /neurodocker && chmod a+s /neurodocker

ENTRYPOINT ["/neurodocker/startup.sh"]

ENV DOWNLOADS="/tmp/downloads"

RUN mkdir -p $DOWNLOADS

WORKDIR $DOWNLOADS

ENV FREESURFER_HOME="/usr/local/freesurfer"

RUN curl ftp://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/6.0.0/freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz \
         | tar -xz -C /usr/local/

RUN sed -i '$isource $FREESURFER_HOME/SetUpFreeSurfer.sh' $ND_ENTRYPOINT

ENV FSLDIR="/usr/local/fsl" \
    PATH="$FSLDIR/bin:$PATH"

RUN curl https://fsl.fmrib.ox.ac.uk/fsldownloads/fsl-6.0.0-centos6_64.tar.gz \
         | tar -xz -C /usr/local

RUN sed -i '$isource $FSLDIR/etc/fslconf/fsl.sh' $ND_ENTRYPOINT

RUN cp /neurodocker/startup.sh /singularity

RUN mkdir /scratch && mkdir /work && mkdir /apps && mkdir /apps2

RUN touch $FREESURFER_HOME/license.txt

RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           libopenblas-base \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV LD_LIBRARY_PATH="/usr/lib/openblas-base/:"

RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           git \
           g++ \
           python \
           python-numpy \
           libeigen3-dev \
           zlib1g-dev \
           libqt4-opengl-dev \
           libgl1-mesa-dev \
           libfftw3-dev \
           libtiff5-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PATH="/opt/mrtrix3-3.0_RC3/bin:$PATH"
RUN echo "Downloading MRtrix3 ..." \
    && mkdir -p /opt/mrtrix3-3.0_RC3 \
    && curl -fsSL --retry 5 https://dl.dropbox.com/s/2oh339ehcxcf8xf/mrtrix3-3.0_RC3-Linux-centos6.9-x86_64.tar.gz \
    | tar -xz -C /opt/mrtrix3-3.0_RC3 --strip-components 1

RUN echo '{ \
    \n  "pkg_manager": "apt", \
    \n  "instructions": [ \
    \n    [ \
    \n      "base", \
    \n      "neurodebian:jessie" \
    \n    ], \
    \n    [ \
    \n      "env", \
    \n      { \
    \n        "DOWNLOADS": "/tmp/downloads" \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "run", \
    \n      "mkdir -p $DOWNLOADS" \
    \n    ], \
    \n    [ \
    \n      "workdir", \
    \n      "$DOWNLOADS" \
    \n    ], \
    \n    [ \
    \n      "env", \
    \n      { \
    \n        "FREESURFER_HOME": "/usr/local/freesurfer" \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "run", \
    \n      "curl ftp://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/6.0.0/freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz \\\\n  | tar -xz -C /usr/local/" \
    \n    ], \
    \n    [ \
    \n      "add_to_entrypoint", \
    \n      "source $FREESURFER_HOME/SetUpFreeSurfer.sh" \
    \n    ], \
    \n    [ \
    \n      "env", \
    \n      { \
    \n        "FSLDIR": "/usr/local/fsl", \
    \n        "PATH": "$FSLDIR/bin:$PATH" \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "run", \
    \n      "curl https://fsl.fmrib.ox.ac.uk/fsldownloads/fsl-6.0.0-centos6_64.tar.gz \\\\n  | tar -xz -C /usr/local" \
    \n    ], \
    \n    [ \
    \n      "add_to_entrypoint", \
    \n      "source $FSLDIR/etc/fslconf/fsl.sh" \
    \n    ], \
    \n    [ \
    \n      "run", \
    \n      "cp /neurodocker/startup.sh /singularity" \
    \n    ], \
    \n    [ \
    \n      "run", \
    \n      "mkdir /scratch && mkdir /work && mkdir /apps && mkdir /apps2" \
    \n    ], \
    \n    [ \
    \n      "run", \
    \n      "touch $FREESURFER_HOME/license.txt" \
    \n    ], \
    \n    [ \
    \n      "install", \
    \n      [ \
    \n        "libopenblas-base" \
    \n      ] \
    \n    ], \
    \n    [ \
    \n      "env", \
    \n      { \
    \n        "LD_LIBRARY_PATH": "/usr/lib/openblas-base/:" \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "install", \
    \n      [ \
    \n        "git", \
    \n        "g++", \
    \n        "python", \
    \n        "python-numpy", \
    \n        "libeigen3-dev", \
    \n        "zlib1g-dev", \
    \n        "libqt4-opengl-dev", \
    \n        "libgl1-mesa-dev", \
    \n        "libfftw3-dev", \
    \n        "libtiff5-dev" \
    \n      ] \
    \n    ], \
    \n    [ \
    \n      "mrtrix3", \
    \n      { \
    \n        "version": "3.0_RC3" \
    \n      } \
    \n    ] \
    \n  ] \
    \n}' > /neurodocker/neurodocker_specs.json
