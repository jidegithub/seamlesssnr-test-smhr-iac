#!/bin/bash
set -e
green='\033[32;40m'
reset='\033[0m'

function terraformInit {
  if [ $? -eq 0 ]; then
    echo OK
    echo "running terraform init"
    terraform init
  else
    echo FAIL
    exit 1
  fi 
}

function terraformValidate {
  if [ $? -eq 0 ]; then
    echo OK
    echo "running terraform validate"
    terraform validate
  else
    echo FAIL
    exit 1
  fi
}

function terraformPlanOut {
  if [ $? -eq 0 ]; then
    echo OK
    echo "running terraform plan"
    terraform plan -out="planfile" -lock=false
  else
    echo FAIL
    exit 1
  fi
}

function terraformApply {
  if [ $? -eq 0 ]; then
    echo OK
    echo "running terraform apply"
    terraform apply -lock=false -input=false "planfile" 
  else
    echo FAIL
    exit 1
  fi
}

for file in $(pwd)/*
  do
    if [ -d "$file" ]
      then
      echo
      echo -ne "$reset $(basename $file)"
      echo
      cd $file
      terraform fmt
      terraformInit
      terraformValidate
      terraformPlanOut
      terraformApply
    elif [ -f "$file" ]
      then
      echo
  fi
done

echo -ne "$green Creation of Resources Completed!!!!"