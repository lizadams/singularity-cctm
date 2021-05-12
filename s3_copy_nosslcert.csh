#!/bin/csh -f
#Script to download enough data to run START_DATE 201522 and END_DATE 201523 for CONUS Domain
#Requires installing aws command line interface
#https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html#cliv2-linux-install
#Total storage required is 44 G

aws --no-verify-ssl s3 cp --recursive --exclude "*" --include "*151222" --include "*151223" s3://edap-oar-data-commons/2016_Modeling_Platform/CMAQ_Input/MCIP ./MCIP
aws --no-verify-ssl s3 cp --recursive --exclude "*" --include "*151222*" --include "*151223*" s3://edap-oar-data-commons/2016_Modeling_Platform/CMAQ_Input/emissions ./emissions
aws --no-verify-ssl s3 cp --recursive --exclude "*" --include "*151222*" --include "*151223*" --include "*stack_groups*" s3://edap-oar-data-commons/2016_Modeling_Platform/CMAQ_Input/emissions ./emissions
aws --no-verify-ssl s3 cp --recursive --exclude "*" --include "*160101*" --include "*160102*"  s3://edap-oar-data-commons/2016_Modeling_Platform/CMAQ_Input/emissions ./emissions
aws --no-verify-ssl s3 cp --recursive s3://edap-oar-data-commons/2016_Modeling_Platform/CMAQ_Input/emissions/othpt ./emissions/othpt
aws --no-verify-ssl s3 cp --recursive --exclude "*" --include "12US1_surf.ncf" --include "2011_US1_soil.nc" --include "beld3_12US1_459X299_output_a.ncf" s3://edap-oar-data-commons/2016_Modeling_Platform/CMAQ_Input .
aws --no-verify-ssl s3 cp --recursive --exclude "*" --include "*151222*" --include "*151223*"  s3://edap-oar-data-commons/2016_Modeling_Platform/CMAQ_Input/BCON ./BCON
aws --no-verify-ssl s3 cp --recursive --exclude "*" --include "*GRIDDESC*" s3://edap-oar-data-commons/2016_Modeling_Platform/CMAQ_Input/ ./
