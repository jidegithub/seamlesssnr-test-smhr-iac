#!/bin/bash
green='\033[32;40m'
#figure out how to loop backwards
# for file in $(pwd)/*
#   do
#     if [ -d "$file" ]
#       then
#       echo -ne "$reset $(basename $file)"
#       cd $file
#       terraform destroy -auto-approve
#     elif [ -f "$file" ]
#       then
#       echo
#   fi
# done

cd 4_auto_scaling_target_group && terraform destroy -auto-approve -lock=false && cd .. &&
cd 3_alb_target_group && terraform destroy -auto-approve -lock=false && cd .. &&
cd 2_alb && terraform destroy -auto-approve -lock=false && cd .. &&
cd 1_infrastructure && terraform destroy -auto-approve -lock=false && cd .. &&
cd 0_remote_state && terraform destroy -auto-approve -lock=false

echo -ne "$green DESTRUCTION COMPLETE!!!"

