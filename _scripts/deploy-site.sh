#!/bin/bash

scriptdir=$(dirname $0)
webdir=/var/www/plume

/usr/bin/git pull

cd ${scriptdir}/..

bundler exec jekyll build
ret=$?

if [ $ret -ne 0 ] ; then
  echo "Jekyll build failed :-("
  exit -1
fi

rsync --archive --delete _site/ ${webdir}

