#!/bin/bash

srcdir=/home/USER/source/svplume
webdir=/var/www/plume

export GEM_HOME=/home/USER/gems
export PATH=${PATH}:${GEM_HOME}/bin

cd ${srcdir}

/usr/bin/git pull

bundler exec jekyll build
ret=$?

if [ $ret -ne 0 ] ; then
  echo "Jekyll build failed :-("
  exit -1
fi

rsync --archive --delete _site/ ${webdir}

