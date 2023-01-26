#!/bin/bash
dir=`pwd`/galaxy
job=`pwd`/job

docker run \
	-e "HOME=$HOME" \
	-e "_GALAXY_JOB_HOME_DIR=$_GALAXY_JOB_HOME_DIR" \
	-e "_GALAXY_JOB_TMP_DIR=$_GALAXY_JOB_TMP_DIR" \
	-p 4030:4030  \
	-v ${dir}:${dir}:ro \
	-v ${job}:${job}:rw \
	-v ${job}/working:${job}/working:rw \
	-v ${dir}/database/objects:${dir}/database/objects:ro \
	"$1"
