#!/bin/csh -f
#Script to download enough data to run START_DATE 201522 and END_DATE 201523 for CONUS Domain
#Requires installing aws command line interface
#https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html#cliv2-linux-install
#Total storage required is 44 G
#Note, also download the smk_merge_dates_201512.txt file and installed under your ./emissions directory
#https://github.com/lizadams/singularity-cctm/blob/main/smk_merge_dates_201512.txt

cd ../
aws s3 cp --recursive ./CONUS s3://conus-benchmark-2day
